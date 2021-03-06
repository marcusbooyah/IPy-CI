# IPy-CI
[![Build Status](https://travis-ci.org/marcusbooyah/IPy-CI.svg?branch=master)](https://travis-ci.org/marcusbooyah/IPy-CI)   [![Failed Notebooks](https://img.shields.io/badge/failed-notebooks-lightgrey.svg)](http://testipy.s3.amazonaws.com/index.html)

Continuous integration tool for IPython notebooks. This is a voluntary contribution to the Large Synoptic Sky Survey project.

## Overview
This repository contains the utility IPy-CI which can be used as a continuous integration tool for IPython Notebooks in GitHub repositories. The code will run IPython Notebooks as if they are Python files and notify the user of any errors that are thrown during this process.

## Prerequisites:
You must have a Travis CI account, you can get one [HERE](https://travis-ci.org)

IPy-CI can upload failing notebooks to Amazon S3. You'll need to create a new bucket for the repository being tested, and have the Access Keys handy to do this. More information on setting this up below.

## Installation:
Once you've got a Travis CI account set up, login and synchronize your repositories from GitHub.

Next, go to your profile page and enable Travis CI for the repository you want to build, it should look something like this:

![Travis sync enabled](https://raw.githubusercontent.com/marcusbooyah/IPy-CI/master/img/travis.png)

Finally, copy this [.travis.yml](https://raw.githubusercontent.com/marcusbooyah/IPy-CI/master/.travis.yml) (right click, save link as) file into the GitHub repository containing the IPython notebooks you want to test.

You can now trigger a build with a `$ git push` using the default settings.

## Configuration

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
There are a few things to note when doing this. The maximum output size allowed by Travis is 4mb, while this sounds like a lot, using certain commands will use this up very quickly! For example, when using the `wget` command it is a very good idea to run it in quiet mode like this:

```
wget -q http://yourdomain/yourfile
```
There are some commands that do not have options like this, but there is another workaround we can use, sending the output to `/dev/null`. Here I'll show a command using `conda clean` which is very useful to conserve space on the 16GB Travis system!
```
conda clean -y -t -p -s > /dev/null 2>&1
```

## S3 Integration
 IPy-CI can upload any IPython Notebooks that throw errors to an S3 Bucket. You'll need to sign up to [Amazon AWS](aws.amazon.com/free) and create an S3 Bucket.

 Next, you need to setup a pair of Access Keys, this is in the Security Credentials menu under your name at the top right of the S3 Dashboard. Click "Create New Access Key" and be sure to make note of the Access Key as well as the Secret Access Key, as you wont be able to retrieve it once you close the dialog.

 Now it's time to tell Travis how to access your bucket. The easiest and most secure way to configure this is to have Travis do it for you.

 You'll need to install Travis if you haven't already. To install Travis on your machine, follow the instructions [HERE](https://github.com/travis-ci/travis.rb#installation)

 You can then use Travis to setup S3 integration for your repository. You'll need to be in the repository directory on the command line:

```
$ travis setup s3
```
After this command is run, Travis will ask you to confirm that you are in the correct repository. Then you'll be asked to configure the following:
```
[IPy-CI]# travis setup s3
Access key ID:
Secret access key:
Bucket:
Local project directory to upload (Optional): fails
S3 upload directory (Optional):
S3 ACL Settings (private, public_read, public_read_write, authenticated_read, bucket_owner_read, bucket_owner_full_control):
Encrypt secret access key? |yes| yes
Push only from marcusbooyah/IPy-CI? |yes|
Push from testing branch? |yes|
```

Be sure to enter fails as the local upload directory and encrypt the Secret Access Key.

The .travis.yml file should include something like this when done:

```
deploy:
  provider: s3
  access_key_id: ACCESS KEY
  secret_access_key:
    secure:  YOUR SECURE KEY
  bucket: YOUR BUCKET NAME
  skip_cleanup: true
  local-dir: fails
  upload-dir: "$d"
  on:
    all_branches: true
```

More information about Amazon S3 deployment in Travis can be found [HERE](http://docs.travis-ci.com/user/deployment/s3/).

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
