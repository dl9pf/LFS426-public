#!/bin/bash


RUNDIR=~/LFS426-tests
#echo $RUNDIR

#DOWNLOAD
function dl {

    if test ! -f $1 ; then 
	wget -O $1 "$2" || exit 1
    fi
}

LTPURL="https://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20140115/ltp-full-20140115.tar.xz/download"
LTPFILE="ltp-full-20140115.tar.xz"
LTPDIR="ltp-full-20140115"

LMBENCH2URL="http://www.bitmover.com/lmbench/lmbench2.tar.gz"
LMBENCH2FILE="lmbench2.tar.gz"
LMBENCH2DIR=""
LMBENCH3URL="http://www.bitmover.com/lmbench/lmbench3.tar.gz"
LMBENCH3FILE="lmbench3.tar.gz"
LMBENCH3DIR=""

UNIXBENCHURL="https://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz"
UNIXBENCHFILE="UnixBench5.1.3.tgz"
UNIXBENCHDIR=""

AIMURL="http://downloads.sourceforge.net/project/re-aim-7/re-aim/7.0.1.13/osdl-aim-7.0.1.13.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fre-aim-7%2F&ts=1392037318&use_mirror=switch"
AIMFILE="osdl-aim-7.0.1.13.tar.gz"
AIMDIR=""

STREAMURL="http://www.cs.virginia.edu/stream/FTP/Code/stream.c"
STREAMFILE="stream.c"
STREAMDIR="stream-test"



mkdir -p $RUNDIR
pushd $RUNDIR
    
    #DOWNLOAD
    dl $LTPFILE $LTPURL

    dl $LMBENCH2FILE $LMBENCH2URL
    dl $LMBENCH3FILE $LMBENCH3URL

    dl $UNIXBENCHFILE $UNIXBENCHURL

    dl $AIMFILE $AIMURL

    dl $STREAMFILE $STREAMURL

popd