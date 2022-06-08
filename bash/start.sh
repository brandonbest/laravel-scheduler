#!/bin/bash

# Start Supervisor
/usr/local/bin/scheduler-start &

while sleep 60; do
  ps aux |grep php artisan schedule:run |grep -q -v grep
  PROCESS_1_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done