#!/bin/sh
################################################################################
# Title         : generateDocumentationAndDeploy.sh
# Date created  : 2018/04/02
# Notes         :
__AUTHOR__="Jeroen de Bruijn, modified by Siegfried Schöfer"
# The original file can be found here:
#                   https://gist.github.com/vidavidorra/548ffbcdae99d752da02
# Preconditions:
# - Packages doxygen doxygen-doc doxygen-latex doxygen-gui graphviz plantuml
#   must be installed.
# - Doxygen configuration file must have the destination directory empty and
#   source code directory with a $(TRAVIS_BUILD_DIR) prefix.
# - An gh-pages branch should already exist. See below for mor info on hoe to
#   create a gh-pages branch.
#
# Required global variables:
# - TRAVIS_BUILD_NUMBER : The number of the current build.
# - TRAVIS_COMMIT       : The commit that the current build is testing.
# - DOXYFILE            : The Doxygen configuration file.
# - GH_REPO_NAME        : The name of the repository.
# - GH_REPO_REF         : The GitHub reference to the repository.
# - GH_REPO_TOKEN       : Secure token to the github repository.
#
# For information on how to encrypt variables for Travis CI please go to
# https://docs.travis-ci.com/user/environment-variables/#Encrypted-Variables
# or https://gist.github.com/vidavidorra/7ed6166a46c537d3cbd2
# For information on how to create a clean gh-pages branch from the master
# branch, please go to https://gist.github.com/vidavidorra/846a2fc7dd51f4fe56a0
#
# This script will generate Doxygen documentation and push the documentation to
# the gh-pages branch of a repository specified by GH_REPO_REF.
# Before this script is used there should already be a gh-pages branch in the
# repository.
#
################################################################################

################################################################################
##### Setup this script and get the current gh-pages branch.               #####
echo 'Setting up the script...'
# Exit with nonzero exit code if anything fails
set -e

# Install latest Doxygen from git
git clone https://github.com/doxygen/doxygen.git
cd doxygen
mkdir build
cd build
cmake -G "Unix Makefiles" ..
make
sudo make install
cd ..
cd ..
rm -rf doxygen

# Download plantuml and move it to /usr/share/plantuml/
wget https://downloads.sourceforge.net/project/plantuml/plantuml.jar
sudo mkdir /usr/share/plantuml/
sudo mv plantuml.jar /usr/share/plantuml/

# Create a clean working directory for this script.
mkdir code_docs
cd code_docs

# Get the current gh-pages branch
git clone -b gh-pages https://git@$GH_REPO_REF
cd $GH_REPO_NAME

##### Configure git.
# Set the push default to simple i.e. push only the current branch.
git config --global push.default simple
# Pretend to be an user called Travis CI.
git config user.name "Travis CI"
git config user.email "contact@travis-ci.org"

# Remove everything currently in the gh-pages branch.
# GitHub is smart enough to know which files have changed and which files have
# stayed the same and will only update the changed files. So the gh-pages branch
# can be safely cleaned, and it is sure that everything pushed later is the new
# documentation.
rm -rf *

# Need to create a .nojekyll file to allow filenames starting with an underscore
# to be seen on the gh-pages site. Therefore creating an empty .nojekyll file.
# Presumably this is only needed when the SHORT_NAMES option in Doxygen is set
# to NO, which it is by default. So creating the file just in case.
echo "" > .nojekyll

################################################################################
##### Generate the Doxygen code documentation and log the output.          #####
echo 'Doxygen version:'
doxygen -v

echo 'Generating Doxygen code documentation...'
# Redirect both stderr and stdout to the log file AND the console.
doxygen -d markdown $DOXYFILE 2>&1 | tee doxygen.log

################################################################################
##### Upload the documentation to the gh-pages branch of the repository.   #####
# Generate latex documentation
if [ -d "latex" ]; then
  cd latex
  make
  cd ..
  cp latex/refman.pdf .
  rm -r latex
fi

# Only upload if Doxygen successfully created the documentation.
# Check this by verifying that the html directory and the file html/index.html
# both exist. This is a good indication that Doxygen did it's work.
if [ -d "html" ] && [ -f "html/index.html" ]; then
    # Move html one directory up
    mv html/* .
    # Delete html directory
    rm -r html

    echo 'Uploading documentation to the gh-pages branch...'
    # Add everything in this directory (the Doxygen code documentation) to the
    # gh-pages branch.
    # GitHub is smart enough to know which files have changed and which files have
    # stayed the same and will only update the changed files.
    git add --all

    # Commit the added files with a title and description containing the Travis CI
    # build number and the GitHub commit reference that issued this build.
    git commit -m "Deploy code docs to GitHub Pages Travis build: ${TRAVIS_BUILD_NUMBER}" -m "Commit: ${TRAVIS_COMMIT}"

    # Force push to the remote gh-pages branch.
    # The ouput is redirected to /dev/null to hide any sensitive credential data
    # that might otherwise be exposed.
    git push --force "https://${GH_REPO_TOKEN}@${GH_REPO_REF}" > /dev/null 2>&1
else
    echo '' >&2
    echo 'Warning: No documentation (html) files have been found!' >&2
    echo 'Warning: Not going to push the documentation to GitHub!' >&2
    exit 1
fi
