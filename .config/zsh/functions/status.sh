#!/bin/sh

slup() {
	light -A 5 &
	kill -35 "$(cat ~/.cache/pidofbar)"
}

sldowm() {
	light -U 5 &
	kill -35 "$(cat ~/.cache/pidofbar)"
}

svolup() {
	pactl set-sink-volume @DEFAULT_SINK@ +5% &
	kill -34 "$(cat ~/.cache/pidofbar)"
}

svoldown() {
	pactl set-sink-volume @DEFAULT_SINK@ -5% &
	kill -34 "$(cat ~/.cache/pidofbar)"
}

svolmute() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle &
	kill -34 "$(cat ~/.cache/pidofbar)"
}
