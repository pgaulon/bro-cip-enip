#!/bin/bash

# This script copies the necessary files
# to parse the EtherNet/IP packets into bro directory.
#
# Precondition:
# -have the bro sources
#
# Usage: ./install </path/to/bro/>
# (please note the last /)
# Then recompile bro (in bro directory)
# # ./configure && make && make install

if [ $# -eq 0 ]
  then
    echo "You need to specify the Bro installation directory."
    echo "Usage: $0 </path/to/bro/>"
    exit 1
fi

path=$1

find . -iname "*enip*" -type d -exec bash -c 'echo Executing: cp -r {} ../bro/$(dirname {})/' \;
find . -iname "*enip*" -type d -exec bash -c 'cp -r {} ../bro/$(dirname {})/' \;

if [ $(grep -c enip $path/scripts/test-all-policy.bro) -eq 0 ]
then
	echo "Adding @load protocols/enip/detect-metasploit.bro to $path/scripts/test-all-policy.bro"
	echo '@load protocols/enip/detect-metasploit.bro' >> $path/scripts/test-all-policy.bro
fi
if [ $(grep -c enip $path/scripts/base/init-default.bro) -eq 0 ]
then
	echo "Adding @load base/protocols/enip to $path/scripts/base/init-default.bro"
	echo '@load base/protocols/enip' >> $path/scripts/base/init-default.bro
fi
if [ $(grep -c enip $path/src/analyzer/protocol/CMakeLists.txt) -eq 0 ]
then
	echo "Adding add_subdirectory(enip) to $path/src/analyzer/protocol/CMakeLists.txt"
	echo 'add_subdirectory(enip)' >> $path/src/analyzer/protocol/CMakeLists.txt
fi
