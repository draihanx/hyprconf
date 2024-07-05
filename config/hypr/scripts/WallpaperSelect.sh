#!/bin/bash

scripts_dir="$HOME/.config/hypr/scripts"

# WALLPAPERS PATH
wallDIR="$HOME/.config/hypr/Wallpaper"
cache_dir="$HOME/.config/hypr/.cache"
engine_file="$cache_dir/.engine"
engine=$(cat "$engine_file")

# Transition config
FPS=60
TYPE="any"
DURATION=2
BEZIER=".43,1.19,1,.4"
SWWW_PARAMS="--transition-fps $FPS --transition-type $TYPE --transition-duration $DURATION"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
  pkill swaybg
fi

# Retrieve image files
PICS=($(ls "${wallDIR}" | grep -E ".jpg$|.jpeg$|.png$|.gif$"))
RANDOM_PIC="${PICS[$((RANDOM % ${#PICS[@]}))]}"
RANDOM_PIC_NAME="${#PICS[@]}. random"

# Rofi command ( style )
case $1 in
  style1)
      rofi_command="rofi -show -dmenu -config ~/.config/rofi/themes/conf-wall.rasi"
      ;;
  style2)
      rofi_command="rofi -show -dmenu -config ~/.config/rofi/themes/conf-wall-2.rasi"
      ;;
esac

menu() {
  for i in "${!PICS[@]}"; do
    # Displaying .gif to indicate animated images
    if [[ -z $(echo "${PICS[$i]}" | grep .gif$) ]]; then
      printf "$(echo "${PICS[$i]}" | cut -d. -f1)\x00icon\x1f${wallDIR}/${PICS[$i]}\n"
    else
      printf "${PICS[$i]}\n"
    fi
  done

  printf "$RANDOM_PIC_NAME\n"
}

if [[ "$engine" == "swww" ]]; then

  swww query || swww init

  main() {
    choice=$(menu | ${rofi_command})

    # No choice case
    if [[ -z $choice ]]; then
      exit 0
    fi

    # Random choice case
    if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
      swww img "${wallDIR}/${RANDOM_PIC}" $SWWW_PARAMS
      exit 0
    fi

    # Find the index of the selected file
    pic_index=-1
    for i in "${!PICS[@]}"; do
      filename=$(basename "${PICS[$i]}")
      if [[ "$filename" == "$choice"* ]]; then
        pic_index=$i
        break
      fi
    done

    if [[ $pic_index -ne -1 ]]; then
      notify-send -i "${wallDIR}/${PICS[$pic_index]}" "Changing wallpaper"
      swww img "${wallDIR}/${PICS[$pic_index]}" $SWWW_PARAMS
    else
      echo "Image not found."
      exit 1
    fi
  }
elif [[ "$engine" == "hyprpaper" ]]; then

      # Ensure hyprpaper is running
      if ! pgrep -x hyprpaper > /dev/null; then
        hyprpaper -c ~/.config/hypr/hyprpaper.conf &
        sleep 2  # give hyprpaper some time to start
      fi

  main() {
    choice=$(menu | ${rofi_command})

    # No choice case
    if [[ -z $choice ]]; then
      exit 0
    fi

    # Random choice case
    if [ "$choice" = "$RANDOM_PIC_NAME" ]; then
        # Preload the wallpaper
        hyprctl hyprpaper preload "${wallDIR}/${RANDOM_PIC}"
        if [ $? -ne 0 ]; then
        echo "Failed to preload wallpaper"
        exit 1
        fi
        
        # Set the wallpaper using hyprpaper
        hyprctl hyprpaper wallpaper " ,${wallDIR}/${RANDOM_PIC}"
        hyprctl reload
      exit 0
    fi

    # Find the index of the selected file
    pic_index=-1
    for i in "${!PICS[@]}"; do
      filename=$(basename "${PICS[$i]}")
      if [[ "$filename" == "$choice"* ]]; then
        pic_index=$i
        break
      fi
    done

    if [[ $pic_index -ne -1 ]]; then
      notify-send -i "${wallDIR}/${PICS[$pic_index]}" "Changing wallpaper"
      hyprctl hyprpaper preload "${wallDIR}/${PICS[$pic_index]}"
      hyprctl hyprpaper wallpaper " ,${wallDIR}/${PICS[$pic_index]}"

      ln -sf "${wallDIR}/${PICS[$pic_index]}" "$cache_dir/current_wallpaper.png"
    else
      echo "Image not found."
      exit 1
    fi
    rm -rf ~/.cache/wal
  }

fi

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
  exit 0
fi

main

sleep 0.5
"$scripts_dir/pywal.sh"
sleep 0.2
"$scripts_dir/Refresh.sh"

# Check if the cache directory exists, create it if not
mkdir -p "$cache_dir"

# Check if the conversion can proceed
if [ -d "$cache_dir" ]; then
    # Perform the conversion
    convert "${cache_dir}/current_wallpaper.png" -blur 0x30 -resize 100% "${cache_dir}/blurred.png"
    notify-send -e "Blurred.png" "Created a blurred version of your Wallpaper"
else
    echo "Cache directory not found."
    exit 1
fi


