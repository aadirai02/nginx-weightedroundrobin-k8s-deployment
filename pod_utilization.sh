#!/bin/bash

deployment="nginx"  # Specify your NGINX deployment name here

# Get the Pod names for the NGINX deployment
pod_names=$(kubectl get pods -l app="$deployment" -o jsonpath="{.items[*].metadata.name}")

# Iterate over each Pod and calculate CPU and memory utilization percentage
for pod_name in $pod_names; do
    echo "Pod: $pod_name"

    # Get CPU and memory limits
    cpu_limit=$(kubectl get pod "$pod_name" --template='{{(index .spec.containers 0).resources.limits.cpu}}')
    mem_limit=$(kubectl get pod "$pod_name" --template='{{(index .spec.containers 0).resources.limits.memory}}')

    # Display CPU and memory limits if they are set
    if [ -n "$cpu_limit" ]; then
        echo "CPU Limit: $cpu_limit"
    fi

    if [ -n "$mem_limit" ]; then
        echo "Memory Limit: $mem_limit"
    fi

    # Get CPU utilization percentage
    cpu_usage=$(kubectl top pod "$pod_name" --containers | awk 'NR>1 {print $3}')
    cpu_percentage=$(awk -v usage="$cpu_usage" -v limit="$cpu_limit" 'BEGIN { if (limit != "") printf "%.2f\n", (usage / limit) * 100 }')
    echo "CPU Utilization Percentage: $cpu_percentage%"
    echo "CPU Usage: $cpu_usage"

    # Get memory utilization percentage
    mem_usage=$(kubectl top pod "$pod_name" --containers | awk 'NR>1 {print $4}')
    mem_percentage=$(awk -v usage="$mem_usage" -v limit="$mem_limit" 'BEGIN { if (limit != "") printf "%.2f\n", (usage / limit) * 100 }')
    echo "Memory Utilization Percentage: $mem_percentage%"
    echo "Memory Usage: $mem_usage"

    echo "---"
done
