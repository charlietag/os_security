# -----------------------------
# Variable
# -----------------------------
THIS_SCRIPT="$(readlink -m $0)"

THIS_SCRIPT_NAME="$(basename "${THIS_SCRIPT}")"

THIS_PATH_BASE="$(dirname "${THIS_SCRIPT}")"
THIS_PATH_TMP="${THIS_PATH_BASE}/../tmp/${THIS_SCRIPT_NAME}_TMP"
THIS_VERSION_FILE="${THIS_PATH_BASE}/../installed_modules/${THIS_SCRIPT_NAME}.dat"

THIS_CONF_PATH="${THIS_PATH_BASE}/../conf"
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


