## Project URL

https://github.com/cloudvenky/linux-server-stats 

#Linux Server Performance Monitoring

A lightweight Bash script to monitor Linux server performance and display important system health information directly from the terminal.

## Project Overview

This project uses Bash scripting to collect and display essential Linux server performance metrics. It helps administrators quickly understand server resource utilization.

## Features

- **CPU Usage** – Monitor CPU utilization.
- **Memory Usage** – Display total, used, and available memory.
- **Disk Usage** – Check filesystem storage utilization.
- **System Uptime** – Display how long the server has been running.
- **Top Processes** – Identify processes consuming system resources.
- **System Information** – Display hostname and operating system details.

## Technologies Used

- Linux (Amazon Linux 2023)
- Bash Shell Scripting
- Linux Commands: `top`, `free`, `df`, `uptime`, `ps`

## Project Structure

```text
linux-server-stats/
│
├── server-stats.sh
└── README.md
```

## Prerequisites

- Linux operating system
- Bash shell
- Standard Linux system utilities

## Installation

Clone the repository:

```bash
git clone https://github.com/cloudvenky/linux-server-stats.git
```

Navigate to the project directory:

```bash
cd linux-server-stats
```

Give execution permission:

```bash
chmod +x server-stats.sh
```

## Usage

Run the monitoring script:

```bash
./server-stats.sh
```

If administrator privileges are required:

```bash
sudo ./server-stats.sh
```

## Learning Outcomes

Through this project, I practiced:

- Linux system administration
- Bash scripting
- CPU, memory, and disk monitoring
- Linux process management
- Working with Git and GitHub

## Project URL

https://github.com/cloudvenky/linux-server-stats

## GitHub Repository

https://github.com/cloudvenky/linux-server-stats

---

*This project was created for hands-on Linux and DevOps practice.*
