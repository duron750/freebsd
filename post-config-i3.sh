#/bin/sh

pkg install xorg
pkg install i3 i3status i3lock dmenu
pkg install utouch-kmod xf86-input-evdev


echo "Configuring startup scripts"
echo "dbus_enable=\"YES\"" >> /etc/rc.conf
echo "hald_enable=\"YES\"" >> /etc/rc.conf

echo "Enabling mouse in Qemu VirtualMachine"
echo 'utouch_load="YES"' >> /boot/loader.conf
echo ""

echo "configuring local variables"
echo "exec /usr/local/bin/i3" > /home/dan/.xinitrc
echo "exec /usr/local/bin/i3" > /root/.xinitrc
mkdir -p /home/dan/.config/i3
mkdir -p /root/.config/i3
cp /usr/local/etc/i3/config /home/dan/.config/i3
cp /usr/local/etc/i3/config /root/.config/i3
chown dan -R /home/dan/.config
chgrp dan -R /home/dan/.config
chown dan /home/dan/.xinitrc
chgrp dan /home/dan/.xinitrc
echo ""
echo "Please edit ~/.config/i3 file before starting window manager and reboot computer" 
