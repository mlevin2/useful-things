#!/usr/bin/env bash

#set -x

EXPECTED_ARGS=1
E_BADARGS=5
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` {name of process to kill}"
  exit $E_BADARGS
fi

pgrep -fiq "$1"
if [ $? -eq 0 ]; then
  echo "$1 was found. Attempting to kill."
  pkill -fi "$1"
  sleep 5
  pgrep -fiq "$1"
  if [ $? -eq 0 ]; then
    echo "$1 is still running. Attempting to kill."
    pkill -9 -fi "$1"
    sleep 5
    pgrep -fiq "$1"
    if [ $? -eq 0 ]; then
      echo "$1 is still running. Attempting to kill."
      sudo pkill -9 -fi "$1"
      pgrep -fiq "$1"
      if [ $? -eq 1 ]; then
        echo "$1 has been killed."
      else
        echo "$1 could not be killed."
      fi
    else
      echo "$1 has been killed."
    fi
  else
    echo "$1 has been killed."
  fi
else
  echo "$1 was not found."
fi
