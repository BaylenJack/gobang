#!/bin/bash
# WireGuard 一键安装脚本
set -e
[ "1000" -ne 0 ] && { echo "请用 sudo 跑"; exit 1; }
apt update -qq && apt install -y -qq wireguard-tools
curl -s "https://raw.githubusercontent.com/BaylenJack/gobang/main/wg-setup/ubuntu24.conf" -o /etc/wireguard/wg0.conf
chmod 600 /etc/wireguard/wg0.conf
wg-quick up wg0
echo ""
echo "✅ 完成！"
echo "  sudo wg show"
echo "  curl ifconfig.me  （应返回 47.82.0.187）"
