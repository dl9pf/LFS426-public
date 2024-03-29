#!/bin/bash
# Download, build and run various benchmarks
#
# (C) 2014 Jan-Simon Möller dl9pf@gmx.de
# License GPLv2


RUNDIR=~/LFS426-tests
BUILDDIR=build
DATEDIR=`date +%F--%H-%M`
#echo $RUNDIR

#DOWNLOAD
function dl {

    if test ! -f $1 ; then 
	wget -O $1 "$2" || exit 1
    fi
}

function extract {

    if test ! -d $2 ; then
	tar -xf ../$1 || exit 1
    fi

}

LTPURL="https://sourceforge.net/projects/ltp/files/LTP%20Source/ltp-20140115/ltp-full-20140115.tar.xz/download"
LTPFILE="ltp-full-20140115.tar.xz"
LTPDIR="ltp-full-20140115"

LMBENCH2URL="http://www.bitmover.com/lmbench/lmbench2.tar.gz"
LMBENCH2FILE="lmbench2.tar.gz"
LMBENCH2DIR="lmbench2"
LMBENCH3URL="http://www.bitmover.com/lmbench/lmbench3.tar.gz"
LMBENCH3FILE="lmbench3.tar.gz"
LMBENCH3DIR="lmbench3"

UNIXBENCHURL="https://byte-unixbench.googlecode.com/files/UnixBench5.1.3.tgz"
UNIXBENCHFILE="UnixBench5.1.3.tgz"
UNIXBENCHDIR="UnixBench"

AIMURL="http://downloads.sourceforge.net/project/re-aim-7/re-aim/7.0.1.13/osdl-aim-7.0.1.13.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fre-aim-7%2F&ts=1392037318&use_mirror=switch"
AIMFILE="osdl-aim-7.0.1.13.tar.gz"
AIMDIR="osdl-aim-7"

AIM2URL=
AIM2FILE=
AIM2DIR=

STRESSURL="http://people.seas.harvard.edu/~apw/stress/stress-1.0.4.tar.gz"
STRESSFILE="stress-1.0.4.tar.gz"
STRESSDIR="stress-1.0.4"

STREAMURL="http://www.cs.virginia.edu/stream/FTP/Code/stream.c"
STREAMFILE="stream.c"
STREAMDIR="stream-test"

LLCBENCHURL="http://icl.cs.utk.edu/projects/llcbench/llcbench.tar.gz"
LLCBENCHFILE="llcbench.tar.gz"
LLCBENCHDIR="llcbench"

mkdir -p $RUNDIR
pushd $RUNDIR
    
    #DOWNLOAD
    dl $LTPFILE $LTPURL

    dl $LMBENCH2FILE $LMBENCH2URL
    dl $LMBENCH3FILE $LMBENCH3URL

    dl $UNIXBENCHFILE $UNIXBENCHURL

    dl $AIMFILE $AIMURL

    dl $STRESSFILE $STRESSURL
    dl $STREAMFILE $STREAMURL

    dl $LLCBENCHFILE $LLCBENCHURL

popd

# BUILD
pushd $RUNDIR
    mkdir -p $BUILDDIR
    pushd $BUILDDIR
	
	# LTP
	extract $LTPFILE $LTPDIR
	pushd $LTPDIR
		if test ! -d out ; then 
			./configure --prefix=`pwd`/out
			make
			make install
		fi
	popd
	
	# LMBENCH2
	extract $LMBENCH2FILE $LMBENCH2DIR
	pushd $LMBENCH2DIR
	    if test ! -f bin/x86_64-linux-gnu/lmbench.a ; then
		sed -i -e "s#all: \$(EXES) bk.ver#all: \$(EXES)#" src/Makefile
		sed -i -e "s#RESULTS=Results/\$(OS)#RESULTS?=Results/\$(OS)#" src/Makefile
		make
	    fi
	popd
	#
	
	# LMBENCH3
	extract $LMBENCH3FILE $LMBENCH3DIR
	pushd $LMBENCH3DIR
	    if test ! -f bin/x86_64-linux-gnu/lmbench.a ; then
		sed -i -e "s#\$O/lmbench : ../scripts/lmbench bk.ver#\$O/lmbench : ../scripts/lmbench#" src/Makefile
		make 
	    fi
	popd
	
	# UNIXBENCH
	extract $UNIXBENCHFILE $UNIXBENCHDIR
	pushd $UNIXBENCHDIR
	    if test ! -f ./pgms/dhry2 ; then
		make clean
		make
	    fi
	popd
	
	# AIM
	extract $AIMFILE $AIMDIR
	pushd $AIMDIR
	    if test ! -f aclocal.m4 ; then
		sed -i -e 's#CFLAGS="-W -Wall -lm -ffloat-store -g -O -D_GNU_SOURCE -DSHARED_OFILE"#CFLAGS="-W -Wall -lm -ffloat-store -g -O -D_GNU_SOURCE -DSHARED_OFILE -laio -lpthread"#g' configure.in
		sed -i -e 's#"-O2 -g -pg"#"-O2 -g -pg -laio -lpthread"#' src/configure.in
		./bootstrap
	    fi
	    if test ! -f /usr/local/bin/reaim ; then
		./configure
		make
		echo "" | make install
	    fi
	popd
	
	# Stress
	extract $STRESSFILE $STRESSDIR
	pushd $STRESSDIR
	    if test ! -d out ; then
		./configure --prefix=`pwd`/out
		make
		make install
	    fi
	popd
	
	# Stream
	mkdir -p $STREAMDIR
	pushd $STREAMDIR
	    gcc -o stream ../../$STREAMFILE
	popd
	
	# llcbench
	extract $LLCBENCHFILE $LLCBENCHDIR
	pushd $LLCBENCHDIR
	    mkdir bin
	    ln -sf /usr/bin/gfortran bin/g77
	    export PATH=$PATH:`pwd`/bin
	    make linux-lam
	    make cache-bench 
	    # cache-run, cache-script, cache-graph
	popd
	
    popd
popd

#exit 0
# RUN
pushd $RUNDIR
    mkdir -p $DATEDIR
	pushd $DATEDIR
#		if false; then
		mkdir -p ltp
		pushd ltp
#			$RUNDIR/$BUILDDIR/$LTPDIR/out/runltp -p -d `pwd` -C `pwd`/failed.cmd -l `pwd`/ltp.log -o `pwd`/result.log -g `pwd`/result.html 
		popd
		
		if false ; then
		mkdir -p lmbench2
		pushd lmbench2
			cat > $RUNDIR/$BUILDDIR/$LMBENCH2DIR/bin/x86_64-linux-gnu/CONFIG.$(hostname) << EOF
DISKS=""; export DISKS
DISK_DESC=""; export DISK_DESC
OUTPUT=/dev/tty; export OUTPUT
ENOUGH=1000000; export ENOUGH
FASTMEM="NO"; export FASTMEM
FILE=/tmp/XXX; export FILE
FSDIR=/tmp; export FSDIR
INFO=INFO.LF426; export INFO
LOOP_O=0.00006442; export LOOP_O
MAIL=no; export MAIL
MB=348; export MB
MHZ="3054 MHz, 0.33 nanosec clock"; export MHZ
MOTHERBOARD=""; export MOTHERBOARD
NETWORKS=""; export NETWORKS
OS="x86_64-linux-gnu"; export OS
PROCESSORS=""; export PROCESSORS
REMOTE=""; export REMOTE
SLOWFS="NO"; export SLOWFS
TIMING_O=0; export TIMING_O
RSH=rsh; export RSH
RCP=rcp; export RCP
VERSION=lmbench-2alpha13; export VERSION
EOF
			make -C $RUNDIR/$BUILDDIR/$LMBENCH2DIR rerun | tee log.txt
			mv $RUNDIR/$BUILDDIR/$LMBENCH2DIR/results/x86_64-linux-gnu/* .
		popd
		fi
		
		mkdir -p lmbench3
		pushd lmbench3
			cat > $RUNDIR/$BUILDDIR/$LMBENCH3DIR/bin/x86_64-linux-gnu/CONFIG.$(hostname) << EOF
DISKS=""; export DISKS
DISK_DESC=""; export DISK_DESC
OUTPUT=/dev/tty; export OUTPUT
ENOUGH=1000000; export ENOUGH
FASTMEM="NO"; export FASTMEM
FILE=/tmp/XXX; export FILE
FSDIR=/tmp; export FSDIR
INFO=INFO.LF426; export INFO
LOOP_O=0.00006442; export LOOP_O
MAIL=no; export MAIL
MB=348; export MB
MHZ="3054 MHz, 0.33 nanosec clock"; export MHZ
MOTHERBOARD=""; export MOTHERBOARD
NETWORKS=""; export NETWORKS
OS="x86_64-linux-gnu"; export OS
PROCESSORS=""; export PROCESSORS
REMOTE=""; export REMOTE
SLOWFS="NO"; export SLOWFS
TIMING_O=0; export TIMING_O
RSH=rsh; export RSH
RCP=rcp; export RCP
VERSION=lmbench-3; export VERSION
EOF
			make -C $RUNDIR/$BUILDDIR/$LMBENCH3DIR rerun | tee log.txt
			mv $RUNDIR/$BUILDDIR/$LMBENCH3DIR/results/x86_64-linux-gnu/* .
		popd

		# UnixBench
		mkdir -p UnixBench
		pushd UnixBench
			pushd $RUNDIR/$BUILDDIR/$UNIXBENCHDIR/
			    ./Run
			popd
			    mv $RUNDIR/$BUILDDIR/$UNIXBENCHDIR/results/* .
			popd
		popd
		
		# reaim
		mkdir -p reaim
		pushd reaim
		    set -x
		    mkdir -p /tmp/diskdir
		    mkdir -p out
		    reaim -l `pwd`/out
		popd
		

		# stress
		mkdir -p stress
		pushd stress
		    $RUNDIR/$BUILDDIR/$STRESSDIR/out/bin/stress --cpu 2 --io 1 --vm 1 --vm-bytes 128M --timeout 10s --verbose > stress.log
		popd
		
		# stream
		mkdir -p stream
		pushd stream
		    $RUNDIR/$BUILDDIR/$STREAMDIR/stream 2>&1 > stream.log
		popd
#		fi
		
		# llcbench (cachebench)
		mkdir -p llcbench
		pushd llcbench
		    make -C $RUNDIR/$BUILDDIR/$LLCBENCHDIR/ cache-run cache-script cache-graph
		popd

	popd
	
popd
