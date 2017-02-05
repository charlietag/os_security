#!/bin/bash
cat /var/log/secure* | grep "Failed" |grep    "root"  | awk '{print $9}' | sort  |uniq -c
cat /var/log/secure* | grep "Failed" |grep -v "root"  | awk '{print $11}'| sort  |uniq -c
