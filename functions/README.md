## Pre-defined Variables
```bash
-----------lib use only--------
CURRENT_SCRIPT : /<PATH>/os_preparation/start.sh
CURRENT_FOLDER : /<PATH>/os_preparation
FUNCTIONS      : /<PATH>/os_preparation/functions
TEMPLATES      : /<PATH>/os_preparation/templates
LIB            : /<PATH>/os_preparation/lib

-----------lib use only - predefined vars--------
FIRST_ARGV     : [ -i | -a ]
ALL_ARGVS      : <FUNCTION_NAMES>

-----------function use only--------
TMP            : /<PATH>/os_preparation/tmp
CONFIG_FOLDER  : /<PATH>/os_preparation/templates/<FUNCTION_NAME>
```

```bash
==============================
        F_00_echo_path
==============================
-----------lib use only--------
CURRENT_SCRIPT : /root/os_preparation/start.sh
CURRENT_FOLDER : /root/os_preparation
FUNCTIONS      : /root/os_preparation/functions
LIB            : /root/os_preparation/lib
TEMPLATES      : /root/os_preparation/templates

-----------lib use only - predefined vars--------
FIRST_ARGV     : -i
ALL_ARGVS      : F_00_echo_path

-----------function use only--------
TMP            : /root/os_preparation/tmp
CONFIG_FOLDER  : /root/os_preparation/templates/F_00_echo_path
```
