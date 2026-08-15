#!/bin/bash
# WireGuard 一键安装脚本 - 通过 ECS 公网
set -e

# 检查 root
if [ "$(id -u)" -ne 0 ]; then
  echo "请用 sudo 跑，比如： curl ... | sudo bash"
  exit 1
fi

echo "▶ [1/4] 安装 wireguard-tools..."
if command -v apt >/dev/null 2>&1; then
  apt update -qq
  apt install -y -qq wireguard-tools
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y -q wireguard-tools
elif command -v yum >/dev/null 2>&1; then
  yum install -y -q wireguard-tools
else
  echo "❌ 未识别的包管理器，请手动装 wireguard"
  exit 1
fi

echo "▶ [2/4] 拉取 WireGuard 配置..."
mkdir -p /etc/wireguard
curl -fsSL "https://raw.githubusercontent.com/BaylenJack/gobang/main/wg-setup/ubuntu24.conf" \
  -o /etc/wireguard/wg0.conf
chmod 600 /etc/wireguard/wg0.conf

echo "▶ [3/4] 启动 WireGuard..."
wg-quick up wg0

echo "▶ [4/4] 验证..."
sleep 2
if wg show wg0 | grep -q "latest handshake"; then
  echo ""
  echo "✅ VPN 已通！验证出口 IP："
  echo "   curl ifconfig.me   （应返回 47.82.0.187）"
else
  echo ""
  echo "⚠ WireGuard 已启动但还没握手。检查："
  echo "   sudo wg show"
  echo "   sudo journalctl -u wg-quick@wg0 -n 30"
fi
