#!/bin/bash

# ------------------------------------
# Source script lib
# ------------------------------------
. "$(dirname $0)/lib/ngx-script-lib.sh"

start_script
# ------------------------------------
# Start
# ------------------------------------
echo "I am @ $(pwd)"


log_version "fff" "2.3"
log_version "abc" "0.9"

log_version "fff" "3.9.3"
log_version "abc" "0.987655"


# ------------------------------------
# Stop
# ------------------------------------
stop_script
