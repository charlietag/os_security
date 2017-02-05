#!/bin/bash
grep Failed /var/log/secure |cut -d' ' -f9| sort  |uniq -c
