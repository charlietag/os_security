# Purpose
1. This is used for check if your linux server is being hacked.
1. This could also help you to enhance your servers' security with **firewalld** and **fail2ban**.

## Environment
  * CentOS 7

## Warning
If you found something is weired and not sure if you've been hacked.  You'd better reinstall your server.

## Quick Configuration
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

## Easy Installation
Run **ALL** to do the following with one command
* Run security check
* Install security package "**firewalld**" , "**fail2ban**".

* Command

  ```bash
  ./start -a
  reboot
  ```

## Package Installed
**Firewalld**

**Fail2ban**
