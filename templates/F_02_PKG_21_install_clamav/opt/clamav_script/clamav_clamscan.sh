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
  if [[ $? -ne 0 ]]; then
    echo ""
    echo "--- Warning Message ---"
    echo "* ClamAV:"
    echo "  * clamscan is a \"MEMORY MONSTER\" !!!"
    echo "* RAM (Physical + SWAP):"
    echo "  * Might be insufficient scaning folder \"${clamav_dir}\" ...!"
    echo "  * Capacity recommendations for clamscan (ClamAV): \">= 4GB\""
    echo ""
    echo "--- Current memory status ---"
    free -m
    echo ""
    echo "(TIP: If you are using SSD, you can enlarge your \"SWAP\" / \"SWAP File\" !)"
  fi
  echo ""
done

