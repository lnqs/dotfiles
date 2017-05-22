#!/bin/bash

displays=$(xrandr -q | grep 'connected')
xrandr_args=""
prev_active=""

while read line; do
    output=$(echo "$line" | cut -d' ' -f1)
    status=$(echo "$line" | cut -d' ' -f2)

    xrandr_args="$xrandr_args --output $output"

    if [[ "$status" == "connected" ]]; then
        xrandr_args="$xrandr_args --preferred"

        if [[ -n "$prev_active" ]]; then
            xrandr_args="$xrandr_args --right-of $prev_active"
        fi

        prev_active="$output"
    else
        xrandr_args="$xrandr_args --off"
    fi
done <<< "$displays"

xrandr $xrandr_args

