#!/bin/sh
#
# 2013-06-05: v7.0.22
# Assume java
# Assume started in .
# download to '.'  if needed
# and if conf/tomcat-users.xml.bak doesn't exist, this will add a user to conf/tomcat-users.xml
# (see below)

# tomcat version
VERSION=7.0.69

# install under here:
INSTALLDIR=.

# download

if [ ! -f apache-tomcat-$VERSION.tar.gz ]; then
  curl -O http://apache.claz.org/tomcat/tomcat-7/v$VERSION/bin/apache-tomcat-$VERSION.tar.gz
#	  http://mirror.olnevhost.net/pub/apache/tomcat/tomcat-7/v7.0.47/bin/apache-tomcat-$VERSION.tar.gz
#	  http://mirror.olnevhost.net/pub/apache/tomcat/tomcat-7/v7.0.22/bin/apache-tomcat-$VERSION.tar.gz
else
  echo tomcat already installed
fi

# unpack

#if [ -d webapps ]; then
if [ -d apache-tomcat-$VERSION ]; then
  echo tomcat already installed, nothing to do
else
  gzcat apache-tomcat-$VERSION.tar.gz |  (cd $INSTALLDIR; tar xvf -)
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

