#!/bin/sh
export DISPLAY=:0
exec 2>/tmp/xmenu_debug.log
chosen=$(cat <<EOF | xmenu
[]=  Tiled Layout	0
><>  Floating Layout	1
[M]  Monocle Layout	2
|||  Three Column Layout	3
[D]  Deck Layout	4
[@]  Spiral Layout	5
[\\] Dwindle Layout	6
|M|  Centered Master Layout	7
>M>  Centered Floating Master	8
HHH  Grid Layout	9
EOF
)
echo "chosen=$chosen" >> /tmp/xmenu_debug.log
[ -z "$chosen" ] && exit 0
printf '%s' "$chosen"
