RENDER_CP (){
  local cp_from=$1
  local cp_to=$2
  eval "echo \"$(cat ${cp_from})\" > ${cp_to}"
}
