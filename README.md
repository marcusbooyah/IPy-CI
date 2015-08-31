# TestIPy
[![Build Status](https://travis-ci.org/marcusbooyah/IPy-CI.svg?branch=testing)](https://travis-ci.org/marcusbooyah/IPy-CI) [Failed Notebooks](http://testipy.s3.amazonaws.com/index.html)

Continuous integration tool for IPython notebooks.

## Requirements:
You must have a Travis CI account, you can get one [HERE](https://travis-ci.org)

Once you’re signed in, and synchronized your repositories from GitHub, go to your profile page and enable Travis CI for the repository you want to build.

## Installation:
Clone 'master' into a directory and copy the files into the GitHub repository you want to build.

## S3 Integration
IPy-CI can upload failing notebooks to S3 for you. The easiest way to configure this is to have Travis do it.
```
$ travis setup s3
```
More information about S3 deployment in Travis can be found [HERE](http://docs.travis-ci.com/user/deployment/s3/).

If you want these notebooks to be available publicly, have a look at [this repo](https://github.com/marcusbooyah/s3-bucket-listing).

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
By default, all IPython notebooks in your repository will be tested.
## Running
Trigger your first build with a git push.
