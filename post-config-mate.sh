#/bin/sh

#xfce_desktop by Wamphyre (Somekind of FreeBSD Studio and Workstation)
#Version 2.5

test $? -eq 0 || exit 1 "NEED TO BE ROOT TO RUN THIS"

echo "Welcome to BSD-Mate base script"
echo "This will install a complete, secure and optimized XFCE desktop in your FreeBSD system"
echo "WARNING!! - Execute only in a fresh vanilla installation"
sleep 5

## CHANGE FreeBSD REPOS TO LATEST
sed -i '' 's/quarterly/latest/g' /etc/pkg/FreeBSD.conf

## REBUILD AND UPDATE PKG DATABASE 
echo "Upgrading packages..."
echo ""
pkg update && pkg upgrade -y
echo ""

## COMPILE CPU OPTIMIZED APPLICATIONS
touch /etc/make.conf
CPUCORES=$(sysctl hw.ncpu | cut -d ":" -f2 | cut -d " " -f2)
echo "CPUTYPE?=native" >> /etc/make.conf
echo "MAKE_JOBS_NUMBER?=$CPUCORES" >> /etc/make.conf
echo "OPTIONS_SET=OPTIMIZED_CFLAGS CPUFLAGS" >> /etc/make.conf

pkg install sudo neofetch htop zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
pkg install xorg
pkg install -g 'mate-\*'
pkg install utouch-kmod xf86-input-evdev
pkg install xfce4-terminal qemu-guest-agent mate-backgrounds pavucontrol volumeicon mousepad rclone rclone-browser iftop keepassxc evince-lite nsxiv mate-calc remmina openvpn openvpn-admin
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
