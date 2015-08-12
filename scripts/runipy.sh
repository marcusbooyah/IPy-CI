set -e
ERROR=0
while read line
        do
          	echo "Processing $line"
                if runipy "./$line" "./$line-tested.ipynb"; then # 2>"./$line.out"; then
                                echo "$line" passed.
                        echo
                else
                                echo "$line" failed.
                        ERROR=1
                        echo
                fi
        done < notebooks.out
exit $ERROR
