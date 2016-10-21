# Download Necessary files to install IPy-CI
# This script is to be sourced from .travis.yml
set -e
echo "Downloading IPy-CI"
wget https://raw.githubusercontent.com/marcusbooyah/IPy-CI/master/scripts/prepare.sh -P ./scripts
wget https://raw.githubusercontent.com/marcusbooyah/IPy-CI/master/scripts/getfiles.sh -P ./scripts
wget https://raw.githubusercontent.com/marcusbooyah/IPy-CI/master/scripts/runipy.sh -P ./scripts