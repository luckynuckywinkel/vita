#!/bin/bash
#Beginning time
starting=$(date +%s)
#Looking for "php7.4" in our logs:
grep -r "php7.4" /var/log/
#Ending time
ending=$(date +%s)
#Checking execution time
total=$((ending - starting))
#Echo
echo "Время работы скрипта: $total сек."
