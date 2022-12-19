#!/bin/sh

ultra() {
    echo powersupersave >/sys/module/pcie_aspm/parameters/policy &
    echo 'auto' >/sys/bus/usb/devices/1-8/power/control &
    x86_energy_perf_policy power
    asusctl profile -P Quiet &
    xrandr --rate 60
    light -S 15
    rfkill block wlan
    echo "N-key watchced, aggressive powersaving"
}

minimum() {
    echo powersupersave >/sys/module/pcie_aspm/parameters/policy &
    echo 'on' >/sys/bus/usb/devices/1-8/power/control &
    xrandr --rate 144
    x86_energy_perf_policy power &
    asusctl profile -P Quiet &
    asusctl bios -O false &
    rfkill unblock wlan
    echo "Powersave mode with unmonitored N-key"
}

practical() {
    echo powersave >/sys/module/pcie_aspm/parameters/policy &
    echo 'on' >/sys/bus/usb/devices/1-8/power/control &
    x86_energy_perf_policy balance-power &
    asusctl profile -P Balanced &
    asusctl bios -O false &
    echo "Conservative but sensible savings"
}

balance() {
    echo default >/sys/module/pcie_aspm/parameters/policy
    x86_energy_perf_policy balance-performance
    asusctl profile -P Balanced
    asusctl bios -O false &
    echo "all performance governers turned to on-demand"
}

performance() {
    echo performance >/sys/module/pcie_aspm/parameters/policy
    x86_energy_perf_policy balance-performance
    asusctl profile -P Performance
    asusctl bios -O false
    echo "all performance governers turned to high-performance"
}

beast() {
    echo performance >/sys/module/pcie_aspm/parameters/policy
    x86_energy_perf_policy performance
    asusctl profile -P Performance
    asusctl bios -O true
    echo "boost on, cpu & pci-e ports on performance mode"
}
