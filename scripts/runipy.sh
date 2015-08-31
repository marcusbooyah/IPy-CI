set -e
ERROR=0
mkdir fails
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
if [ $ERROR = 1 ]; then
	echo "The following notebooks failed"
	find . -name "*failed.ipynb" | xargs tar cvf - | (cd ./fails ; tar xfp -)
else
	echo "All notebooks passed"
fi
