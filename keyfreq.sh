#!/bin/bash


# logs the key press frequency over 9 second window. Logs are written
# in logs/keyfreqX.txt every 9 seconds, where X is unix timestamp of 7am of the
# recording day.


# Use https://bitbucket.org/lbesson/bin/src/master/.color.sh to add colors in Bash scripts
[ -f color.sh ] && . color.sh

LANG=en_US.utf8

# Configuration variables
POLLING_INTERVAL=10
COMPRESS_LOG_FILE=false  # FIXME is it supported by my version of the UI? Yes

helperfile="logs/keyfreqraw.txt" # temporary helper file

mkdir -p logs
# First message to inform that the script was started correctly
echo -e "${green}$0 has been started successfully.${reset}"
nb_virtual_kb=$(xinput | grep 'slave  keyboard' | grep -o 'id=[0-9]*' | cut -d= -f2 | wc -l)
nb_real_kb=$(xinput | grep 'keyboard.*slave.*keyboard' | grep -v 'Virtual' | wc -l)
echo -e "  - It will ${red}constantly${reset} record the keyboard(s) of your laptop (currently there seems to be ${black}${nb_virtual_kb}${reset} virtual keyboard(s) and ${black}${nb_real_kb}${reset} real keyboard(s))."
echo -e "  - It will work in time window of ${red}$POLLING_INTERVAL${reset} seconds."
[ $COMPRESS_LOG_FILE = true ] && echo -e "  - It will regularly compress the log files."
echo

# Start the main loop
while true
do
  showkey > $helperfile &
  PID=$!

  # work in windows of 9 seconds
  sleep 9
  kill $PID

  # count number of key release events
  num=$(cat $helperfile | grep release | wc -l)

  # append unix time stamp and the number into file
  logfile="logs/keyfreq_$(python rewind7am.py).txt"
  echo "$(date +%s) $num"  >> $logfile
  echo "logged key frequency: $(date) $num release events detected into $logfile"

done
