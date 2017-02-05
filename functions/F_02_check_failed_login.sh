#!/bin/bash
cat /var/log/secure* | grep Failed |grep root  |cut -d' ' -f9| sort  |uniq -c
cat /var/log/secure* | grep Failed |grep -v root  |cut -d' ' -f11| sort  |uniq -c
