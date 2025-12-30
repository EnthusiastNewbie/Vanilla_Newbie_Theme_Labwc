#!/bin/bash
killall -q waybar
while pgrep -x waybar >/dev/null; do sleep 1; done
sleep 1
waybar > /tmp/waybar.log 2>&1 &
