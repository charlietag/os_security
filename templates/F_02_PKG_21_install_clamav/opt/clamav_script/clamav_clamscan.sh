#!/bin/bash

THIS_FILE_NAME="$(readlink -m $0)"
THIS_FILE_DIR="$(dirname ${THIS_FILE_NAME})"
THIS_FILE_CFG="$(echo "${THIS_FILE_NAME}" | sed 's/.sh$//g').cfg"

CLAMAV_CLAMSCAN_DIRS="$(cat ${THIS_FILE_CFG} | grep -v '#' | sed 's/ //g')"

# Update virus code
freshclam --quiet

for clamav_dir in ${CLAMAV_CLAMSCAN_DIRS}; do
  #echo $clamav_dir
  clamscan -i -r $clamav_dir
done

