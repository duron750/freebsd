#!/bin/sh

# 1. Punem etichete pe ferestre ca să le putem găsi 100% sigur
swaymsg "[app_id=\"wsjtx\" title=\".*Wide Graph.*\"] mark --add graph"
swaymsg "[app_id=\"wsjtx\" title=\"^WSJT-X.*\"] mark --add main"
swaymsg "[class=\"Cqrlog\"] mark --add log"

# 2. Mutăm totul pe Workspace 4
swaymsg "[con_mark=\"graph\"] move container to workspace 4"
swaymsg "[con_mark=\"main\"] move container to workspace 4"
swaymsg "[con_mark=\"log\"] move container to workspace 4"

# 3. Reconstruim ierarhia
# Punem Wide Graph sus de tot
swaymsg "[con_mark=\"graph\"] focus"
swaymsg "move up; move up" # Îl forțăm la marginea de sus a workspace-ului
swaymsg "split vertical"
swaymsg "resize set height 25 ppt"

# 4. Grupăm WSJT-X Main și CQRLOG jos
swaymsg "[con_mark=\"main\"] focus"
swaymsg "move down" # Ne asigurăm că e sub grafic
swaymsg "split horizontal"

swaymsg "[con_mark=\"log\"] focus"
swaymsg "move container to mark main" # Îl aduce exact lângă el
swaymsg "move left"
swaymsg "resize set width 50 ppt"

swaymsg "[title=\".*Wide Graph.*\"] resize set height 300 px"
# Curățăm etichetele (opțional)
swaymsg "unmark"

# Dezactivam power save ca sa optimizam linhpsdr"
echo 0 | sudo tee /sys/module/snd_hda_intel/parameters/power_save
