#!/bin/sh
#
# 2013-06-05: v7.0.22
# 2016-07-26  v7.0.70
# Assume java
# Assume started in .
# download to '.'  if needed
# and if conf/tomcat-users.xml.bak doesn't exist, this will add a user to conf/tomcat-users.xml
# (see below)

# Note this changes more frequently than the download URL
# tomcat version
VERSION=7.0.70

# install under here:
INSTALLDIR=.

# download URL
URL=http://apache.osuosl.org/tomcat/tomcat-7/v$VERSION/bin/apache-tomcat-$VERSION.tar.gz
# you can use a differnt mirror, eg:
URL=http://apache.claz.org/tomcat/tomcat-7/v$VERSION/bin/apache-tomcat-$VERSION.tar.gz
# 69 http://apache.claz.org/tomcat/tomcat-7/v$VERSION/bin/apache-tomcat-$VERSION.tar.gz
# 70 http://apache.osuosl.org/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz

if [ ! -f apache-tomcat-$VERSION.tar.gz ]; then
    if curl -O $URL
    then
	echo Curl download success
    else
	echo Sorry, tomcat download failed.
	echo Check http://tomcat.apache.org/download-70.cgi
	echo to find latest version or maybe for an updated .tar.gz URL
	echo or maybe you just have to try again later
	echo "[curl: status $?]"
	exit 1
    fi
else
  echo tomcat already downloaded
fi

# unpack

#if [ -d webapps ]; then
if [ -d apache-tomcat-$VERSION ]; then
  echo tomcat already installed, nothing to do
else
    if gzcat apache-tomcat-$VERSION.tar.gz |  (cd $INSTALLDIR; tar xvf -); then
	echo extract with status $?, continuing ..  ; sleep 2
    else
	echo EXTRACT FAILED
	echo file may be corrupt, remove and try again.
	echo if you downloaded HTML instead of data, update the URL
	exit 2
    fi
fi

cd apache-tomcat-$VERSION

#
# add role & user
# 
if [ -f   conf/tomcat-users.xml.bak ]; then
  echo assume user/role already added to   conf/tomcat-users.xml
else
  perl -pi.bak -e 'if ( m=</tomcat-users>= ) { print "<role rolename=\"manager-gui\"/>\n<user username=\"tomcat\" password=\"tomc7pw\" roles=\"manager-gui\"/>\n"; }' \
  conf/tomcat-users.xml
  echo
  sleep 1
  echo ====================== NOTE
  echo =========================== manager-gui role added for tomcat/tomc7pw
  sleep 1
  echo
  echo heres the diff:
  sleep 1
  diff -c   conf/tomcat-users.xml   conf/tomcat-users.xml.bak
  echo
  sleep 5
fi

echo starting up.....
bin/startup.sh

tomcat_log=logs/catalina.out 

# more foolproof might be to wait for the log to quiesce..
# but complex .. and programming

log_activity_timestmp=/tmp/ts.tomcat.yeah-so-what
touch $log_activity_timestmp
sleep 1
# in an error loop this will possibly go on forevery...
while [ $tomcat_log -nt $log_activity_timestmp ]; do
    touch $log_activity_timestmp
    echo ..; tail -2 $tomcat_log
    # also, this might not be long enough if you have some other webapps with long initialization
    sleep 1
done


echo
echo '============ DID IT START ??  '
echo
# should be more than adequate for a modern machine,
# though maybe not long enough for a tiny VM..
sleep 1


# What do we look for ?

tail -30 $tomcat_log | egrep -n 'Except| start|Deploy|Protocol'


echo
echo =================================
echo NEXT:
echo
echo "if your server started:   http://localhost:8080/"
echo
echo manage/install apps: http://localhost:8080/manager/
echo
echo stop server:
echo "cd `pwd`;  bin/shutdown.sh"
echo


# server status
# manager app
# host mananger

# roles:
#  manager-gui
#  manager-status

