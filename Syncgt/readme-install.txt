Syncgt 
is used to sync the raspberry pi clock with google GMT time if for whatever reason NTP "Network Time Protocol" is unavailable


To install and run at startup you will need 3 files

Syncgt.sh This is the bash script to get the time from google and set it to the Pi
Syncgt.service This is a script to call the .sh file during startup 
Syncgt.timer This is needed to delay the service startup so the Pi has time to connect to the internet. Via Lan/Wifi

First run this
sudo nano /usr/local/bin/syncgt.sh
This will open the nano text editor
Paste in the following

#!/bin/bash
# This script will poll Google to get the current time in GMT and set the date and time on the OS

gtime=$(curl -s --head http://google.com/ | grep ^Date: | sed 's/Date: //g')
date -s "$gtime"
echo "Setting time to ${gtime}"

Then Hit control+X then Y and Enter

Second
Run sudo nano /etc/sysatemd/system/syncgt.service
Paste in the following

[Unit]
Description=This_service_will_sync_the_system_clock_with_google
Requires=local-fs.target
After=local-fs.target

[Service]
Type=idle
ExecStart=bash /usr/local/bin/syncgt.sh

[Install]
WantedBy=multi-user.target

Then Hit control+X then Y and Enter

Third 
Run sudo nano /etc/sysatemd/system/syncgt.timer
Paste in the following

[Unit]
Description=Setting time from google

[Timer]
OnStartupSec=30

[Install]
WantedBy=multi-user.target

Then Hit control+X then Y and Enter

Forth
After all the file are created we need to tell the Pi to run the files

sudo systemctl daemon-reload
sudo systemctl enable syncgt.timer

then you can reboot the pi and after the set time in timer it should run the sync
In my case, the timer is set to 30 seconds to allow the pi to connect but your case may need some adjusting

I do not claim to have written these scripts in there entirety But myself "JMAD" and K4tniss 
Modified and tweaked to get this working version at the time of writing
