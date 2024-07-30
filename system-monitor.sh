#!/bin/sh

# Variables
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_monitor.log"
ALERT_EMAIL="example@gmail.com"

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/., \([0-9.]\)% id.*/\1/" | awk '{print 100 - $1}')
    echo "CPU Usage: $CPU_USAGE%" >> $LOG_FILE
    if [ "$(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc)" -eq 1 ]; then
        echo "ALERT: High CPU usage detected: $CPU_USAGE%" | mail -s "High CPU Usage Alert" $ALERT_EMAIL
    fi
}

# Function to check memory usage
check_memory() {
    MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    echo "Memory Usage: $MEM_USAGE%" >> $LOG_FILE
    if [ "$(echo "$MEM_USAGE > $MEM_THRESHOLD" | bc)" -eq 1 ]; then
        echo "ALERT: High Memory usage detected: $MEM_USAGE%" | mail -s "High Memory Usage Alert" $ALERT_EMAIL
    fi
}

# Function to check disk usage
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    echo "Disk Usage: $DISK_USAGE%" >> $LOG_FILE
    if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
        echo "ALERT: High Disk usage detected: $DISK_USAGE%" | mail -s "High Disk Usage Alert" $ALERT_EMAIL
    fi
}

# Function to check network activity
check_network() {
    INTERFACE=$(ip link | awk -F': ' '/^[0-9]+: / {print $2}' | grep -v lo | head -n 1)  # Get the first non-loopback interface
    RX_BYTES_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_BYTES_BEFORE=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    sleep 1
    RX_BYTES_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    TX_BYTES_AFTER=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)

    RX_RATE=$((($RX_BYTES_AFTER - $RX_BYTES_BEFORE) / 1024))
    TX_RATE=$((($TX_BYTES_AFTER - $TX_BYTES_BEFORE) / 1024))

    echo "Network Usage - RX: ${RX_RATE}KB/s, TX: ${TX_RATE}KB/s" >> $LOG_FILE
}

# Create log file if it doesn't exist
touch $LOG_FILE

# Add a timestamp to the log
echo "System Monitoring Log - $(date)" >> $LOG_FILE

# Check system metrics
check_cpu
check_memory
check_disk
check_network

echo "----------------------------------------------------" >> $LOG_FILE