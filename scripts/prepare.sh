#!/bin/bash -x
#
# This script needs to be _sourced_ from travis.yml
# so $PATH is set up correctly
#

set -e
echo Disk space available:
df -kh .
# keep the pkginfo cache database outside the conda-lsst dir
# so Travis can cache it easily.
mkdir -p pkginfo-cache

#
# Install Miniconda
#

if [[ ! -f "$PWD/miniconda/.installed" ]] 2>"f.out"; then
        case "$OSTYPE" in
                linux*)  MINICONDA_SH=Miniconda-latest-Linux-x86_64.sh ;;
                darwin*) MINICONDA_SH=Miniconda-latest-MacOSX-x86_64.sh ;;
                *)	 echo "Unsupported OS $OSTYPE. Exiting."; exit -1 ;;
        esac

	rm -f "$MINICONDA_SH"
        rm -rf "$PWD/miniconda"
        curl -O https://repo.continuum.io/miniconda/"$MINICONDA_SH"
        bash "$MINICONDA_SH" -b -p "$PWD/miniconda"
        rm -f "$MINICONDA_SH"

        #
	# Install prerequisites
        #
	export PATH="$PWD/miniconda/bin:$PATH"
        conda install -q conda-build jinja2 binstar requests sqlalchemy pip ipython-notebook --yes > /dev/null 2>&1

        pip install requests_file runipy jsonschema > /dev/null 2>&1

        # marker that we're done
        touch "$PWD/miniconda/.installed"
else
    	echo
	echo "Found Miniconda in $PWD/miniconda; skipping Miniconda install."
        echo
fi

hash -r
