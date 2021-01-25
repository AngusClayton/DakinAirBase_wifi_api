#!/bin/bash

#this script gets the aircon power state [on/off]; updates a blynk vPin and logs to ~/air.log

pow=$(curl -s http://<HOSTNAME_DAKIN_WIFITHIGO>/skyfi/aircon/get_control_info | grep -oP '(?<=pow=).*?(?=,)') #gets the current power state





if [ $pow == "0" ]

then

curl http://<BLYNK SERVER>/<API KEY>/update/V10?value=0

echo "0" >> ~/air.log

else

curl http://<BLYNK SERVER>/<API KEY>/update/V10?value=0

echo "1" >> ~/air.log

fi