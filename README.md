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
- [CHANGELOG](#changelog)

# Purpose
**This presumes that you've done with** [os_preparation](https://github.com/charlietag/os_preparation)
1. This is used for check if your linux server is being hacked.
1. This could also help you to enhance your servers' security with **firewalld** and **fail2ban**.
1. This is also designed for **PRODUCTION** single server, which means this is suit for small business.

# Environment
  * CentOS 7 (7.x)

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

  * Verify config files.

    ```bash
    cd databag

    echo ; \
    ls *.cfg | xargs -i bash -c " \
    echo -e '\e[0;33m'; \
    echo ---------------------------; \
    echo {}; \
    echo ---------------------------; \
    echo -n -e '\033[00m' ; \
    echo -n -e '\e[0;32m'; \
    cat {} | grep -vE '^\s*#' |sed '/^\s*$/d'; \
    echo -e '\033[00m' ; \
    echo "
    ```

  * Verify **ONLY modified** config files.

    ```bash
    cd databag

    echo ; \
    ls *.cfg | xargs -i bash -c " \
    echo -e '\e[0;33m'; \
    echo ---------------------------; \
    echo {}; \
    echo ---------------------------; \
    echo -n -e '\033[00m' ; \
    echo -n -e '\e[0;32m'; \
    cat {} | grep -v 'plugin_load_databag.sh' | grep -vE '^\s*#' |sed '/^\s*$/d'; \
    echo -e '\033[00m' ; \
    echo "
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
  * ./start -a
  * Run security check
  * Install security package "**firewalld**" , "**fail2ban**" , "**letsencrypt**" , "**nginx waf**" , "**nginx header**"
* ~~To avoid running **ALL**, to **APPLY** and **DESTROY** **letsencrypt** cert **at the same time**.~~
  * ~~DO NOT run ***./start.sh -a***~~

# Run Security Check

## Basic os check
* Command

  ```bash
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
* yum-cron
  * Check updates for installed packages

# Quick Note - Package
## Nginx module - os_preparation
  * limit_req_zone
    * This is installed by default on my *os_preparation repo*
      * **[Link](https://github.com/charlietag/os_preparation/blob/master/templates/F_06_01_setup_nginx_include/opt/nginx/conf/include.d/limit_req_zone.conf)**
    * This would prevent your server from **DDOS** attacks.

## NGINX 3rd Party Modules - os_security
  https://www.nginx.com/resources/wiki/modules/

  * Headers More

    ```bash
    more_set_headers    "Server: CharlieTag"; # Default=> Nginx: "nginx" , Apache: "Apache"
    ```

  * ModSecurity

    ```bash
    ...
    modsecurity on;
    ...
    ```

  * ModSecurity - supported policies
    * OWASP CRS
      * https://github.com/SpiderLabs/owasp-modsecurity-crs
      * Memory consumption
        * 100 MB / per nginx process
      * Should reference Azure config, to Avoid False Positive
        * https://docs.microsoft.com/en-us/azure/application-gateway/waf-overview

          ```bash
          curl -s https://docs.microsoft.com/zh-tw/azure/application-gateway/waf-overview |grep -Eo "REQUEST-[[:digit:]]+" |sort -n | uniq | sed ':a;N;$!ba;s/\n/|/g'
          ```

        * if you really need OWASP
        * if you have time to maintain WAF rules (OWASP-CRS) yourself
      * Reference: REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example , RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example
        * REQUEST-900-EXCLUSION-RULES-BEFORE-CRS.conf.example
          * Usage
            
            ```bash
            # ModSecurity Rule Exclusion: Disable all SQLi and XSS rules
            SecRule REQUEST_FILENAME "@beginsWith /admin" \
                "id:1004,\
                phase:2,\
                pass,\
                nolog,\
                ctl:ruleRemoveById=941000-942999"
            # This would cause error
            # ...no SecRule specified...
            # ctl:ruleRemoveById=941000-942999"
            ```

        * RESPONSE-999-EXCLUSION-RULES-AFTER-CRS.conf.example
          * Usage
            
            ```bash
            SecRuleRemoveById 949100 949110 959100
            ```


    * COMODO
      * https://waf.comodo.com
      * Memory consumption
        * 300 MB / per nginx process
      * Recommended: COMODO
        (register an account for 1-year-free, require renew 1-year-free order every year)
       * OWSASP would have false positive while:
         * Wordpress , updating articles
         * Redmine   , Click between pages
    * Website Vulnerability Scanner
      * nikto
        * Install

          ```bash
          yum install -y nikto
          ```
          
        * Start to scan
          ```bash
          nikto -h myrails.centos7.localdomain
          ```
          
      * skipfish
        * Install

          ```bash
          yum install -y skipfish
          ```
          
        * Start to scan (output_result_folder must be an empty folder)
          ```bash
          skipfish -o output_result_folder http://myrails.centos7.localdomain
          ```

## Firewalld usage
*- Default block all traffic, except rules you define below*
* Allow/revoke specific service

  ```basn
  firewall-cmd --add-service=http --permanent
  firewall-cmd --remore-service=http --permanent
  ```

* Allow/revoke specific port

  ```bash
  firewall-cmd --add-port=2222/tcp --permanent
  firewall-cmd --remove-port=2222/tcp --permanent
  ```
  
* List all current rules setting

  ```bash
  firewall-cmd --list-all
  ```
  
* After setup done with argument "**--permanent**", all rules save into the following file by default
  
  ```bash
  /etc/firewalld/zone/public.xml
  ```

* So reload firewalld to activate setting.
  ```bash
  firewall-cmd --reload
  ```
  
* Services(http,https) defines in
  
  ```bash
  /usr/lib/firewalld/services/*
  ```
  
* After running this installation, your firewalld will only allow http , https , ***customized ssh port***

## Fail2ban usage
*- Setting: port, in fail2ban configuration is based on firewalld services name.*

*- Determine if rules of fail2ban is inserted into iptables via firewalld command*

  * Confirm fail2ban works with **iptables** well
  
    ```bash
    iptables -S | grep -i fail2ban
    ```
  
  * List fail2ban status
  
    ```bash
    fail2ban-client status
    ```
  
  * List detailed status for specific **JAIL NAME**, including banned IP

    ```bash
    fail2ban-client status nginx-botsearch
    ```

  * Unban banned ip for specific **JAIL NAME**

    ```bash
    fail2ban-client set nginx-botsearch unbanip 192.168.1.72
    ```
    
  * List banned ip timeout for specific **JAIL NAME**

    ```bash
    ipset list fail2ban-nginx-botsearch
    ```

# Quick Note - Fail2ban flow
* **(Procedure) Be sure to start *"Firewalld / Fail2ban"* in the following order**

  ```bash
  systemctl stop fail2ban
  systemctl stop firewalld
  systemctl start firewalld
  systemctl start fail2ban
  ```

- The following flow are executed automatically by **Fail2ban**
  * Create [ipset-nmae] *(What actually done behind)*
      
      ```bash
      ipset create <ipmset> hash:ip timeout <bantime>
      ```
      
  * Reject all traffic with [ipset-name] *(What actually done behind)*
      
      ```bash
      firewall-cmd --direct --add-rule <family> filter <chain> 0 -p <protocol> -m multiport --dports <port> -m set --match-set <ipmset> src -j <blocktype>
      ```
      
  * Parse log
  * **Found** illigal IP
  * **Ban** IP using **ipset** with timeout argument *(What actually done behind)*
      
      ```bash
      ipset add <ipmset> <ip> timeout <bantime> -exist
      ```

# Quick Note - Fail2ban all detailed status
* *List all jail detailed status in faster way*

  **Command**

    ```bash
    # fail2ban-client status|tail -n 1 | cut -d':' -f2 | sed "s/\s//g" | tr ',' '\n' |xargs -i bash -c "echo \"----{}----\" ;fail2ban-client status {} ; echo "
    ```

  **Result**

    ```bash
    --------------Fail2ban Status-------------
    Status
    |- Number of jail:      4
    `- Jail list:   nginx-botsearch, nginx-limit-req, sshd, sshd-ddos
    --------------Fail2ban Detail Status-------------
    ----nginx-botsearch----
    Status for the jail: nginx-botsearch
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     0
    |  `- File list:        /var/log/nginx/mylaravel.access.log /var/log/nginx/myrails.error.log /var/log/nginx/myrails.access.log /var/log/nginx/mylaravel.error.log /var/log/nginx/default.access.log /var/log/nginx/default.error.log
    `- Actions
       |- Currently banned: 0
       |- Total banned:     0
       `- Banned IP list:   

    ----nginx-limit-req----
    Status for the jail: nginx-limit-req
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     0
    |  `- File list:        /var/log/nginx/mylaravel.error.log /var/log/nginx/myrails.error.log /var/log/nginx/default.error.log
    `- Actions
       |- Currently banned: 0
       |- Total banned:     0
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

    ```bash
    certbot-auto --agree-tos -m $certbot_email --no-eff-email certonly --manual --preferred-challenges dns -d {domain}
    ```

  * Sign certificate , verified by web server root

    ```bash
    certbot-auto --agree-tos -m $certbot_email --no-eff-email certonly --webroot -w /{PATH}/laravel/public -d {domain} -n
    ```

  * Display all certificates

    ```bash
    certbot-auto certificates
    ```

  * Renew all certificates

    ```bash
    certbot-auto renew
    ```

  * Revoke and delete certificate

    ```bash
    certbot-auto revoke --cert-path /etc/letsencrypt/live/{domain}/cert.pem
    certbot-auto delete --cert-name {domain}
    ```

  * New site - url : gen nginx site config + apply letsencrypt ssl only

    ```bash
    ./start.sh -i F_02_PKG_06_nginx_02_ssl_site_config
    ```

    **Before going on, be sure http port is reachable, otherwise webroot will fail (limitation for webroot verification!)**

    ```bash
    ./start.sh -i F_02_PKG_07_certbot_02_apply_webroot
    ```

  * New site - url (wildcard) : gen nginx site config + apply letsencrypt ssl only

    ```bash
    ./start.sh -i F_02_PKG_06_nginx_02_ssl_site_config
    ./start.sh -i F_02_PKG_07_certbot_02_apply_dns-cloudflare
    ```

# Log analyzer
## GoAccess usage
  *- Generate nginx http log report in html.*

  **Reference the official description** [GoAccess](https://goaccess.io/)

  ```bash
  cat xxx.access.log | goaccess > xxx.html
  ```

## Logwatch usage
  *- View log analysis report.*

  ```bash
  logwatch
  ```

## pflogsumm usage
  *- View log analysis of postfix.*

  ```bash
  /usr/sbin/pflogsumm -d yesterday /var/log/maillog
  ```

# Performance monitor
## Glances usage
  *- Just like command "top", but more than that.*

  ```bash
  glances
  ```

## Iotop usage
  *- Just like command "top", but just for IO.*

  ```bash
  iotop
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
* 2017/10/20
  * Add postfix log analyzer - pflogsumm (postfix-perl-scripts)
* 2017/10/27
  * Add Nginx http2 (ALPN) support under CentOS 7.4
  * This change is because openssl version "1.0.2" is supported by default in CentOS 7.4
* 2018/03/16
  * Add Letsencrypt wildcard ssl support
* 2018/07/19
  * Migrate rails ap server from passenger to puma
  * This movement will make deployment easier, especial security for most people.
  * Most different effects
    * Nginx config file no longer under /opt/nginx. Instead, /etc/nginx
    * Deprecated command
      * systemctl start optnginx
    * New command
      * systemctl start nginx
* 2018/12/13
  * ~~Adding Nginx WAF~~ finished at 2019/08/25
* 2019/04/07
  * More tools about server performance
    * htop
    * nmon
    * dstat
* 2019/08/25
  * Add Nginx module 'ngx_http_headers_more_filter_module.so' to change server tag ('Server:Nginx' -> 'Server: CustomizedName')
  * Finished intergrating Nginx WAF module into os_security
    * Modules
      * libmodsecurity.so
      * ngx_http_modsecurity_module.so (ModSecurity-nginx connector)
    * WAF Policies
      * OWASP CRS (https://github.com/SpiderLabs/owasp-modsecurity-crs)
      * COMODO (register free account required: https://waf.comodo.com)
  * Finished intergrating Nginx WAF with Fail2ban
    * nginx-modsecurity (modified from apache-modsecurity)
* 2019/11/20
  * Add fail2ban rules for redmine (Failed Login)
* 2019/11/27
  * Add ClamAV installation and setup
    * Ref. https://www.clamav.net/

