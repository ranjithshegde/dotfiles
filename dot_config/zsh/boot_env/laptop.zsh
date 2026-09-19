#!/bin/zsh

# Unset Forward key
xmodmap -e 'keysym 0xff53 = NoSymbol'

# Disable Bluetooth by default
rfkill block bluetooth
export OPENCV_OPENCL_DEVICE="NVIDIA:GPU:0"

export LIBVA_DRIVER_PATH=/usr/lib/dri
export LIBVA_DRIVER_NAME=iHD
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json
export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

# export PROTON_ENABLE_NVAPI=1
# export PROTON_HIDE_NVIDIA_GPU=0
# export PRIMUS_SYNC=2
