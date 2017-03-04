# Purpose
## This is used for check if your linux server is being hacked.

## Environment
  * CentOS 7

## Warning
  * If you found something is weired.  You'd better reinstall your server.

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
