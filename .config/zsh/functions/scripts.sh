#!/bin/sh

nv_power() {
	cat /sys/bus/pci/devices/0000:01:00.0/power_state
}

nv_settings() {
	nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings
}

vids() {
	vlc "$(find ~/Videos/. -name "*.*" | dmenu -l 30 -i -p 'Select video: ')"
}

pacelist() {
	expac --timefmt='%Y-%m-%d %T' '%l\t%n\t:%w' | sort | grep -i 'explicit' | tail -n 200 | awk -F: '{print $1 $2 $3}'
}

netS() {
	DT=$(echo -e '' | dmenu -c -p "File or directory: ")
	IT=$(echo -e '' | dmenu -c -p "ip extension 192.168.: ")

	echo "Exporting file ${DT} to ip 192.168.${IT}"

	tar cf - ${DT} | pv | netcat 192.168.${IT} 7000
}

netR() {
	netcat -l -p 7000 | pv | tar x
}
