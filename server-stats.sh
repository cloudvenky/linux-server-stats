
#!/bin/bash

# ==========================================
# Linux Server Performance Statistics
# Project: server-stats.sh
# ==========================================

set -o pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}==========================================${NC}"
}

# Check Linux
if [[ ! -r /proc/stat || ! -r /proc/meminfo ]]; then
    echo "Error: This script requires a Linux system with /proc."
    exit 1
fi

# CPU Usage
get_cpu_usage() {
    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat

    idle1=$((idle + iowait))
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))

    sleep 1

    read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat

    idle2=$((idle + iowait))
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    if (( total_diff > 0 )); then
        cpu_usage=$(awk -v t="$total_diff" -v i="$idle_diff" \
            'BEGIN {printf "%.2f", (t-i)*100/t}')
    else
        cpu_usage="0.00"
    fi

    echo "Total CPU Usage: ${cpu_usage}%"
}

# Memory Usage
get_memory_usage() {
    read -r total available < <(
        awk '
        /^MemTotal:/ {total=$2}
        /^MemAvailable:/ {available=$2}
        END {print total, available}
        ' /proc/meminfo
    )

    if [[ -z "$total" || -z "$available" || "$total" -eq 0 ]]; then
        echo "Memory information unavailable"
        return
    fi

    used=$((total - available))
    free=$available

    awk -v t="$total" -v u="$used" -v f="$free" '
    BEGIN {
        printf "Total Memory: %.2f GB\n", t/1048576
        printf "Used Memory:  %.2f GB (%.2f%%)\n", u/1048576, u*100/t
        printf "Free Memory:  %.2f GB (%.2f%%)\n", f/1048576, f*100/t
    }'
}

# Disk Usage
get_disk_usage() {
    echo "Filesystem Disk Usage:"
    df -hP -x tmpfs -x devtmpfs
}

# Top 5 CPU Processes
get_top_cpu() {
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

# Top 5 Memory Processes
get_top_memory() {
    ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

# Operating System
get_os_info() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        echo "OS: ${PRETTY_NAME}"
    fi
}

# Uptime
get_uptime() {
    uptime -p
}

# Load Average
get_load_average() {
    awk '{print "Load Average: " $1 " " $2 " " $3}' /proc/loadavg
}

# Logged-in Users
get_logged_users() {
    echo "Logged-in Users:"
    who
}

# ==========================================
# MAIN EXECUTION
# ==========================================

clear

echo -e "${GREEN}"
echo "       LINUX SERVER STATISTICS"
echo -e "${NC}"

echo "Date: $(date)"
echo "Hostname: $(hostname)"

print_header "1. CPU USAGE"
get_cpu_usage

print_header "2. MEMORY USAGE"
get_memory_usage

print_header "3. DISK USAGE"
get_disk_usage

print_header "4. TOP 5 PROCESSES BY CPU"
get_top_cpu

print_header "5. TOP 5 PROCESSES BY MEMORY"
get_top_memory

print_header "6. SYSTEM INFORMATION"
get_os_info

echo "Uptime: $(get_uptime)"
get_load_average

print_header "7. LOGGED-IN USERS"
get_logged_users

echo
echo -e "${GREEN}Server statistics completed successfully!${NC}"
