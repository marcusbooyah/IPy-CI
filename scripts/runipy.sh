# Run all IPython Notebook files using runipy
# This script is to be sourced from .travis.yml
# Notebooks which throw errors are copied into ./fails
# S3 deployment uploads the .
set -e
ERROR=0
mkdir fails # this is where troublesome notebooks will be placed
while read line
        do
          	echo "Processing $line"
                if runipy "./$line" "./$line-tested.ipynb" 2>"./$line.out"; then
                        echo "$line" passed.
                        echo
                else
                        echo "$line" failed.
                        mv "./$line-tested.ipynb" "./$line-failed.ipynb"
			ERROR=1
                        echo
                fi
        done < notebooks.out
if [ $ERROR = 1 ]; then # move all failing notebooks to the fails directory
	echo "The following notebooks failed"
	##find . -name "*failed.ipynb" | xargs tar cvf - | (cd ./fails ; tar xfp -)
    find . -name "*failed.ipynb" | cpio -pd ./fails
else
	echo "All notebooks passed"
fi
