#!/bin/bash
#xfce_desktop by Wamphyre (Somekind of FreeBSD Studio and Workstation)
#Version 2.5

test $? -eq 0 || exit 1 "NEED TO BE ROOT TO RUN THIS"

echo "Welcome to BSD-GNOME base script"
echo "This will install a complete, secure and optimized GNOME desktop in your FreeBSD system"
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

## INSTALLS BASE DESKTOP AND CORE UTILS
echo "Installing desktop..."
echo ""
xargs pkg install -y < system_packages_gnome


echo 'proc	/proc	procfs	rw	0	0' >> /etc/fstab

## ENABLES BASIC SYSTEM SERVICES
echo "Enabling basic services"
sysrc hostname="freebsd"
sysrc moused_enable="YES"
sysrc dbus_enable="YES"
sysrc gdm_enable="YES"
echo ""

## CHANGE SLIM THEME TO FBSD
sed -i '' 's/current_theme       default/current_theme       fbsd/g' /usr/local/etc/slim.conf

## CREATES .xinitrc SCRIPT FOR A REGULAR DESKTOP USER
echo ; read -p "Want to enable GNOME for a regular user? (yes/no): " X;
echo ""
if [ "$X" = "yes" ]
then
    echo ; read -p "For what user? " user;
#    touch /usr/home/$user/.xinitrc
#    echo 'exec xfce4-session' >> /usr/home/$user/.xinitrc
#    echo ""
#    echo "$user enabled"
#else fi

    ## ADDS USER TO CORE GROUPS
    echo "Adding $user to video/realtime/wheel/operator groups"
    pw groupmod video -m $user
    pw groupmod audio -m $user
    pw groupmod realtime -m $user
    pw groupmod wheel -m $user
    pw groupmod operator -m $user
    pw groupmod network -m $user
    pw groupmod wheel -m $user
    echo ""

    ## ADDS USER TO SUDOERS
    echo "Adding $user to sudo"
    echo '%wheel	ALL=(ALL)	ALL' >> /usr/local/etc/sudoers
    echo ""

fi

## ENABLES LINUX COMPAT LAYER
echo "Enabling Linux compat layer..."
echo ""
kldload linux.ko
sysrc linux_enable="YES"
echo ""

echo "Enabling mouse in Qemu VirtualMachine"
echo 'utouch_load="YES"' >> /boot/loader.conf
echo ""

touch /etc/pf.conf
echo 'block in all' >> /etc/pf.conf
echo 'pass out all keep state' >> /etc/pf.conf

## CONFIGURES MORE CORE SYSTEM SERVICES
echo "Enabling additional system services..."
echo ""
sysrc pf_enable="YES"
sysrc pf_rules="/etc/pf.conf" 
sysrc pflog_enable="YES"
sysrc pflog_logfile="/var/log/pflog"
sysrc sendmail_enable="NO"
sysrc sendmail_msp_queue_enable="NO"
sysrc sendmail_outbound_enable="NO"
sysrc sendmail_submit_enable="NO"
sysrc jackd_enable="YES"
sysrc jackd_user="$user"
sysrc jackd_rtprio="YES"
## Change JACK /dev/dsp7 by your own interfaces
sysrc jackd_args="-doss -r48000 -p256 -n1 -w16 --capture /dev/dsp0 --playback /dev/dsp0"
echo ""

## CLEAN CACHES AND AUTOREMOVES UNNECESARY FILES
echo "Cleaning system..."
echo ""
pkg clean -y
pkg autoremove -y
echo ""

## DONE, PLEASE RESTART
echo "Installation done"
echo "Don't forget to reboot your system after that"
echo "To restore gnome settings run as user doconf load -f / < gnome_settings.conf"
echo "BSD-GNOME by Wamphyre :)"
