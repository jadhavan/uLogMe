#!/bin/bash

# Use https://bitbucket.org/lbesson/bin/src/master/.color.sh to add colors in Bash scripts
echo "WARNING If you don't see colors correctly, remove the 'color.sh' file in 'uLogMe/scripts' to remove the colors, or modify it to suit your need (if you have a light background for instance)."  # See https://github.com/Naereen/uLogMe/issues/17
[ -f color.sh ] && . color.sh

if [ "$(uname)" == "Darwin" ]; then
  # This is a Mac
  ./osx/run_ulogme_osx.sh
else
  # Assume Linux
  echo "$( dirname "${BASH_SOURCE[0]}" )"
  sudo echo -n ""
  sudo ./keyfreq.sh &
  ./logactivewin.sh
fi
