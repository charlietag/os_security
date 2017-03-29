Table of Contents
=================
- [Purpose](#purpose)
- [Environment](#environment)
- [Warning](#warning)
- [Quick Install](#quick-install)
  * [Configuration](#configuration)
  * [Installation](#installation)
- [Run Security Check](#run-security-check)
  * [Basic os check](#basic-os-check)
- [Installed Packages](#installed-packages)
- [Quick Note - Package](#quick-note---package)
  * [Nginx module - os_preparation](#nginx-module---os_preparation)
  * [Firewalld usage](#firewalld-usage)
  * [Fail2ban usage](#fail2ban-usage)
- [Quick Note - Fail2ban flow](#quick-note---fail2ban-flow)
- [Quick Note - Fail2ban all detailed status](#quick-note---fail2ban-all-detailed-status)
- [Install SSL (Letsencrypt) - A+](#install-ssl-letsencrypt---a)
  * [Setup Nginx](#setup-nginx)
  * [Certbot prerequisite](#certbot-prerequisite)
  * [Certbot usage](#certbot-usage)
- [Log analyzer](#log-analyzer)
  * [GoAccess usage](#goaccess-usage)
  * [Logwatch usage](#logwatch-usage)
- [Performance monitor](#performance-monitor)
  * [Iotop usage](#iotop-usage)
  * [Glances usage](#glances-usage)
  * [Mytop usage](#mytop-usage)
- [CHANGELOG](#changelog)

# Purpose
**This presumes that you've done with** [os_preparation](https://github.com/charlietag/os_preparation)
1. This is used for check if your linux server is being hacked.
1. This could also help you to enhance your servers' security with **firewalld** and **fail2ban**.
1. This is also designed for **PRODUCTION** single server, which means this is suit for small business.

# Environment
  * CentOS 7

# Warning
If you found something is weired and not sure if you've been hacked.  You'd better reinstall your server.

# Quick Install
## Configuration
  * Download and run check

    ```bash
    yum install -y git
    git clone https://github.com/charlietag/os_security.git
    ```

  * Make sure config files exists , you can copy from sample to **modify**.

    ```bash
    cd databag
    ls |xargs -i bash -c "cp {} \$(echo {}|sed 's/\.sample//g')"
    ```

  * Edit some personal setting for **firewalld** and **fail2ban**

    ```bash
    databag/
    ├── F_01_check_os.cfg
    ├── F_02_check_failed_login.cfg
    ├── F_21_setup_firewalld.cfg
    └── F_23_setup_fail2ban.cfg
    ```

## Installation
* Run **ALL** to do the following with one command

  ```bash
  ./start -a
  ```

  * Run security check
  * Install security package "**firewalld**" , "**fail2ban**"

# Run Security Check

## Basic os check
* Command

  ```
  ./start.sh -i \
    F_01_check_os \
    F_02_check_failed_login \
    F_03_check_ssh_config \
    F_04_list_os_users \
    F_05_check_last_login
  ```

* Check OS
  * Verify os basic command (ls,cp, etc..) using command "rpm -Vf"
* Check failed loging
  * Check failed attempt ssh login
* Check ssh config
  * Check if root permit
  * Check if ssh port set to default 22
* List os users
  * Check current how many common user created
* Check last login
  * Check latest successfully login

# Installed Packages 
* Firewalld
  * Allowed port
    * http
    * https
    * 2222
* Fail2ban
  * Default filtered
    * sshd
    * sshd-ddos
    * nginx-limit-req
    * nginx-botsearch

# Quick Note - Package
## Nginx module - os_preparation
  * limit_req_zone
    * This is installed by default on my *os_preparation repo*
      * **[Link](https://github.com/charlietag/os_preparation/blob/master/templates/F_06_01_setup_nginx_include/opt/nginx/conf/include.d/limit_req_zone.conf)**
    * This would prevent your server from **DDOS** attacks.

## Firewalld usage
*- Default block all traffic, except rules you define below*
* Allow/revoke specific service

  ```
  firewall-cmd --add-service=http --permanent
  firewall-cmd --remore-service=http --permanent
  ```

* Allow/revoke specific port

  ```
  firewall-cmd --add-port=2222/tcp --permanent
  firewall-cmd --remove-port=2222/tcp --permanent
  ```
  
* List all current rules setting

  ```
  firewall-cmd --list-all
  ```
  
* After setup done with argument "**--permanent**", all rules save into the following file by default
  
  ```
  /etc/firewalld/zone/public.xml
  ```

* So reload firewalld to activate setting.
  ```
  firewall-cmd --reload
  ```
  
* Services(http,https) defines in
  
  ```
  /usr/lib/firewalld/services/*
  ```
  
* After running this installation, your firewalld will only allow http , https , ***customized ssh port***

## Fail2ban usage
*- Setting: port, in fail2ban configuration is based on firewalld services name.*

*- Determine if rules of fail2ban is inserted into iptables via firewalld command*

  * Confirm fail2ban works with **iptables** well
  
    ```
    iptables -S | grep -i fail2ban
    ```
  
  * List fail2ban status
  
    ```
    fail2ban-client status
    ```
  
  * List detailed status for specific **JAIL NAME**, including banned IP

    ```
    fail2ban-client status nginx-botsearch
    ```

  * Unban banned ip for specific **JAIL NAME**

    ```
    fail2ban-client set nginx-botsearch unbanip 192.168.1.72
    ```
    
  * List banned ip timeout for specific **JAIL NAME**

    ```
    ipset list fail2ban-nginx-botsearch
    ```

# Quick Note - Fail2ban flow
* **(Procedure) Be sure to start *"Firewalld / Fail2ban"* in the following order**

  ```
  systemctl stop firewalld
  systemctl stop fail2ban
  systemctl start firewalld
  systemctl start fail2ban
  ```

- The following flow are executed automatically by **Fail2ban**
  * Create [ipset-nmae] *(What actually done behind)*
      
      ```
      ipset create <ipmset> hash:ip timeout <bantime>
      ```
      
  * Reject all traffic with [ipset-name] *(What actually done behind)*
      
      ```
      firewall-cmd --direct --add-rule <family> filter <chain> 0 -p <protocol> -m multiport --dports <port> -m set --match-set <ipmset> src -j <blocktype>
      ```
      
  * Parse log
  * **Found** illigal IP
  * **Ban** IP using **ipset** with timeout argument *(What actually done behind)*
      
      ```
      ipset add <ipmset> <ip> timeout <bantime> -exist
      ```

# Quick Note - Fail2ban all detailed status
* *List all jail detailed status in faster way*

  **Command**

  ```
  # fail2ban-client status|tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n' |xargs -i bash -c "echo \"----{}----\" ;fail2ban-client status {} ; echo "
  ```

  **Result**
  ```
  ----nginx-botsearch----
  Status for the jail: nginx-botsearch
  |- Filter
  |  |- Currently failed: 0
  |  |- Total failed:     3
  |  `- File list:        /opt/nginx/logs/default.access.log /opt/nginx/logs/mylaravel.error.log /opt/nginx/logs/default.error.log /opt/nginx/logs/myrails.access.log /opt/nginx/logs/mylaravel.access.log /opt/nginx/logs/myrails.error.log
  `- Actions
     |- Currently banned: 0
     |- Total banned:     1
     `- Banned IP list:   

  ----nginx-limit-req----
  Status for the jail: nginx-limit-req
  |- Filter
  |  |- Currently failed: 0
  |  |- Total failed:     9
  |  `- File list:        /opt/nginx/logs/mylaravel.error.log /opt/nginx/logs/default.error.log /opt/nginx/logs/myrails.error.log
  `- Actions
     |- Currently banned: 0
     |- Total banned:     1
     `- Banned IP list:   

  ----sshd----
  Status for the jail: sshd
  |- Filter
  |  |- Currently failed: 0
  |  |- Total failed:     0
  |  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
  `- Actions
     |- Currently banned: 0
     |- Total banned:     0
     `- Banned IP list:   

  ----sshd-ddos----
  Status for the jail: sshd-ddos
  |- Filter
  |  |- Currently failed: 0
  |  |- Total failed:     0
  |  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
  `- Actions
     |- Currently banned: 0
     |- Total banned:     0
     `- Banned IP list:   
  ```

# Install SSL (Letsencrypt) - A+
## Setup Nginx
  **This will automatically setup after installation**
  **Also you will get a score "A+" in [SSLTEST](https://www.ssllabs.com/ssltest)**

## Certbot prerequisite
  **You will need 2 privileges**
  1. Web server control , to install ssl certificates.
  1. DNS control , to do ACME verification using TXT record.

## Certbot usage
  * Sign certificate (**RECOMMEND**), verified by DNS txt record

    ```
    certbot-auto --agree-tos -m $certbot_email --no-eff-email certonly --manual --preferred-challenges dns -d {domain}
    ```

  * Sign certificate , verified by web server root

    ```
    certbot-auto --agree-tos -m $certbot_email --no-eff-email certonly --webroot -w /{PATH}/laravel/public -d {domain} -n
    ```

  * Display all certificates

    ```
    certbot-auto certificates
    ```

  * Renew all certificates

    ```
    certbot-auto renew
    ```

  * Revoke and delete certificate

    ```
    certbot-auto revoke --cert-path /etc/letsencrypt/live/{domain}/cert.pem
    certbot-auto delete --cert-name {domain}
    ```

# Log analyzer
## GoAccess usage
  *- Generate nginx http log report in html.*

  **Reference the official description** [GoAccess](https://goaccess.io/)

  ```
  cat xxx.access.log | goaccess > xxx.html
  ```

## Logwatch usage
  *- View log analysis report.*

  ```
  logwatch
  ```

# Performance monitor
## Glances usage
  *- Just like command "top", but more than that.*

  ```
  glances
  ```

## Iotop usage
  *- Just like command "top", but just for IO.*

  ```
  iotop
  ```

## Mytop usage
  *- Just like command "top", but this is designed for mysql.*

  ```
  mytop
  ```

# CHANGELOG
* 2017/03/04
  * Add Firewalld & Fail2ban installation and setting to avoid DDOS.
    * Firewalld
    * Fail2ban
* 2017/03/18
  * Integrate ssl and certs into nginx
    * Using letsencrypt and certbot
* 2017/03/26
  * To enhance security, add log analyzer, and enable mail server to mail out alert mail
    * posfix
    * goaccess
    * logwatch (customized for optnginx)
  * To know more about server performance
    * iotop
    * glances
    * mytop
