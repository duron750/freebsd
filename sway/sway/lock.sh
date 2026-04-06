#!/bin/sh
# 2. Turn off all outputs (GPU power down)
#swaymsg "output * dpms off"
# 3. Force NVMe into low power (if supported)
# sudo nvmecontrol power -p 3 nvme0 
# 4. Tell the kernel to stay in the deepest C-state
sudo sysctl dev.cpu.0.cx_lowest=C3
#set background
/usr/local/bin/swaylock -i /usr/local/share/backgrounds/mate/abstract/Spring.png -s fill
