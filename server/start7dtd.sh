#!/bin/sh

SERVERDIR=/steamapps 

# Ensure the directory exists before proceeding
if [ ! -d "$SERVERDIR" ]; then
  echo "Error: Server directory $SERVERDIR does not exist!"
  exit 1
fi

cd "$SERVERDIR" || exit 1

export LD_LIBRARY_PATH=.
#export MALLOC_CHECK_=0

echo "Applying environment variables to serverconfig.xml..."
python3 /home/steam/update_config.py

# Correct execution line
exec ./7DaysToDieServer.x86_64 -quit -batchmode -nographics -dedicated -configfile=serverconfig.xml "$@"

