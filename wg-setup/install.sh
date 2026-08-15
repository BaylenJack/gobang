#!/bin/bash
# WireGuard 一键安装脚本 - 通过 ECS
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "请用 sudo 跑，例如： curl -sL ... | sudo bash"
  exit 1
fi

echo "▶ [1/4] 安装 wireguard-tools..."
if command -v apt >/dev/null 2>&1; then
  apt update -qq && apt install -y -qq wireguard-tools
elif command -v dnf >/dev/null 2>&1; then
  dnf install -y -q wireguard-tools
else
  echo "❌ 未识别的包管理器"
  exit 1
fi

echo "▶ [2/4] 拉取配置..."
mkdir -p /etc/wireguard
curl -fsSL "https://raw.githubusercontent.com/BaylenJack/gobang/main/wg-setup/ubuntu24.conf" -o /etc/wireguard/wg0.conf
chmod 600 /etc/wireguard/wg0.conf

echo "▶ [3/4] 启动 WireGuard..."
wg-quick up wg0

echo "▶ [4/4] 验证..."
sleep 2
if wg show wg0 | grep -q "latest handshake"; then
  echo ""
  echo "✅ VPN 已通！验证:  curl ifconfig.me  (应返回 47.82.0.187)"
else
  echo ""
  echo "⚠ 还没握手. 排查: sudo wg show / sudo journalctl -u wg-quick@wg0"
fi
