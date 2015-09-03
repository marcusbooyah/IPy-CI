# IPy-CI
[![Build Status](https://travis-ci.org/marcusbooyah/IPy-CI.svg?branch=master)](https://travis-ci.org/marcusbooyah/IPy-CI)   [![Failed Notebooks](https://img.shields.io/badge/failed-notebooks-lightgrey.svg)](http://testipy.s3.amazonaws.com/index.html)

Continuous integration tool for IPython notebooks.

## Overview
This repository contains the utility `IPy-CI` which can be used as a continuous integration tool for IPython Notebooks in GitHub repositories. The code will run IPython Notebooks as if they are Python files and notify the user of any errors that are thrown during this process.

## Prerequisites:
You must have a `Travis CI` account, you can get one [HERE](https://travis-ci.org)

Once you’re signed in, and have synchronized your repositories from GitHub, go to your profile page and enable Travis CI for the repository you want to build.

`IPy-CI` can upload failing notebooks to `Amazon S3`. You'll need to create a new bucket for the repository being tested, and have the Access Keys handy to do this. More information on setting this up below.

## Installation:
To install copy this [.travis.yml](https://raw.githubusercontent.com/marcusbooyah/IPy-CI/master/.travis.yml) (right click, save link as) file into the GitHub repository containing the IPython notebooks you want to test.

#### Configuration
 
IPy-CI wants to know where to look for IPython Notebooks in your repository.

You can specify a specific directory containing your IPython notebooks. To do this, edit the `.travis.yml` file as follows:

```
- NOTEBOOKS=" <your notebook directory> "
```

By default, this field is left blank and all IPython Notebooks in your repository will be tested.
## Installing Additional Dependencies
This script installs the following packages for testing:
  - `miniconda`
  - `jsonschema`
  - `runipy`

If your build has further requirements, you can add these to the `.travis.yml` file at the end of the install section, for example:

```
install:
- pip install matplotlib
```

Alternatively you could add another script to the `.travis.yml` file, for example:

```
script:
- df -kh .
- source ./scripts/prepare.sh
- export PATH="$PWD/miniconda/bin:$PATH"
- source ./scripts/YOUR_ADDITIONAL_DEPENDENCIES.sh
- source ./scripts/getfiles.sh
- source ./scripts/runipy.sh
```

## S3 Integration
 The easiest and most secure way to configure this is to have Travis do it for you.

 You'll need to install Travis if you haven't already. The easiest way is to use pip:
 
 ```
 $ pip install travis
 ```
 
 [More information about Travis, including installation help](https://github.com/travis-ci/travis.rb#mac-os-x-via-homebrew)

 You can then use Travis to setup S3 integration for your repository. You'll need to be in the repository directory on the command line:

```
$ travis setup s3
```

After this command is run, you'll be asked to enter your Access Key and Secret Access Key. It's a good idea to have Travis encrypt the Secret Access Key for you when prompted.

More information about `Amazon S3` deployment in Travis can be found [HERE](http://docs.travis-ci.com/user/deployment/s3/).

If you want these notebooks to be available publicly, have a look at [this repo](https://github.com/marcusbooyah/s3-bucket-listing).


## Running
Trigger your first build with a `git push`.

## Technical Details
This code was written as a proof of concept, utilizing [runipy](https://github.com/paulgb/runipy) and [Travis](https://travis-ci.org/) to develop a continuous integration tool for IPython Notebooks.

There are four main phases to the process:
 - GitHub push / pull request triggering Travis build.
 - Installation of dependancies on Travis machine according to the `.travis.yml` file in your repository. Important files are downloaded first using the `dl.sh` script before the main dependancies are installed using the `prepare.sh` script.
 - Find all IPython Notebooks in the repository using directory constraingts (if any) this is done in the `getfiles.sh` script.
 - Run the list of files obtained above using [runipy](https://github.com/paulgb/runipy). This is the most important part of the process, where the IPython Notebooks are tested for errors using the `runipy.sh` script.
