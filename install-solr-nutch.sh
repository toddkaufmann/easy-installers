#!/bin/sh
# $Revision: 1096 $

installdir=$HOME/dev/nutch-solr

cd "$installdir"

# some hints @ http://blog.building-blocks.com/building-a-search-engine-with-nutch-and-solr-in-10-minutes

# solr
#  - d/l:  via http://www.apache.org/dyn/closer.cgi/lucene/solr/4.3.0
solrversion=4.3.0
solrdist="solr-$solrversion.tgz"
solrdir="http://apache.mirrors.pair.com/lucene/solr/$solrversion"

if [ -f "$solrdist" ]; then 
  echo  "$solrdist" already downloaded.
else
  echo downloading  "$solrdist" ...
  curl -O "$solrdir/$solrdist"
fi

# folder in tgz 
solrfolder="solr-$solrversion"
if [ -d "$solrfolder" ]; then
  echo $solrfolder already unpacked
else
  echo unpacking "$solrdist" to  ${solrfolder}...
  if  tar zxf "$solrdist"; then
    echo untar success
    if [ ! -d "$solrfolder" ]; then
      echo .. but no "$solrfolder"  !
      exit 1
    fi
  else
    echo tar failed with $!
    exit 2
  fi
fi


#  - unpack
#  - startup
port=8983
# test on osx..
if netstat -na | grep LIST | grep "\*.$port "; then
  echo looks like solr is already running
else
  echo starting solr via start.jar...
  java -jar start.jar > start.out 2> start.err &
  sleep 10
  # could loop, looking for the ready msg
  # exceptions?  what do they look like ?
  echo look for the Start message...:
  grep $port start.{out,err}
  echo see `pwd`/start.out for more info
fi
echo
echo "try solr at:  http://localhost:$port/solr/#/"
echo

sleep 3

cd $installdir

# nutch
nutchversion=2.1
# works for 1.6? dunno
nutchmirror=http://psg.mtu.edu/pub/apache/nutch/
nutch="apache-nutch-$nutchversion"
nutchsrc="$nutch-src"
nutchdl="$nutchmirror/$nutchversion/$nutchsrc.tar.gz"
#  - d/l
if [ -f "$nutchsrc.tar.gz" ]; then
  echo "$nutchsrc.tar.gz" already downloaded..
else
  curl -O "$nutchdl"
fi

# extract
if [ -d "$nutch" ]; then
  echo appears extracted
else
  echo extracting  "$nutchsrc.tar.gz" ...
  tar zxf "$nutchsrc.tar.gz"
fi

#  - edit nutch-site.xml 
#    "basically sets the userAgent property used in the HTTP request headers when Nutch hits a site."
# 
echo
echo .. ready for some edits to nutch-site.xml ?

