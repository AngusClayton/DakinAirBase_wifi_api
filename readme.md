

# Reverse Engineering Dakin Aircon

Air base app reverse engineering [using charles proxy]

## API [Receive Data]

`<hostname>/skyfi/aircon/` appears to be the start of the API, with the following sub-categories.

#### Zone Settings

`/skyfi/aircon/get_zone_setting?lpw=`

Response

```
ret=OK,zone_name=%53%74%65%70%68%20%26%20%49%61%6e%3b%42%65%64%72%6f%6f%6d%20%53%75%6d%3b%42%65%64%72%6f%6f%6d%20%47%75%73%3b%20%20%20%20%20%20%20%5a%6f%6e%65%34%3b%20%20%20%20%20%20%20%5a%6f%6e%65%35%3b%20%20%20%20%20%20%20%5a%6f%6e%65%36%3b%20%20%20%20%20%20%20%5a%6f%6e%65%37%3b%20%20%20%20%20%20%20%5a%6f%6e%65%38,zone_onoff=1%3b1%3b0%3b0%3b0%3b0%3b0%3b0
```

Turning Response into not URL code:

```
ret=OK,zone_name=Steph & Ian;Bedroom Sum;Bedroom Gus;       Zone4;       Zone5;       Zone6;       Zone7;       Zone8,zone_onoff=1;1;0;0;0;0;0;0
```

in the above, `Steph & Ian` is on

`Bedroom Sum` is on

`Bedroom Gus` is on



#### Sensor Info

`GET /skyfi/aircon/get_sensor_info?lpw=`

`ret=OK,err=0,htemp=28,otemp=-`

#### Control Info

`GET /skyfi/aircon/get_control_info?lpw= HTTP/1.1`

```
ret=OK,pow=0,mode=2,stemp=24,dt1=22,dt2=24,dt3=22,f_rate=3,dfr0=5,dfr1=1,dfr2=3,dfr3=5,f_airside=0,airside0=0,airside1=0,airside2=0,airside3=0,f_auto=0,auto0=0,auto1=0,auto2=0,auto3=0,f_dir=0,dfd0=1,dfd1=1,dfd2=0,dfd3=1,dfd7=1,filter_sign_info=0,cent=0,en_cent=0,remo=2
```

It appears that 

`mode=1` is heating, 

`mode=2` is cooling, 

`mode=3` is auto

`mode=5` is fan

`mode-7` is dry



`pow=0` is no power, assume that pow=1 is power.



## Changing A setting [API]

#### Changing Zone

````
GET /skyfi/aircon/set_zone_setting?lpw=&zone_onoff=1%3B1%3B1%3B0%3B0%3B0%3B0%3B0&zone_name=Steph%20%26%20Ian%3BBedroom%20Sum%3BBedroom%20Gus%3B%20%20%20%20%20%20%20Zone4%3B%20%20%20%20%20%20%20Zone5%3B%20%20%20%20%20%20%20Zone6%3B%20%20%20%20%20%20%20Zone7%3B%20%20%20%20%20%20%20Zone8 HTTP/1.1
````

Or not URL gibberish

```
GET /skyfi/aircon/set_zone_setting?lpw=&zone_onoff=1;1;1;0;0;0;0;0&zone_name=Steph & Ian;Bedroom Sum;Bedroom Gus;Zone4;Zone5;  Zone6;Zone7;Zone8 
```



![image-20210125203123566](C:\Users\clayt\AppData\Roaming\Typora\typora-user-images\image-20210125203123566.png)

# Adding Aircon Functionality to blynk.

Uses Curl and grep

```bash
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
```



