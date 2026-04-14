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
echo "BATCH=YES" >> /etc/make.conf
echo "OPTIONS_UNSET = DOCS EXAMPLES" >> /etc/make.conf

pkg install fastfetch htop zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
pkg install wayland sway swayidle swaylock-effects noto-basic seatd
pkg install waybar mako pipewire wireplumber foot nautilus remmina keepassxc gnome-calculator polkit-gnome gnome-keyring rclone rclone-browser pavucontrol
pkg install ly

echo "Ly:\
  :lo=/usr/local/bin/ly:\
  :al=root:" >> /etc/gettytab

echo "Configuring startup scripts. Make sure VGA driver is selected in Qemu"
echo "seatd_enable="YES""" >> /etc/rc.conf
echo "dbus_enable=\"YES\"" >> /etc/rc.conf
echo "hald_enable=\"YES\"" >> /etc/rc.conf
echo "vfs.usermount=1" >> /etc/sysctl.conf

echo "Enabling mouse in Qemu VirtualMachine"
echo 'utouch_load="YES"' >> /boot/loader.conf
echo ""

echo "Enable fusefs"
echo "fusefs_load=\"YES\"" >> /boot/loader.conf
echo ""

echo "configuring local variables"
echo "Select preferences and add folder /usr/local/share/backgrounds/mate"
echo "Copy rclone.conf from backup to ~/.config/rclone"
echo "Also MY is the kernel config for default KVM Virtual Manager VM"
