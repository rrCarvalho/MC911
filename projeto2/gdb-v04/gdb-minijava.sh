#!/bin/bash


echo -e "handle SIGPWR nostop noprint\nhandle SIGXCPU nostop noprint" > gdbinit
gdb -x gdbinit --args ./minijava $1
rm gdbinit


