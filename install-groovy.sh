#!/bin/sh
# Thu Dec  8 11:13:33 EST 2011
# $Id$

# assume started in .
# download to '.'  if needed

# groovy version
#VERSION=1.8.4
VERSION=2.4.7

# install under here:
INSTALLDIR=.

# download
# http://dist.groovy.codehaus.org/distributions/groovy-binary-1.8.4.zip
# http://dist.groovy.codehaus.org/distributions/groovy-binary-2.0.1.zip
# http://dist.groovy.codehaus.org/distributions/groovy-binary-2.1.8.zip
zip=apache-groovy-binary-${VERSION}.zip
#URL=http://dist.groovy.codehaus.org/distributions/$zip
URL=https://dl.bintray.com/groovy/maven/apache-groovy-binary-${VERSION}.zip

if [ ! -f $zip ]; then
  curl -L -o $zip  $URL
else
  echo groovy already downloaded
fi


# unpack
#groovydir=$(echo $zip | sed -e 's/binary-//; s/\.zip//')
groovydir=groovy-${VERSION}
if [ -d $groovydir ]; then
  echo already unpacked
else
  echo unzipping...
  unzip $zip
fi

# start up the console...
#
$groovydir/bin/groovyConsole


