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
echo "HELPER_VIEW_FOLDER : ${HELPER_VIEW_FOLDER}"
echo "DATABAG            : ${DATABAG}"
echo ""

#-----------Helper Use----------
echo "-----------helper use only--------"
echo "HELPER_VIEW_FOLDER : ${HELPER_VIEW_FOLDER}"
echo ""
echo ""
echo ""

#================= Testing ===============
echo "================= Testing ==============="
#-----------Helper Debug Use----------
echo "----------Helper Debug Use-------->>>"
helper_debug

#-----------Task Debug Use----------
echo "----------Task Debug Use-------->>>"
task_debug
