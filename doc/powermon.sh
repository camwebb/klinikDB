#!/bin/bash

# derived from RASelkirk <https://www.raspberrypi.org/forums/viewtopic.php?
#  f=29&t=302122&p=1824894&hilit=low+input+voltage#p1824894>

STATUS=$(/opt/vc/bin/vcgencmd get_throttled)
LOG=/var/log/powermon.log
DATE=`date +"%m-%d-%Y %H:%M:%S"`

# return is formatted as "throttled=0x0"
# strip off the numbers

STATUS="${STATUS#*=}"
# remove the "0x" for a valid number
STATUS="${STATUS:2}"

if [ "$STATUS" -ge 80000 ]; then
    STATUS="$(($STATUS-80000))"
    echo "$DATE" " : Soft temperature limit has occurred" >> $LOG
fi
if [ "$STATUS" -ge 40000 ]; then
    STATUS="$(($STATUS-40000))"
    echo "$DATE" " : Throttling has occurred" >> $LOG
fi
if [ "$STATUS" -ge 20000 ]; then
    STATUS="$(($STATUS-20000))"
    echo "$DATE" " : ARM Freq capping has occurred" >> $LOG
fi
if [ "$STATUS" -ge 10000 ]; then
    STATUS="$(($STATUS-10000))"
    echo "$DATE" " : Under-voltage has occurred" >> $LOG
fi
if [ "$STATUS" -ge 8 ]; then
    STATUS="$(($STATUS-8))"
    echo "$DATE" " : Soft temp limit active" >> $LOG
fi
if [ $STATUS -ge 4 ]; then
    STATUS="$(($STATUS-4))"
    echo "$DATE" " : Throttling active" >> $LOG
fi
if [ $STATUS -ge 2 ]; then
    STATUS="$(($STATUS-2))"
    echo "$DATE" " : Arm freq capping active" >> $LOG
fi
if [ $STATUS -eq 1 ]; then
    STATUS="$(($STATUS-1))"
    echo "$DATE" " : Under-voltage active" >> $LOG
    poweroff
fi

