# -----------------------------
# Variable
# -----------------------------
THIS_SCRIPT="$(readlink -m $0)"

THIS_SCRIPT_NAME="$(basename "${THIS_SCRIPT}")"

THIS_PATH_BASE="$(dirname "${THIS_SCRIPT}")"
THIS_PATH_TMP="${THIS_PATH_BASE}/${THIS_SCRIPT_NAME}_TMP"
THIS_VERSION_FILE="${THIS_PATH_BASE}/${THIS_SCRIPT_NAME}.pre"

THIS_CONF_PATH="${THIS_PATH_BASE}/conf"
. $THIS_CONF_PATH/*.cfg

test -f $THIS_VERSION_FILE || touch $THIS_VERSION_FILE

THIS_RC_CODE=0

# -----------------------------
# Debug use
# -----------------------------
#echo "THIS_SCRIPT= ${THIS_SCRIPT}"
#echo "THIS_SCRIPT_NAME= ${THIS_SCRIPT_NAME}"
#echo "THIS_PATH_BASE= ${THIS_PATH_BASE}"
#echo "THIS_PATH_TMP= ${THIS_PATH_TMP}"
#exit

# -----------------------------
# Functions
# -----------------------------
function start_script (){
  echo "==================================="
  echo "     Start ${THIS_SCRIPT_NAME}"
  echo "==================================="
  echo "switch to $THIS_PATH_TMP"
  echo ""
  test -d $THIS_PATH_TMP || mkdir $THIS_PATH_TMP
  cd $THIS_PATH_TMP
}

function stop_script (){
  echo "==================================="
  echo "     Stop ${THIS_SCRIPT_NAME}"
  echo "==================================="
  cd $THIS_PATH_BASE
  rm -fr $THIS_PATH_TMP 

  echo "-------------------"
  echo "Leaving directory \"${THIS_PATH_TMP}\""
  echo "Folder \"${THIS_PATH_TMP}\" deleted ...!"
  echo "-------------------"
  echo ""

  echo "-------------------"
  echo "Restarting Nginx... !"
  echo "-------------------"
  systemctl restart nginx
  echo ""
}

function compare_version(){
  local app_name=$1
  local app_version=$2
  local app_version_pre="$(cat ${THIS_VERSION_FILE} | grep -E "^${app_name}:" | cut -d':' -f2)"

  if [[ "${app_version}" != "${app_version_pre}" ]]; then
    echo "\"${app_name}: ${app_version_pre} -> ${app_version}\""
    THIS_RC_CODE=1
  fi
}

function log_version(){
  local app_name=$1
  local app_version=$2
  

  sed -ri "/^${app_name}:/d" $THIS_VERSION_FILE
  echo "${app_name}:${app_version}" >> $THIS_VERSION_FILE
}

function check_app(){
  local app_name=$1
  local app_version=$2

  if [[ -z "${app_name}" ]] || [[ -z "${app_version}" ]]; then
    echo "Some var is missing...??"
    exit
  fi

  compare_version "${app_name}" "${app_version}"
  log_version "${app_name}" "${app_version}"
}

function check_app_done(){
  if [[ $THIS_RC_CODE -eq 1 ]]; then
    echo "--------------------------------"
  else
    exit
  fi
}

