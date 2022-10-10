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

# Supported Environment
  * CentOS Stream release 9
    * os_preparation
      * release : `master` `v3.x.x`

  * CentOS Stream release 8
    * os_preparation
      * release : `v2.x.x`

  * CentOS 8 (8.x)
    * os_preparation
      * release : `v1.x.x`

  * CentOS 7 (7.x) **(deprecated)**
    * os_preparation
      * release : `v0.x.x`

# Warning
* If you found something is weired and not sure if you've been hacked.  You'd better reinstall your server.
* ClamAV (clamscan) - if you're going to scan virus through clamscan (ClamAV), which is installed by default ([os_security](https://github.com/charlietag/os_security))
  * `clamscan` is a **memory monster**
  * RAM (Physical + SWAP) Capacity recommendations for clamscan (ClamAV): **>= 4GB**
  * (Tip) mkswap if RAM is insufficient to run clamscan
    * [os_preparation#SWAP_FILE](https://github.com/charlietag/os_preparation#warning)
* If your ***physical memory is <= 1GB***, be sure stop some service before getting started
  * (**Nginx) is needed** when **TLS (certbot) certificates is required**

    ```bash
    echo "mariadb php-fpm puma" | sed 's/ /\n/g' | xargs -i bash -c "echo --- Stop / Disable {} ---; systemctl stop {} ; systemctl disable {}; echo"
    ```

  * **Nginx is not needed**, when **NO TLS certificates** required

    ```bash
    echo "mariadb php-fpm puma nginx" | sed 's/ /\n/g' | xargs -i bash -c "echo --- Stop / Disable {} ---; systemctl stop {} ; systemctl disable {}; echo"
    ```

# Quick Install
## Configuration
  * Download and run check

    ```bash
    dnf install -y git
    git clone https://github.com/charlietag/os_security.git
    ```

  * Make sure config files exists , you can copy from sample to **modify**.

    ```bash
    cd databag
    ls |xargs -i bash -c "cp {} \$(echo {}|sed 's/\.sample//g')"
    ```

  * Mostly used configuration :
    * **DEV** use (server in **Local**)
      * **NO NEED** to setup config, just `./start -a` without config, by default, the following will be executed

        ```bash
        functions/
        ├── F_00_list_os_users
        ├── F_01_CHECK_01_os
        ├── F_01_CHECK_02_failed_login
        ├── F_01_CHECK_03_last_login
        ├── F_01_CHECK_04_ssh_config
        ├── F_02_PKG_02_install_perf_tools
        ├── F_02_PKG_04_firewalld_01_install
        ├── F_02_PKG_05_fail2ban_01_install
        ```

    * **DEV** use (server in **Cloud**)
      * It would be better to work with **VPS Firewall** for more secure enviroment
        * Firewalld + Fail2ban + **VPS Firewall (Vultr / DigitalOcean)**

      ```bash
      databag/
      ├── F_02_PKG_01_install_log_analyzer.cfg
      ├── F_02_PKG_04_firewalld_02_setup.cfg (rementer add customized port for dev, like 8000 for laravel, 3000 for rails)
      ├── F_02_PKG_05_fail2ban_02_setup.cfg
      ├── F_02_PKG_05_fail2ban_03_nginx_check_banned.cfg
      ├── F_02_PKG_07_nginx_01_ssl_enhanced.cfg
      ├── F_02_PKG_08_redmine_01_fail2ban.cfg
      ├── F_03_CHECK_01_check_scripts.cfg
      └── _postfix.cfg
      ```

        * ~~F_02_PKG_21_install_clamav.cfg~~
        * ~~_nginx_modules.cfg~~


    * **Production** use (server in **Local**)

      ```bash
      databag/
      ├── F_02_PKG_01_install_log_analyzer.cfg
      └── _postfix.cfg
      ```

        * ~~F_02_PKG_21_install_clamav.cfg~~

    * **Production** use (server in **Cloud**)

      ```bash
      databag/
      ├── _certbot.cfg
      ├── F_02_PKG_01_install_log_analyzer.cfg
      ├── F_02_PKG_04_firewalld_02_setup.cfg
      ├── F_02_PKG_05_fail2ban_02_setup.cfg
      ├── F_02_PKG_05_fail2ban_03_nginx_check_banned.cfg
      ├── F_02_PKG_07_nginx_01_ssl_enhanced.cfg
      ├── F_02_PKG_07_nginx_02_ssl_site_config.cfg
      ├── F_02_PKG_08_redmine_01_fail2ban.cfg
      ├── F_03_CHECK_01_check_scripts.cfg
      └── _postfix.cfg
      ```

        * ~~F_02_PKG_21_install_clamav.cfg~~
        * ~~_nginx_modules.cfg~~

  * Verify config files (with syntax color).

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

  * Verify **ONLY modified** config files (with syntax color).

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

## Installation
* First time finish [os_preparation](https://github.com/charlietag/os_preparation), be sure to do a **REBOOT**, before installing [os_security](https://github.com/charlietag/os_security)

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
    F_00_debug \
    F_00_list_os_users \
    F_01_CHECK_01_os \
    F_01_CHECK_02_failed_login \
    F_01_CHECK_03_last_login \
    F_01_CHECK_04_ssh_config \
    F_01_CHECK_05_hosts_config \
    ...
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
* Check hosts file (/etc/hosts)

  ```bash
  127.0.0.1 original content
  ::1       original content
  127.0.0.1 $(hostname)
  ::1       $(hostname)
  ```

# Installed Packages
* Firewalld
  * Allowed port
    * http
    * https
    * 2222
* Fail2ban
  * Default filtered
    * sshd (mode=aggressive)
    * nginx-limit-req
    * nginx-botsearch

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
          dnf install -y nikto
          ```

        * Start to scan
          ```bash
          nikto -h myrails.centos8.localdomain
          ```

      * skipfish
        * Install

          ```bash
          dnf install -y skipfish
          ```

        * Start to scan (output_result_folder must be an empty folder)
          ```bash
          skipfish -o output_result_folder http://myrails.centos8.localdomain
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

*- Determine if rules of fail2ban is inserted into nft via firewalld command*

  * Confirm fail2ban works with **nft** well

    ```bash
    nft list ruleset | grep {banned_ip}
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

  * Unban banned specific ip for all **JAIL NAME**

    ```bash
    fail2ban-client unban 192.168.1.72 ... 192.168.1.72
    ```

  * List banned ip timeout for specific **JAIL NAME**

    ```bash
    ipset list fail2ban-nginx-botsearch
    ```

  * Fail2ban keeps showing WARN

    ```bash
    2019-12-11 16:23:53,108 fail2ban.ipdns          [4812]: WARNING Unable to find a corresponding IP address for xxx.xxx.xxx.xxx.server.com: [Errno -5] No address associated with hostname
    ```

    * ~~Solution~~
      * ~~fail2ban-client unban --all~~
      * ~~fail2ban-client restart~~
    * Root cause (Not verified)
      * fail2ban will dns lookup / dns reserve lookup hostname, this will trigger this error message
      * fail2ban will not dns lookup / dns reserve lookup 127.0.0.1
      * And why VM test server will not show this err message
        * The hostname of VM test server is not in `/etc/hosts` but also not in dns. So all the results when dns resolves. are `NXDOMAIN`, the same result... PASS
    * Solution 1
      * make sure `hostname` is in `/etc/hosts` (**both ipv4 and ipv6 is needed**)

        ```bash
        # cat /etc/hosts
        127.0.0.1 web.example.com
        ::1       web.example.com
        ```

    * Solution 2
      * make sure DNS record is correct
        * A record
          * `web.example.com    A   xxx.xxx.xxx.xxx`
        * PTR record (reverse record)
          * `xxx.xxx.xxx.xxx    PTR   web.example.com`

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
    ----nginx-botsearch----
    Status for the jail: nginx-botsearch
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     0
    |  `- File list:        /var/log/nginx/error.log /var/log/nginx/default.error.log /var/log/nginx/redmine.centos8.localdomain.error.log /var/log/nginx/myrails.centos8.localdomain.error.log /var/log/nginx/mylaravel.centos8.localdomain.error.log
    `- Actions
       |- Currently banned: 1
       |- Total banned:     1
       `- Banned IP list:   10.255.255.254

    ----nginx-limit-req----
    Status for the jail: nginx-limit-req
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     0
    |  `- File list:        /var/log/nginx/error.log /var/log/nginx/default.error.log /var/log/nginx/redmine.centos8.localdomain.error.log /var/log/nginx/myrails.centos8.localdomain.error.log /var/log/nginx/mylaravel.centos8.localdomain.error.log
    `- Actions
       |- Currently banned: 1
       |- Total banned:     1
       `- Banned IP list:   10.255.255.254

    ----nginx-modsecurity----
    Status for the jail: nginx-modsecurity
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     1
    |  `- File list:        /var/log/nginx/error.log /var/log/nginx/default.error.log /var/log/nginx/redmine.centos8.localdomain.error.log /var/log/nginx/myrails.centos8.localdomain.error.log /var/log/nginx/mylaravel.centos8.localdomain.error.log
    `- Actions
       |- Currently banned: 1
       |- Total banned:     1
       `- Banned IP list:   10.255.255.254

    ----nginx-redmine----
    Status for the jail: nginx-redmine
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     0
    |  `- File list:        /home/rubyuser/rails_sites/redmine/log/production.log
    `- Actions
       |- Currently banned: 1
       |- Total banned:     1
       `- Banned IP list:   10.255.255.254

    ----sshd----
    Status for the jail: sshd
    |- Filter
    |  |- Currently failed: 0
    |  |- Total failed:     0
    |  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
    `- Actions
       |- Currently banned: 1
       |- Total banned:     1
       `- Banned IP list:   10.255.255.254
    ```

# Install SSL (Letsencrypt) - A+
## Setup Nginx

  **This will automatically setup after installation**

  **Also you will get a score "A+" in [SSLTEST](https://www.ssllabs.com/ssltest)**

  **Default : TLS 1.2 1.3 enabled**

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

## pflogsumm usage (not installed by default, use logwatch instead)
  *- View log analysis of postfix.*

  ```bash
  /usr/sbin/pflogsumm -d yesterday /var/log/maillog
  ```

# Performance monitor
## Glances usage (not installed by default, not provide by CentOS 8 - base,epel,appstream)
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
* 2019/12/06
  * tag: v0.1.0
* 2019/12/07
  * tag: v0.1.1
    * changelog: https://github.com/charlietag/os_security/compare/v0.1.0...v0.1.1
* 2019/12/11
  * tag: v0.1.2
    * changelog: https://github.com/charlietag/os_security/compare/v0.1.1...v0.1.2
    * Fix fail2ban version v0.10 (sshd-ddos is integrated into sshd) issue
* 2019/12/11
  * tag: v0.1.3
    * changelog: https://github.com/charlietag/os_security/compare/v0.1.2...v0.1.3
  * tag: v0.1.4
    * changelog: https://github.com/charlietag/os_security/compare/v0.1.3...v0.1.4
    * Add check if hostname is in /etc/hosts for fail2ban use
* 2019/12/22
  * tag: v0.1.5
    * changelog: https://github.com/charlietag/os_security/compare/v0.1.4...v0.1.5
    * change default clamav scan path by cron job
* 2020/01/17
  * tag: v0.2.0
    * changelog: https://github.com/charlietag/os_security/compare/v0.1.5...v0.2.0
    * ssl_protocols TLSv1.2 supported only
* 2020/06/11
  * tag: v1.0.0
    * changelog: https://github.com/charlietag/os_security/compare/v0.2.0...v1.0.0
      * CentOS 8 - changes for CentOS 8
        * Rename all centos7 related to centos8 in all config files
        * Command "yum" -> "dnf"
        * Package: goaccess
          * Manually compile, because CentOS8 (epel, base, appstream) doesn't provide this package
        * clamscan
          * show error message if memroy is insufficient
        * TLS 1.3 (Nginx) - Enabled by default
        * ModSecurity
          * v3.0.3 -> v3.0.4
        * Nginx WAF Rules - cwaf_charlietag (comodo waf clone for bad stability of cwaf site) by default
        * iptables -> nft
          * check_fail2ban.sh
            * ipset list check -> nft list ruleset check
        * Fail2ban default bantime
          * ban IP for 30 days - 2592000
        * Other changes for CentOS 8 (reference changelog via link above)
  * tag: v1.0.1
    * changelog: https://github.com/charlietag/os_security/compare/v1.0.0...v1.0.1
      * postfix config -> **compatibility_level = 2**
* 2020/06/11
  * tag: v1.0.2
    * changelog: https://github.com/charlietag/os_security/compare/v1.0.1...v1.0.2
      * small changes for _postfix.cfg
* 2020/06/14
  * tag: v1.0.3
    * changelog: https://github.com/charlietag/os_security/compare/v1.0.2...v1.0.3
      * DO NOT restart Nginx if Nginx is disabled (Otherwise, sometimes I will be shocked if it's started automatically)
        * When upgrading Nginx related (WAF / Header / Nginx)
        * Check banned IP by fail2ban (f2b_nginx_check_banned.sh)
        * Renew certificates (certbot-auto_renew.sh)
* 2021/01/30
  * tag: v2.0.0
    * changelog: https://github.com/charlietag/os_security/compare/v1.0.3...v2.0.0
      * install certbot (git clone certbot-auto => dnf install certbot using repo EPEL)
      * add comment for puma TCP socket in nginx sample ssl config (rails)
      * make sure http://url is alive before certbot issuing certs via webroot
      * fix nginx dynamic modules compatibility
        * fix for installing Nginx via both (nginx.org / AppStream)
* 2021/02/02
  * tag: v2.0.1
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.0...v2.0.1
      * Fixes typo
      * To avoid failing to start fail2ban, start and stop nginx to make sure log of nginx exists...
* 2021/02/03
  * tag: v2.0.2
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.1...v2.0.2
      * Add more displayed messages while setup fail2ban
* 2021/02/06
  * tag: v2.0.3
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.2...v2.0.3
      * Change for newer version of git
* 2021/02/07
  * tag: v2.0.4
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.3...v2.0.4
      * Few changes for more readable messages
* 2021/06/22
  * tag: v2.0.5
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.4...v2.0.5
      * Fix nginx issue while building plugin "header" "libmodsecurity"
* 2021/11/01
  * tag: v2.0.6
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.5...v2.0.6
      * make sure locale (LC_ALL, LANG) is set to "en_US.UTF-8" to avoid errors while compiling programs

        ```bash
        export LC_ALL="en_US.UTF-8"
        export LANG="en_US.UTF-8"
        ```
* 2021/11/02
  * tag: v2.0.7
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.6...v2.0.7
      * locale (LC_ALL, LANG)
        * ask user to disable terminal locale setting
* 2021/11/04
  * tag: v2.0.8
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.7...v2.0.8
      * Add Example credentials file using restricted API Token (recommended)
  * tag: v2.0.9
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.8...v2.0.9
      * Fix nginx header package download path
* 2022/02/14
  * tag: v2.0.10
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.9...v2.0.10
      * Change default nginx modsecurity upload limit config (Nginx default: 100 MB, set modsecurity rule to 500 MB, non-uploading-file-request to 10 MB)

        ```
        SecRequestBodyLimit 524288000
        SecRequestBodyNoFilesLimit 10485760
        ```

* 2022/04/17
  * tag: v2.1.0
    * changelog: https://github.com/charlietag/os_security/compare/v2.0.10...v2.1.0
      * Refine doc
        * Do not install packages by default
          * ClamAV
            * ~~F_02_PKG_21_install_clamav.cfg~~
          * Nginx modules (WAF, Nginx more headers)
            * ~~_nginx_modules.cfg~~
* 2022/10/11
  * tag: v3.0.0
    * changelog: https://github.com/charlietag/os_security/compare/v2.1.0...v3.0.0
      * Migrate to CentOS Stream 9
        * goaccess (epel ~~manually compile~~)
