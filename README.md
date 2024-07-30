Description:
This shell script is designed to monitor system performance metrics, including CPU usage, memory usage, disk space, and network activity. The script logs these metrics to a file and sends email alerts if any metric exceeds predefined thresholds. It is scheduled to run automatically every 2 minutes using cron.

Key Features:
CPU Usage Monitoring: 
Tracks CPU usage and sends an alert if it exceeds the defined threshold.
Memory Usage Monitoring: 
Monitors memory usage and sends an alert if it exceeds the defined threshold.
Disk Usage Monitoring: 
Checks disk usage and sends an alert if it exceeds the defined threshold.
Network Activity Monitoring: 
Logs network receive and transmit rates.
Logging: 
Updates the log file (/var/log/system_monitor.log) with monitoring results and timestamps.
Email Alerts: 
Sends email notifications if any monitored metric exceeds its threshold.
