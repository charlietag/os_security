#-------------------------------------------------
# Usage :
# SAFE_DELETE "${DELETE_FILE}"
#-------------------------------------------------
CHECK_IF_VAR1_IN_VAR2() {
  local keywords_var1="$1"
  local keywords_var2="$2"
  # Bash array slice ref. https://unix.stackexchange.com/questions/82060/bash-slice-of-positional-parameters
  #local keywords_var2="${@:2}"

  #local check_return='false'
  local match_words=""

  # --For Debug--
  #echo "var1: ${keywords_var1[@]}"
  #echo "var2: ${keywords_var2[@]}"

  # ----------------------------------------------------
  # Ref. https://stackoverflow.com/questions/11456403/stop-shell-wildcard-character-expansion
  # Ref. https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
  # Disable filename expansion (globbing)
  # set -f    # Disable
  # echo -n "(check)"; set -o | grep noglob
  # set +f    # Enbale
  # echo -n "(check)"; set -o | grep noglob
  # ----------------------------------------------------
  set -f
  for keyword_var2 in ${keywords_var2[@]}; do
    for keyword_var1 in ${keywords_var1[@]}; do
      if [[ "${keyword_var1}" == "${keyword_var2}" ]]; then
        #check_return='true'
        match_words="${match_words} ${keyword_var1}"
      fi
    done
  done
  set +f

  #echo "${check_return}|${match_words}"
  echo "${match_words}"
}

CHECK_IF_VAR1_IN_VAR2_GREP() {
  local keywords_var1="$1"
  local keywords_var2="$2"

  local check_return='false'
  local match_words=""

  # --For Debug--
  #echo "var1: ${keywords_var1[@]}"
  #echo "var2: ${keywords_var2[@]}"

  set -f
  for keyword_var2 in ${keywords_var2[@]}; do
    for keyword_var1 in ${keywords_var1[@]}; do
      # Ref. https://stackoverflow.com/questions/18191548/how-to-grep-asterisk-without-escaping
      # Use the flag -F to search for fixed strings -- instead of regular expressions
      # Works with : set -f
      #echo "--- ${keyword_var1} v.s. ${keyword_var2} ---"
      #echo "${keyword_var1}" | grep -F "${keyword_var2}"

      match_words="${match_words} $(echo "${keyword_var1}" | grep -F "${keyword_var2}")"
    done
  done
  # --- xargs ---
  # xargs usage below will remove empty line automatically (xargs is useful to remove empty line. Good alternative to sed !)
  # -n                , if not specified - default all
  # -r, --no-run-if-empty
  #                   , if specified     - empty line will be ignored
  #                   , (man page) If the standard input does not contain any nonblanks, do not run the command.  Normally, the command is run once even if there is no input.  This option is a GNU extension.
  #
  #
  # default command   , /bin/echo
  #     echo "foo bar" | xargs -r
  #         --- equals to --->
  #     echo "foo bar" | xargs -r echo
  # --- xargs ---
  match_words="$(echo "${match_words}"| xargs -n 1 | sort -n | uniq | xargs -r)"
  set +f

  echo "${match_words}"

}

# --- Check exactly the same name and check for dangerous keywords ---
# Avoid user deletes files using wrong wildcard
CHECK_FILE_KEYWORD_DANGER() {
  local keywords_var1="$1"
  local keywords_var2='
    .*
    *.*
  '

  local match_words=''
  # --- check files ---
  # --For Debug--
  #CHECK_IF_VAR1_IN_VAR2_GREP "${keywords_var1}" "${keywords_var2}"
  #exit

  local match_words="$(CHECK_IF_VAR1_IN_VAR2_GREP "${keywords_var1}" "${keywords_var2}")"
  if [[ -n "${match_words}" ]]; then
    echo "(keyword danger check) FATAL ERROR: deleting \"${match_words}\" is NOT allowed..."

    exit 1
  fi

}

CHECK_FILE_KEYWORD() {
  local keywords_var1="$1"
  local keywords_var2='
    .
    ..
    *
    /
    .*
    *.*
  '
  #Use with array slice above, but not so general. So still pass two string as argument to function
  #local keywords_var2=(
  #  '.'
  #  '..'
  #  '.*'
  #  '*'
  #  '*.*'
  #  '/'
  #)
  local match_words=''

  # --- check files ---
  # --For Debug--
  #CHECK_IF_VAR1_IN_VAR2 "${keywords_var1}" "${keywords_var2[@]}"
  #exit
  #local match_words="$(CHECK_IF_VAR1_IN_VAR2 "${keywords_var1}" "${keywords_var2[@]}")"    # pass arguments using string, not array, for less confused issue

  local match_words="$(CHECK_IF_VAR1_IN_VAR2 "${keywords_var1}" "${keywords_var2}")"
  if [[ -n "${match_words}" ]]; then
    echo "(keyword check) FATAL ERROR: deleting \"${match_words}\" is NOT allowed..."

    exit 1
  fi

}

# --- Note for find / ls ---
#   ls -d -1 /*
# --- similar to --->
#   find / -maxdepth 1
# --- similar to --->
#   readlink -m /*


# --- Check via readlink -m keyword_files ---
# Avoid user deletes folders under /
CHECK_FILE_READLINK() {
  local keywords_var1="$(readlink -m $1)"
  #local keywords_var2="$((find / -maxdepth 1 ;  readlink -m /* ) | sort -n | uniq)" # basicly system files here are dangerous files
  # For better github colorscheme view
  local keywords_var2="$(echo "$(find / -maxdepth 1 ;  readlink -m /* )" | sort -n | uniq)" # basicly system files here are dangerous files
  local match_words=''

  # --- check files ---
  local match_words="$(CHECK_IF_VAR1_IN_VAR2 "${keywords_var1}" "${keywords_var2}")"
  if [[ -n "${match_words}" ]]; then
    echo "(folder check) FATAL ERROR: deleting \"${match_words}\" is NOT allowed..."

    exit 1
  fi
}

# --- Check empty ---
# Avoid user deletes null file
CHECK_FILE_EMPTY() {
  local keywords_var1="$1"

  if [[ "${keywords_var1}" =~ ^[[:space:]]*$ ]]; then
    echo "(empty check) FATAL ERROR: deleting \"NULL\" is NOT allowed..."

    exit 1
  fi
}


SAFE_DELETE () {
  local keywords_var1="$1"

  # --- check files ---
  CHECK_FILE_EMPTY "${keywords_var1}"
  CHECK_FILE_KEYWORD_DANGER "${keywords_var1}"
  CHECK_FILE_KEYWORD "${keywords_var1}"
  CHECK_FILE_READLINK "${keywords_var1}"


  local delete_files="$(readlink -m $1)"
  #echo "------ Deleting Files(debug) -----"
  #echo "${delete_files}"
  #echo "------ Deleting Files(debug) -----"
  #echo 


  # --- start deleting files ---
  echo "------ Start Deleting Files -----"
  for delete_file in ${delete_files[@]}; do
    echo "Deleting ${delete_file} ..."
    rm -fr ${delete_file}
  done
  echo "------ End Deleting Files -----"
}

#-------------------------------------------------
# TEST Sample Code (Usage)
#-------------------------------------------------
# --- Should be deleting /root/* (be careful) ---
#DELETE_FILE="/root/*"


# --- Should be failed ---
#DELETE_FILE="/root/delete_me/.*"
#DELETE_FILE="/root/"

# --- safe delete command usage ---
#SAFE_DELETE "${DELETE_FILE}"
