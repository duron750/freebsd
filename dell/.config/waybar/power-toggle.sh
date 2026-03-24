#!/bin/sh

# --- 1. THE ACTION (Only if a click is detected) ---
if [ "$1" == "toggle" ]; then
    # Unlock the driver
    echo "passive" | sudo /usr/bin/tee /sys/devices/system/cpu/intel_pstate/status > /dev/null
    
    # Cycle the profile
    CURRENT=$(powerprofilesctl get)
    if [ "$CURRENT" == "power-saver" ]; then
        powerprofilesctl set balanced
    elif [ "$CURRENT" == "balanced" ]; then
        powerprofilesctl set performance
    else
        powerprofilesctl set power-saver
    fi
    
    # Re-lock the driver
    echo "active" | sudo /usr/bin/tee /sys/devices/system/cpu/intel_pstate/status > /dev/null
fi

# --- 2. THE DATA (Always output JSON for Waybar) ---
PROFILE=$(powerprofilesctl get)
# Get the highest CPU core temperature
TEMP=$(sensors | grep "Package id 0" | awk '{print $4}' | tr -d '+°C')

# Determine Icon
if [ "$PROFILE" == "performance" ]; then ICON="";
elif [ "$PROFILE" == "balanced" ]; then ICON="";
else ICON=""; fi

# Output JSON for Waybar
printf '{"text": "%s %s", "tooltip": "Profile: %s\\nTemp: %s°C"}\n' "$ICON" "$PROFILE" "$PROFILE" "$TEMP"
