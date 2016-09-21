#-----------------------------------------------------------------------------------------
# Convert functions into function
#-----------------------------------------------------------------------------------------
for FUNC_NAME in ${FUNC_NAMES[@]}
do
  CONFIG_FOLDER="${TEMPLATES}/${FUNC_NAME}"
  L_DATABAG_FILE="${DATABAG}/${FUNC_NAME}.cfg"
  L_IF_RENDER_USE="$(grep "RENDER_CP" "${FUNCTIONS}/${FUNC_NAME}.sh")"
  MAKE_FUNC="
  ${FUNC_NAME} (){
    echo \"==============================\"
    echo \"        ${FUNC_NAME}\"
    echo \"==============================\"

    CONFIG_FOLDER=\"${CONFIG_FOLDER}\"
    #if [ ! -d ${CONFIG_FOLDER} ]
    #then
    #  mkdir -p ${CONFIG_FOLDER}
    #  touch ${CONFIG_FOLDER}/.keep
    #fi
    if [ ! -z \"${L_IF_RENDER_USE}\" ]
    then
      if [ -f \"${L_DATABAG_FILE}\" ]
      then
        echo -n \"Reading data file: ${L_DATABAG_FILE}.\"
        sleep 1
        echo -n \".\"
        sleep 1
        echo -n \".\"
        sleep 1
        echo -n \".\"
        sleep 1
        echo \".\"
        . ${L_DATABAG_FILE}
      else
        echo \"Data file for databag not found:\"
        echo \"${L_DATABAG_FILE}\"
        exit
      fi
    fi
    . ${FUNCTIONS}/${FUNC_NAME}.sh
    cd $CURRENT_FOLDER
  }
  "
  eval "${MAKE_FUNC}"
  #echo "${MAKE_FUNC}" #debug use
done

