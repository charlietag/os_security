#!/bin/bash
#*****************************************************************************
#* Choose "Minimal Server" during the intstallation (works With Minimal ISO)
#*****************************************************************************
# --- Define github url for os_pre_lib
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
if [[ ! -d "${OS_PRE_LIB}" ]]; then
  cd "$CURRENT_FOLDER/../"
  echo "Downloading required lib..."
  git clone $OS_PRE_LIB_GITHUB
else
  cd $OS_PRE_LIB
  echo "Updating required lib to lastest version..."
  git pull
fi
echo ""

# --- Define lib path ---
## also in app.sh ##
LIB="${OS_PRE_LIB}/lib"

# --- Start ---
echo "#############################################"
echo "            Running start.sh"
echo "#############################################"
echo ""

cd $CURRENT_FOLDER
. "${OS_PRE_LIB}/lib/app.sh"

