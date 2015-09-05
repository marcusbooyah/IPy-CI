# Find IPython Notebooks in repo recursively
# $NOTEBOOKS (set in .travis.yml) is the directory to look in, default is to be left blank
# The output is a list of notebooks in notebooks.out
# This script is to be sourced from .travis.yml
rm -f notebooks.out
echo $PWD
if [[ $TRAVIS_PULL_REQUEST != "false" ]]; then # if trigger was PR, check only updated files
  echo "This is a pull request, only changed files will be tested."
	git diff --name-only HEAD > changes.out
  cat changes.out | grep -o '.*\.ipynb$' > notebooks.out
else # if trigger was a git push, test all files in repo
  echo "This is not a pull request, all files in specified directory will be tested."
  find "./$NOTEBOOKS" ! -path "./miniconda/*" -name "*.ipynb" -print | cut -c 3- > notebooks.out
fi
echo "The following files will be tested:"
cat notebooks.out
