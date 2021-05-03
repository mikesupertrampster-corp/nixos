#!/usr/bin/env bash

kill $(pidof polybar)
while pgrep -x polybar >/dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --quiet --reload top &
done
