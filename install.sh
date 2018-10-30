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

files="scripts/test-all-policy.bro
scripts/base/init-default.bro
src/analyzer/protocol/CMakeLists.txt
"

dirs="
scripts/base/protocols/enip/
scripts/policy/protocols/enip/
src/analyzer/protocol/enip/
testing/btest/scripts/base/protocols/enip/
testing/btest/scripts/policy/protocols/enip/
testing/btest/Baseline/scripts.base.protocols.enip.*/
testing/btest/Baseline/scripts.policy.protocols.enip.*/
testing/btest/Traces/enip/
scripts/base/protocols/cip/
src/analyzer/protocol/cip/
"

for varname in $dirs
do
    cpy=$path$varname
    echo "Copying files from $varname"
    echo "    to $path$varname"
    cp -r $varname $cpy
done

for varname in $files
do
    cpy=$path$varname
    echo "Copying file $varname"
    echo "    to $path$varname"
    cp $varname $cpy
done
