#!/bin/bash

THIS_FILE_NAME="$(readlink -m $0)"
THIS_FILE_DIR="$(dirname ${THIS_FILE_NAME})"
THIS_FILE_CFG="$(echo "${THIS_FILE_NAME}" | sed 's/.sh$//g').cfg"

CLAMAV_CLAMSCAN_DIRS="$(cat ${THIS_FILE_CFG} | grep -v '#' | sed 's/ /\n/g' | sed '/^\s*$/d' | sort -n | uniq)"

# Update virus code
freshclam --quiet

for clamav_dir in ${CLAMAV_CLAMSCAN_DIRS}; do
  echo "====================================================="
  echo $clamav_dir
  echo "====================================================="
  clamscan -i -r $clamav_dir
  echo ""
done

