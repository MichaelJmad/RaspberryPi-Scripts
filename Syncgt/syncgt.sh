#!/bin/bash
# This script will poll google to get the current time in gmt and set the date and time on the OS

gtime=$(curl -s --head http://google.com/ | grep ^Date: | sed 's/Date: //g')
date -s "$gtime"
echo "Setting time to ${gtime}"
