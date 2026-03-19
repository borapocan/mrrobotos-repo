
# Start the desktop wallpaper application:
~/.fehbg &

## Start the Xfce4 Panel
xfce4-panel --disable-wm-check & disown

## Conky Themes
conky -c ~/.config/conky/Auva-Light/Auva-Light.conf &
conky -c ~/.config/conky/Auva-Light/Auva-Light2.conf &

# Start DWM Blocks
dwmblocks >/dev/null 2>&1 &

#exec dbus-run-session dwm
#ssh-agent dwm

# Start DWM - loop to restart on crash
while :; do
	ssh-agent dwm
done
