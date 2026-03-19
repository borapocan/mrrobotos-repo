#!/bin/bash

# An example script for the genmon plugin displaying information on the Wireless connection

# Change eth1 to your Wifi interface

#echo "<img>/usr/local/share/icons/Tango/16x16/devices/network-wireless.png</img>"
# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/network/web.png"
echo "<img>${ICON}</img>"
interface="$(cat /proc/net/wireless | awk '{print $1}' | tail -1 | cut -d ':' -f1)";

res1=$(/sbin/ifconfig ${interface} | grep inet)
res2=$(/sbin/iwconfig ${interface} | grep unassociated)
if [ -z "$res2" ] && ! [ -z "$res1" ]
then
  echo "<txt> "$(/sbin/iwconfig ${interface} | grep "Link Quality" |cut -d "=" -f 2 |cut -d "/" -f 1)"%</txt>"
  echo "<tool>Essid: "$(/sbin/iwconfig ${interface} | grep "ESSID" |cut -d "\"" -f 2)
  echo "Signal Level: "$(/sbin/iwconfig ${interface} | grep "Signal level" |cut -d "=" -f 3)"</tool>"
  #echo "<bar>"$(/sbin/iwconfig enp3s0 | grep "Link Quality" |cut -d "=" -f 2 |cut -d "/" -f 1)"</bar>"
else
  echo "<txt>--%</txt>"
  echo "<tool>Essid: ???"
  echo "Signal Level: ???</tool>"
  #echo "<bar>0</bar>"
fi
