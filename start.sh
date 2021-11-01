#!/bin/bash
#*****************************************************************************
#* Choose "Minimal Server" during the intstallation (works With Minimal ISO)
#*****************************************************************************

# --- Fix locale error (LC_ALL) ---
LOCALE_EN_US_FOUND="$(locale -a 2>&1 |grep -i en_us | grep -i utf)"
if [[ -z "${LOCALE_EN_US_FOUND}" ]]; then
  echo "Make sure your server supports language: en_US.UTF-8   !!"
  echo ""
  exit 1
fi

LOCALE_EN_US_CHECK="$(locale 2>&1 | grep 'LANG=' | grep -i en_us | grep -i utf)"
if [[ -z "${LOCALE_EN_US_CHECK}" ]]; then
  echo "Make sure:"
  echo "            1. Your terminal will not set locale variables automatically."
  echo "            2. Your server is installed using language: English"
  echo ""
  exit 1
fi

LC_ERR_FOUND="$(locale 2>&1 | grep -i cannot)"
if [[ -n "${LC_ERR_FOUND}" ]]; then
  echo "Make sure your terminal will not set locale variables automatically   !!"
  echo ""
  exit 1
fi

# export LC_ALL="en_US.UTF-8"
# export LANG="en_US.UTF-8"

# LC_ERR_FOUND="$(locale 2>&1 | grep -i cannot)"
# if [[ -n "${LC_ERR_FOUND}" ]]; then
#   export LC_ALL="en_US.UTF-8"
#   export LANG="en_US.UTF-8"
# fi


# --- Define github url for os_pre_lib ---
OS_PRE_LIB_GITHUB="https://github.com/charlietag/os_preparation_lib.git"

# --- Define filepath ---
## also in L_01_filepath.sh ##
CURRENT_SCRIPT="$(readlink -m $0)"
CURRENT_FOLDER="$(dirname "${CURRENT_SCRIPT}")"

# --- Define os_preparation_lib path ---
echo "#############################################"
echo "         Preparing required lib"
echo "#############################################"
OS_PRE_LIB="${CURRENT_FOLDER}/../os_preparation_lib"

# ### Make sure os_preparation_lib exists correctly ###
RC=1
if [[ ! -d "${OS_PRE_LIB}" ]]; then
  cd "$CURRENT_FOLDER/../"
  echo "Downloading required lib..."
  git clone $OS_PRE_LIB_GITHUB
  RC=$?
else
  cd $OS_PRE_LIB
  echo "Updating required lib to lastest version..."

  # Avoid newer version of git, will warn you to set pull strategy
  git pull --no-rebase

  # git pull

  RC=$?
fi

if [[ $RC -ne 0 ]]; then
  echo "Error occurs fetching github... !"
  exit
fi

if [[ ! -d "${OS_PRE_LIB}" ]]; then
  echo "${OS_PRE_LIB} does not exist... !"
  exit
fi
echo ""
# ### Make sure os_preparation_lib exists correctly ###

# --- Start ---
echo "#############################################"
echo "            Running start.sh"
echo "#############################################"
echo ""

cd $CURRENT_FOLDER
. "${OS_PRE_LIB}/lib/app.sh"

