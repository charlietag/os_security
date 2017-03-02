RENDER_CP (){
  local cp_from=$1
  local cp_to=$2

  # -----Check if dollar sign without escape in template config files----
  local check_template="$(cat ${cp_from} |grep -E "[^\]+[$]+[a-zA-Z]+")"
  if [ ! -z "${check_template}" ]
  then
    check_template_currected="$(echo "${check_template}" | sed 's/[$]/\\$/')"
    echo "Template file contains wrong usage, please currect it as below......"
    echo ""
    echo "${cp_from} : "
    echo "${check_template} --->"
    echo "${check_template_currected}"
    exit 1
  fi
  # -----Check if dollar sign without escape in template config files----


  echo "rendering file \"${cp_to}\""
  eval "echo \"$(cat ${cp_from})\" > ${cp_to}"
}
