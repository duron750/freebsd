#!/bin/bash
#xfce_desktop by Wamphyre (Somekind of FreeBSD Studio and Workstation)
#Version 2.5

test $? -eq 0 || exit 1 "NEED TO BE ROOT TO RUN THIS"

echo "Welcome to BSD-XFCE base script"
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

## INSTALLS BASE DESKTOP AND CORE UTILS
echo "Installing desktop..."
echo ""
xargs pkg install -y < system_packages_xfce

## ENABLES BASIC SYSTEM SERVICES
echo "Enabling basic services"
sysrc hostname="freebsd"


## CHANGE SLIM THEME TO FBSD
sed -i '' 's/current_theme       default/current_theme       fbsd/g' /usr/local/etc/slim.conf

## CREATES .xinitrc SCRIPT FOR A REGULAR DESKTOP USER
echo ; read -p "Want to enable XFCE for a regular user? (yes/no): " X;
echo ""
if [ "$X" = "yes" ]
then
    echo ; read -p "For what user? " user;
else fi
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
##echo "Enabling Linux compat layer..."
##echo ""
##kldload linux.ko
##sysrc linux_enable="YES"
##echo ""

echo "Enabling mouse in Qemu VirtualMachine"
echo 'utouch_load="YES"' >> /boot/loader.conf
echo ""

##touch /etc/pf.conf
##echo 'block in all' >> /etc/pf.conf
##echo 'pass out all keep state' >> /etc/pf.conf

## CONFIGURES MORE CORE SYSTEM SERVICES
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

## CLEAN CACHES AND AUTOREMOVES UNNECESARY FILES
echo "Cleaning system..."
echo ""
pkg clean -y
pkg autoremove -y
echo ""

## DONE, PLEASE RESTART
echo "Installation done"
echo "Don't forget to reboot your system after that"
echo "BSD-XFCE by Wamphyre :)"
