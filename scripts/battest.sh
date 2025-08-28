#!/usr/bin/env bash

if [ $# -ne 1 ]; then
    echo "Usage: battest.sh <filepath>"
    exit 1
fi

out_file="$1"
> "$out_file"

while true; do
    echo "$(date +%H:%M:%S) - $(cat /sys/class/power_supply/BAT0/capacity)%" 
    echo "$(date +%H:%M:%S) - $(cat /sys/class/power_supply/BAT0/capacity)%" >> "$out_file"
    sleep 1
done
