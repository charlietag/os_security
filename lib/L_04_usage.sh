#-----------------------------------------------------------------------------------------
# Functions
#-----------------------------------------------------------------------------------------
L_PRINT_HELP (){
  echo "usage: $(basename "${CURRENT_SCRIPT}")"
  echo "  -a                   ,  run all functions"
  echo "  -i func1 func2 func3 ,  run specified functions"
  echo -e "                          example: $(basename "${CURRENT_SCRIPT}") -i \\\\\n$(echo "${FUNC_NAMES[@]}" | sed 's/\ /\ \\\\\n/g')"
  exit
}

L_IF_FUNC_EXISTS (){
  local l_argvs=()
  for FUNC_NAME in ${FUNC_NAMES[@]}
  do
    for ALL_ARGV in ${ALL_ARGVS[@]}
    do
      if [ "${FUNC_NAME}" == "${ALL_ARGV}" ]
      then
        l_argvs+=($FUNC_NAME)
      fi
    done
  done
  echo "${l_argvs[@]}"
}

L_RUN (){
  local l_argvs_uniqs=($@)
  for l_argvs_uniq in ${l_argvs_uniqs[@]}
  do
    eval "${l_argvs_uniq}"
    #echo ${l_argvs_uniq}
  done
}

L_RUN_SPECIFIED_FUNC (){
  local l_argvs_uniqs=($@)
  if [ ! -z "${l_argvs_uniqs}" ]
  then
    # run
    L_RUN ${l_argvs_uniqs[@]}
  else
    echo "Function name \"${ALL_ARGVS[@]}\" not found. Please try again..."
    exit
  fi
}

#-----------------------------------------------------------------------------------------
# Actions
#-----------------------------------------------------------------------------------------
if [ "${FIRST_ARGV}" == "-a" ]
then
  echo "Packages will be installed:"
  echo "\"${FUNC_NAMES[@]}\""
  echo ""
  echo "You are going to run all functions above."
  echo -n "Are you sure (Yes/No)? "
  L_CONFIRM="N"
  read L_CONFIRM
  if [ "${L_CONFIRM}" != 'Yes' ]
  then
    echo "canceled..."
    exit
  fi
  #===========Select all funcs to run=======
  L_RUN ${FUNC_NAMES[@]}
  #===========Select all funcs to run=======

elif [ "${FIRST_ARGV}" == "-i" ]
then
  #===========Select specific funcs to run=======
  #**** Check if given argvs is in function lists ****
  L_ARGVS=($(L_IF_FUNC_EXISTS))

  #**** Distinct array ****
  L_ARGVS_UNIQS=($(echo "${L_ARGVS[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
  #L_ARGVS_UNIQS=${L_ARGVS[@]}

  #**** Run funcs****
  L_RUN_SPECIFIED_FUNC ${L_ARGVS_UNIQS[@]}

  #===========Select specific funcs to run=======
else
  L_PRINT_HELP
fi
