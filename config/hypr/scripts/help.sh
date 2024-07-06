#!/bin/bash

# took and modified from JaKooLit #

# Detect monitor resolution and scale
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

# Calculate width and height based on percentages and monitor resolution
width=$((x_mon * hypr_scale / 100))
height=$((y_mon * hypr_scale / 100))

# Set maximum width and height
max_width=1200
max_height=1000

# Set percentage of screen size for dynamic adjustment
percentage_width=70
percentage_height=70

# Calculate dynamic width and height
dynamic_width=$((width * percentage_width / 100))
dynamic_height=$((height * percentage_height / 100))

# Limit width and height to maximum values
dynamic_width=$(($dynamic_width > $max_width ? $max_width : $dynamic_width))
dynamic_height=$(($dynamic_height > $max_height ? $max_height : $dynamic_height))

# Launch yad with calculated width and height
yad --width=$dynamic_width --height=$dynamic_height \
    --center \
    --title="Keybindings" \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
" = " "SUPER KEY (Windows Key)" "(SUPER KEY)" \
"" "" "" \
" + Return" "Terminal" "(Alacritty)" \
" + E" "Open File Manager" "(Thunar)" \
"" "" "" \
" + /" "App Launcher" "(Rofi)" \
" + ALT + /" "App Launcher Theme" "(Rofi)" \
" + SHIFT + /" "Emoji Selector" "(Rofi)" \
" + X" "Power Menu" "(Rofi)" \
" + ALT + X" "Power Menu Theme" "(Rofi)" \
" + ALT + B" "Shell (zsh/bash) Theme" "(Rofi)" \
" + CTRL + E" "Choose to edit dotfiles" "(Rofi)" \
" + SHIFT + W" "Select wallpaper" "(Rofi)" \
" + ALT + SHIFT + W" "Select wallpaper (style-2)" "(Rofi)" \
" + ALT + E" "Change wallpaper Engine (swww / hyprpaper)" "(Rofi)" \
" + ALT + C" "Clipboard Manager" "(Cliphist (Rofi))" \
" + ALT + W" "Clear Clipboard History" "(Cliphist (Rofi))" \
" + CTRL + W" "Select Waybar Layout" "(Rofi)" \
"" "" "" \
"ALT + F4" "close active window" "(not kill)" \
"" "" "" \
" + W" "Change wallpaper (Random)" "(Swww)" \
" + B" "Browser" "(Brave/Chromium)" \
" + SHIFT + B" "Browser" "(Firefox 󰈹 )" \
" + C" "Code Editor" "(Visual Studio Code 󰨞 )" \
"Print" "Screenshot" "(Grimblast)" \
" + SHIFT + L" "Screen lock" "(hyprlock)" \
" + F" "Fullscreen" "(Toggles full-screen)" \
" + SHIFT + P" "Pseudo" "(Dwindle)"
" + V" "Floating" "(Toggle floating window)" \
#" + H" " " "Launch this app" \
"CTRL + Space" "Toggle Keyboard" "fcitx5 (Bangla & English)" \
"" "" "" \
"ALT + F9" "Volume" "(Volume Mute  )" \
"ALT + F10" "Volume" "(Volume Decrease  )" \
"ALT + F11" "Volume" "(Volume Increase  )" \
"" "" "" \
"ALT + F2" "Brightness" "(Brightness Increase  )" \
"ALT + F3" "Brightness" "(Brightness Decrease  )" \
"" "" "" \
" + L/H/K/J" "Move focus" "(Focus to Rt/Lt/Up/Dn)"\
" + CTRL + L/H/K/J" "Move window" "(Move to Rt/Lt/Up/Dn)"\
" + ." "Scroll Workspace" "Scroll to Right"\
" + CTRL + ." "Scroll Workspace" "Scroll to Right"\
" + ," "Scroll Workspace" "Scroll to Left"\
" + CTRL + ," "Scroll Workspace" "Scroll to Left"\
" + ALT + ." "Move to Workspace" "Move to Right"\
" + ALT + ," "Move to Workspace" "Move to Left"\
" + SHIFT + (Num)" "Move to Workspace" "Move to (Num)"\
" + ALT + (Num)" "Move to Workspace silently" "Move to (Num)"\
"" "" ""\
"CTRL + ESC" " " "Hide/Launch Waybar" \
"CTRL+ ALT + ESC" " " "Reload Waybar" \
"" "" ""\
"" "" ""\
"" "" ""\
" + SHIFT + M" "Exit" "(Exit HYPRLAND"\
