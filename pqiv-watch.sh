#!/usr/bin/env bash

export DISPLAY="${DISPLAY:-:0}"

# Change this if the GUI session belongs to another user.
export XAUTHORITY="${XAUTHORITY:-/home/localexhibits/.Xauthority}"

IMAGE_DIRECTORY="/home/localexhibits/SEMA"
OUTPUT_NAME="HDMI-1"

while true; do
    # Wait until the configured display is connected.
    while ! xrandr --query 2>/dev/null |
        awk -v output="$OUTPUT_NAME" '$1 == output && $2 == "connected" { found=1 } END { exit !found }'
    do
        sleep 2
    done

    # Re-enable the display after it reconnects.
    xrandr --output "$OUTPUT_NAME" --auto 2>/dev/null || true

    # Start pqiv and wait for it to exit.
    /usr/bin/pqiv \
        -i \
        -t \
        --slideshow \
        -f \
        --slideshow-interval=8 \
        --sort \
        --watch-directories \
        "$IMAGE_DIRECTORY"

    # Prevent rapid restart loops while the screen is unavailable.
    sleep 2
done
