set -e
ERROR=0
mkdir ./fails
while read line
        do
          	echo "Processing $line"
                if runipy "./$line" "./$line-tested.ipynb"; then # 2>"./$line.out"; then
                        echo "$line" passed.
                        echo
                else
                        echo "$line" failed.
                        cp "./$line-tested.ipynb" "./fails"
			ERROR=1
                        echo
                fi
        done < notebooks.out
echo "These notebooks failed"
ls -l ./fails
echo
