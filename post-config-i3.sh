#/bin/sh

pkg install xorg
pkg install i3 i3status i3lock dmenu
pkg install utouch-kmod xf86-input-evdev
pkg install rofi xfce4-terminal nitrogen gnome-screenshot qemu-guest-agent mate-backgrounds pavucontrol volumeicon

echo "Configuring startup scripts. Make sure VGA driver is selected in Qemu"
echo "dbus_enable=\"YES\"" >> /etc/rc.conf
echo "hald_enable=\"YES\"" >> /etc/rc.conf
echo "qemu_guest_agent_enable=\"YES\"" >> /etc/rc.conf

echo "Enabling mouse in Qemu VirtualMachine"
echo 'utouch_load="YES"' >> /boot/loader.conf
echo ""

echo "configuring local variables"
echo "exec /usr/local/bin/i3" > /home/dan/.xinitrc
echo "exec /usr/local/bin/i3" > /root/.xinitrc
mkdir -p /home/dan/.config/i3
mkdir -p /root/.config/i3
cp i3/config /home/dan/.config/i3
cp i3/config /root/.config/i3
chown -R dan /home/dan/.config
chgrp -R dan /home/dan/.config
chown dan /home/dan/.xinitrc
chgrp dan /home/dan/.xinitrc
echo ""
echo "Please reboot computer, then login as user, startx and run nitrogen to setup wallpaper" 
echo "Select preferences and add folder /usr/local/share/backgrounds/mate"
