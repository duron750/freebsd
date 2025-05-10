#!/bin/sh

xset -dpms s off s noblank s 0 0 s noexpose
# Enable presentation mode
gsettings set org.mate.power-manager sleep-display-ac 0
gsettings set org.mate.power-manager sleep-computer-ac 0
gsettings set org.mate.screensaver lock-enabled false
gsettings set org.mate.screensaver idle-activation-enabled false
dconf write /org/mate/notification-daemon/do-not-disturb true
