#!/bin/bash
#
# 2019-10-28 based on tomcat script
#
# Assume java version on path is appropriate
# Assume started in .

set -eu

echo HACK
 # download to '.'  if needed


# Note this changes more frequently than the download URL
# mvn version
VERSION=3.6.2

# install under here:
INSTALLDIR=.

# download URL
URL=http://apache.spinellicreations.com/maven/maven-3/3.6.2/binaries/apache-maven-$VERSION-bin.tar.gz

BASE=$(basename "$URL")

# you can use a differnt mirror, see site

if [ ! -f "$BASE" ]; then
    if curl -O $URL
    then
	echo Curl download success
    else
	cstat=$?
	echo Sorry, maven download failed.
	echo Check $URL
	echo to find latest version or maybe for an updated .tar.gz URL
	echo or maybe you just have to try again later
	echo "[curl: status $cstat]"
	exit 1
    fi
else
  echo maven already downloaded
fi

# unpack


MVNDIR="apache-maven-$VERSION"
MVNBIN="$MVNDIR/bin"

if [ -d "$MVNDIR" ]; then
  echo 'mvn already extracted...'
else
    if gunzip < $BASE |  (cd $INSTALLDIR; tar xvf -); then
	echo extract with status $?, continuing ..  ; sleep 2
    else
	echo EXTRACT FAILED
	echo file may be corrupt, remove and try again.
	echo if you downloaded HTML instead of data, update the URL
	exit 2
    fi
fi

echo in: $(pwd)
echo ck: $MVNBIN
ls $MVNBIN

if [ -d "$MVNBIN" ]; then
    echo "extracted: " is ere
else
    echo something failed .. ERROR 2
    exit 2
fi 

if ! [ -x "$(pwd)/$MVNBIN/mvn" ]; then
    echo wtf no bin ERROR 3
    exit 3;
fi


# test
PATH="$(pwd)/$MVNBIN:$PATH"

# version -
mvn -version

echo "======================================="
echo "# user instructs"
echo "add this to your init / exec in shell  "
echo
echo "	PATH='$(pwd)/$MVNBIN:\$PATH'"
