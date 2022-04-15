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
	pamixer --increase 5 &
	kill -34 "$(cat ~/.cache/pidofbar)"
}

svoldown() {
	pamixer --decrease 5 &
	kill -34 "$(cat ~/.cache/pidofbar)"
}

svolmute() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle &
	kill -34 "$(cat ~/.cache/pidofbar)"
}
