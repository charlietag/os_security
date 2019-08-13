#-----------------------------------------------------------------------------------------
# Determine is current block is sourced script or function
# If yes, please use 'return 0' to skip current block, and continue the whole script
# Otherwised, please use 'exit 0'!
# Usage: Use the following command in your script.
#       eval "${IF_IS_SOURCED_OR_FUNCTION}"
# Example:
#         [[ -n "$(eval "${IF_IS_SOURCED_OR_FUNCTION}")" ]] && return 0 || exit 0
# OR just:
# eval "${SKIP_SCRIPT}"
#-----------------------------------------------------------------------------------------

IF_IS_SOURCED_SCRIPT="$(cat <<EOF
if [[ "\${BASH_SOURCE[0]}" != "\${0}" ]]; then
  echo "True: use 'return 0' to skip script"
fi
EOF
)"

IF_IS_FUNCTION="$(cat <<EOF
if [[ -n "\${FUNCNAME}" ]]; then
  echo "True: use 'return 0' to skip script"
fi
EOF
)"

IF_IS_SOURCED_OR_FUNCTION="$(cat <<EOF
if [[ -n "\$(eval "\${IF_IS_SOURCED_SCRIPT}")" ]] || [[ -n "\$(eval "\${IF_IS_FUNCTION}")" ]]; then
  echo "True: use 'return 0' to skip script"
fi
EOF
)"

#SKIP_SCRIPT="$(cat <<EOF
#[[ -n "\$(eval "\${IF_IS_SOURCED_OR_FUNCTION}")" ]] && return 0 || exit 0
#EOF
#)"

# To avoid cron job echo message about skip, comment out this message
SKIP_SCRIPT="$(cat <<EOF
if [[ -n "\$(eval "\${IF_IS_SOURCED_OR_FUNCTION}")" ]]; then
  #echo "skip ---> return 0"
  return 0
else
  #echo "skip ---> exit 0"
  exit 0
fi
EOF
)"

