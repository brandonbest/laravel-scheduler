#!/usr/bin/env bash

set -e

while [ true ]
do
    cd /app/ && php artisan schedule:run --verbose --no-interaction &
    sleep 60
done