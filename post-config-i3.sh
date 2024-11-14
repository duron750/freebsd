#/bin/sh

pkg install sudo neofetch htop zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
pkg install i3 i3status i3lock dmenu
pkg install utouch-kmod xf86-input-evdev
pkg install rofi xfce4-terminal nitrogen gnome-screenshot qemu-guest-agent mate-backgrounds pavucontrol volumeicon mousepad thunar rclone rclone-browser iftop keepassxc
pkg install lightdm lightdm-gtk-greeter

echo "Configuring startup scripts. Make sure VGA driver is selected in Qemu"
echo "dbus_enable=\"YES\"" >> /etc/rc.conf
echo "hald_enable=\"YES\"" >> /etc/rc.conf
echo "lightdm_enable=\"YES\"" >> /etc/rc.conf
echo "qemu_guest_agent_enable=\"YES\"" >> /etc/rc.conf
echo "vfs.usermount=1" >> /etc/sysctl.conf

echo "Enabling mouse in Qemu VirtualMachine"
echo 'utouch_load="YES"' >> /boot/loader.conf
echo ""

echo "Enable fusefs"
echo "fusefs_load=\"YES\"" >> /boot/loader.conf
echo ""

echo "configuring local variables"
echo "exec /usr/local/bin/i3" > /home/dan/.xinitrc
echo "exec /usr/local/bin/i3" > /root/.xinitrc
mkdir -p /home/dan/.config/i3
mkdir -p /root/.config/i3
cp i3/config /home/dan/.config/i3
cp i3/config /root/.config/i3
cp zshrc /home/dan/.zshrc
mkdir /home/dan/bin
cp googledrive.sh /home/dan/bin/
chown -R dan /home/dan/
chgrp -R dan /home/dan/

echo "%wheel ALL=(ALL:ALL) ALL" >> /usr/local/etc/sudoers
echo ""
echo "Please reboot computer, then login as user, startx and run nitrogen to setup wallpaper" 
echo "Select preferences and add folder /usr/local/share/backgrounds/mate"
echo "Copy rclone.conf from backup to ~/.config/rclone"
echo "Also MY is the kernel config for default KVM Virtual Manager VM"