#!/bin/bash

access_log=$(awk 'END { print NR }' /var/log/nginx/access.log)
error_log=$(awk 'END { print NR }' /var/log/nginx/error.log)
server9001_log=$(awk 'END { print NR }' /var/log/nginx/server9001.log)
server9002_log=$(awk 'END { print NR }' /var/log/nginx/server9002.log)
server9003_log=$(awk 'END { print NR }' /var/log/nginx/server9003.log)
error9001_log=$(awk 'END { print NR }' /var/log/nginx/error9001.log)
error9002_log=$(awk 'END { print NR }' /var/log/nginx/error9002.log)
error9003_log=$(awk 'END { print NR }' /var/log/nginx/error9003.log)
average_response_time=$(grep -oP 'rt=\K[0-9.]+' /var/log/nginx/access.log | awk '{ sum += $1; count++ } END { if (count > 0) printf "%.3f\n", sum/count; else print "0"}')

total_requests=$((access_log + error_log))
total_requests_9001=$((server9001_log + error9001_log))
total_requests_9002=$((server9002_log + error9002_log))
total_requests_9003=$((server9003_log + error9003_log))

echo "Total number of requests: $total_requests"
echo "Total number of requests at 9001: $total_requests_9001"
echo "Total number of requests at 9002: $total_requests_9002"
echo "Total number of requests at 9003: $total_requests_9003"

echo

echo "Total number of successful requests: $access_log"
echo "Port 9001 successful requests: $server9001_log"
echo "Port 9002 successful requests: $server9002_log"
echo "Port 9003 successful requests: $server9003_log"

echo

echo "Total number of unsuccessful requests: $error_log"
echo "Port 9001 unsuccessful requests: $error9001_log"
echo "Port 9002 unsuccessful requests: $error9002_log"
echo "Port 9003 unsuccessful requests: $error9003_log"

echo

echo "Average Response Time: $average_response_time"
