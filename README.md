# Purpose
1. This is used for check if your linux server is being hacked.
1. This could also help you to enhance your servers' security with **firewalld** and **fail2ban**.

## Environment
  * CentOS 7

## Warning
If you found something is weired and not sure if you've been hacked.  You'd better reinstall your server.

## Quick Install
### Configuration
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

### Installation
* Run **ALL** to do the following with one command

  ```bash
  ./start -a
  ```

  * Run security check
  * Install security package "**firewalld**" , "**fail2ban**"

## Run Security Check

**Basic os check**
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

## Installed Packages 
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

## Quick note - Package
### Nginx module - os_preparation([link](https://github.com/charlietag/os_preparation/blob/master/templates/F_06_01_setup_nginx_include/opt/nginx/conf/include.d/limit_req_zone.conf))
  * limit_req_zone
    * This is installed by default on my *os_preparation repo*

### Firewalld usage
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
  
* After setup all rules into "*/etc/firewalld/zone/public.xml*" with argument "**--permanent**", reload firewalld to activate setting.
  ```
  firewall-cmd --reload
  ```
  
* Services(http,https) defines in
  
  ```
  /usr/lib/firewalld/services/*
  ```
  
* Firewalld configuration default path
  
  ```
  /etc/firewalld/zone/public.xml**
  ```
  
* After running this installation, your firewalld will only allow http , https , *custom ssh port*

### Fail2ban usage
*- Port in fail2ban config is based on firewalld services name.*

*- check fail2ban sucessfully add rules into iptables via firewalld command*

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

## Quick note - Fail2ban flow

The following are executed automatically by **Fail2ban**
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
