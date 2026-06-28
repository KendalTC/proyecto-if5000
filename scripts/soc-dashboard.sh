#!/bin/bash

echo "===== SOC DASHBOARD ====="
echo "Blocked IPs:"
sudo fail2ban-client status sshd | grep "Banned IP list"

echo ""
echo "System status:"
uptime

echo ""
echo "Recent bans:"
sudo tail -n 10 /var/log/fail2ban.log | grep Ban
