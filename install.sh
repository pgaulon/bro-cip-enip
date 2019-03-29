#!/bin/bash

# This script copies the necessary files
# to parse the EtherNet/IP packets into Zeek  source code directory.
#
# Precondition:
# - have the Zeek sources
#
# Usage: ./install </path/to/zeek/>
# Then recompile Zeek (in Zeek directory)
# # ./configure && make && make install

if [ $# -eq 0 ]
  then
    echo "You need to specify the Zeek installation directory."
    echo "Usage: $0 </path/to/zeek/>"
    exit 1
fi

path=$1

find . -iname "*enip*" -type d -exec echo Executing: cp -r {} $path/{}/ \;
find . -iname "*enip*" -type d -exec cp -r {} $path/{}/ \;

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
