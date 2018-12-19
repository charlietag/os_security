# -----------------------------
# Variable
# -----------------------------
THIS_SCRIPT="$(readlink -m $0)"

THIS_SCRIPT_NAME="$(basename "${THIS_SCRIPT}")"

THIS_PATH_BASE="$(dirname "${THIS_SCRIPT}")"
THIS_PATH_TMP="${THIS_PATH_BASE}/${THIS_SCRIPT_NAME}_TMP"
THIS_VERSION_FILE="${THIS_PATH_BASE}/${THIS_SCRIPT_NAME}.pre"

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
}

#function compare_version(){
#}

function log_version(){
  local log_app_name=$1
  local log_app_version=$2
  
  if [[ -z "${log_app_name}" ]] || [[ -z "${log_app_version}" ]]; then
    echo "Some var is missing...??"
    exit
  fi

  test -f $THIS_VERSION_FILE || touch $THIS_VERSION_FILE
  sed -i "/${log_app_name}/d" $THIS_VERSION_FILE
  echo "${log_app_name}:${log_app_version}" >> $THIS_VERSION_FILE
}

