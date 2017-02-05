#!/bin/bash
cat /var/log/secure* | grep "Failed" |grep    "invalid"  | awk '{print $11}' | sort  |uniq -c
cat /var/log/secure* | grep "Failed" |grep -v "invalid"  | awk '{print $9}'  | sort  |uniq -c
