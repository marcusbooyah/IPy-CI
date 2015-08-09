# TestIPy
[![Build Status](https://travis-ci.org/marcusbooyah/TestIPy.svg?branch=master)](https://travis-ci.org/marcusbooyah/TestIPy)
Test IPython notebooks on a remote VM automatically

## Requirements:
You must have a Travis CI account, you can get one [HERE](https://travis-ci.org)

Once you’re signed in, and synchronized your repositories from GitHub, go to your profile page and enable Travis CI for the repository you want to build.

## Installation:
Clone 'master' into a directory and copy the files into the GitHub repository you want to build.

## Running
Trigger your first build with a git push.

By default, all IPython notebooks in your repository will be tested.

## Advanced Configuration
This script installs the following packages for testing:
  - miniconda
  - jsonschema
  - runipy
If your build has further requirements, add them to the .travis.yml file at the end of the install section, for example:

```
install:
- pip install matplotlib
```

You can specify a specific directory containing your IPython notebooks. To do this, edit the .travis.yml file as follows

```
- NOTEBOOKS=" <your notebook directory> "
```
