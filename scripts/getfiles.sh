rm -f notebooks.out
echo $PWD
if [[ $TRAVIS_PULL_REQUEST != "false" ]]; then
  echo "This is a pull request, only changed files will be tested."
	git diff --name-only HEAD > changes.out
  cat changes.out | grep -o '.*\.ipynb$' > notebooks.out
else
  echo "This is not a pull request, all files in specified directory will be tested."
  find "./$NOTEBOOKS" ! -path "./miniconda/*" -name "*.ipynb" -print | cut -c 3- > notebooks.out
fi
echo "The following files will be tested:"
cat notebooks.out
