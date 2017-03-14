#!/bin/bash

GREP=`which grep`
HEAD=`which head`
LS=`which ls`
SCP=`which scp`
SSH=`which ssh`
SORT=`which sort`
RM=`which rm`
UNIQ=`which uniq`
XARGS=`which xargs`

LOCAL_PATH="$1"
FILEMASK="$2"
NUM_OF_LAST_FILES_REMAINING="$3"

### DO NOT EDIT BELOW THIS LINE ###

function print_usage() {
  echo "Usage: "
    echo "$0 [path] [filemask] [num_of_last_files_remaining]"
  }

function print_debug() {
  echo "File mask: ${FILEMASK}"
  echo "Local path: ${LOCAL_PATH}"
  echo "Number of last files remaining: ${NUM_OF_LAST_FILES_REMAINING}"
}

if [ "x${NUM_OF_LAST_FILES_REMAINING}" == "x" ]; then
  print_usage
else
  if [ "${DEBUG}" == "true" ]; then
    print_debug
  fi

  cd ${LOCAL_PATH}

  # Leave only n latest files
  (${LS} -1t ${FILEMASK} | ${HEAD} -n ${NUM_OF_LAST_FILES_REMAINING};${LS} ${FILEMASK}) | ${SORT} | ${UNIQ} -u | ${XARGS} ${RM}

fi
