# =====================
# Enable databag
# =====================
# DATABAG_CFG:enable
# ------------------------------------
# Check if this script is enabled
# ------------------------------------
# Make sure apply action is currect.
[[ -z "$(echo "${this_script_status}" | grep "enable")" ]] && eval "${SKIP_SCRIPT}"


# ***************************
# logwatch
# ***************************
dnf install -y logwatch

# ***************************
# logwatch
# ***************************
# -- goaccess does not exist in CentOS8 repos (base, appstream, epel) --
#dnf install -y goaccess

# -- Manually install --
dnf install -y GeoIP GeoIP-devel

#-----------------------------------------------------------------------------------------
# Compile and install goaccess
#-----------------------------------------------------------------------------------------
cd $TMP

local goaccess_script="/usr/local/bin/goaccess"
local goaccess_url="https://github.com/allinurl/goaccess/archive/v${goaccess_ver}.tar.gz"

# Download source code
wget $goaccess_url -O - | tar -xz

# Compile bin file
cd goaccess-${goaccess_ver}
autoreconf -fiv
./configure --enable-utf8 --enable-geoip=legacy
make
cp goaccess ${goaccess_script}

# Delete source code
cd $TMP
SAFE_DELETE "goaccess-${goaccess_ver}"






# ***************************
# Postfix log parse
# ref. http://www.postfix.org/addon.html#logfile
# ***************************
# The same function as what logwatch does
#dnf install -y postfix-perl-scripts
#sed -i /pflogsumm/d /etc/crontab
#echo "01 01 * * * root /usr/sbin/pflogsumm -d yesterday /var/log/maillog" >> /etc/crontab

# ***************************
# setup config
# ***************************
task_copy_using_cat
