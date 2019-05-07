#-----------Lib Use----------
echo "-----------lib use only--------"
echo "CURRENT_SCRIPT : ${CURRENT_SCRIPT}"
echo "CURRENT_FOLDER : ${CURRENT_FOLDER}"
echo "FUNCTIONS      : ${FUNCTIONS}"
echo "LIB            : ${LIB}"
echo "TEMPLATES      : ${TEMPLATES}"
echo "TASKS          : ${TASKS}"
echo "HELPERS        : ${HELPERS}"
echo "HELPERS_VIEWS  : ${HELPERS_VIEWS}"
echo ""

#-----------Lib Use -predefined vars----------
echo "-----------lib use only - predefined vars--------"
echo "FIRST_ARGV     : ${FIRST_ARGV}"
echo "ALL_ARGVS      : ${ALL_ARGVS[@]}"
echo ""

#-----------Function Use----------
echo "-----------function use only--------"
echo "PLUGINS            : ${PLUGINS}"
echo "TMP                : ${TMP}"
echo "CONFIG_FOLDER      : ${CONFIG_FOLDER}"
echo "DATABAG            : ${DATABAG}"
echo ""

#-----------Function Extended Use----------
echo "-----------function extended use only--------"
echo "IF_IS_SOURCED_SCRIPT  : $(eval "${IF_IS_SOURCED_SCRIPT}")"
echo "IF_IS_FUNCTION        : $(eval "${IF_IS_FUNCTION}")"
echo "IF_IS_SOURCED_OR_FUNCTION  : $(eval "${IF_IS_SOURCED_OR_FUNCTION}")"
echo ""
echo "\${BASH_SOURCE[0]}    : ${BASH_SOURCE[0]}"
echo "\${0}                 : ${0}"
echo "\${FUNCNAME}          : ${FUNCNAME}"
echo "Skip script sample    :"
echo '[[ -n "$(eval "${IF_IS_SOURCED_OR_FUNCTION}")" ]] && return 0 || exit 0'
echo ""

#================= Testing ===============
echo "================= Testing ==============="
#-----------Helper Debug Use----------
echo "----------Helper Debug Use-------->>>"
helper_debug

#-----------Task Debug Use----------
echo "----------Task Debug Use-------->>>"
task_debug
