####################################
# Read user input and print it
####################################
#! /bin/bash
read -p "Enter mission name:" mission_name    # -p prints a message 
echo $mission_name

################################################
# unzip every file in the fodler
################################################
# https://www.jamf.com/jamf-nation/discussions/25560/loop-through-files-bash-help
#! /bin/bash
FILES=*
for f in $FILES
do
  echo "Processing $f file..."
  # take action on each file. $f store current file name
  gzip -d $f
done




################################################################################################
# unzip every file in the fodler
################################################################################################
# https://linuxconfig.org/how-to-change-welcome-message-motd-on-ubuntu-18-04-server


## /etc/update-motd.d/50-landscape-sysinfo

#!/bin/sh
cores=$(grep -c ^processor /proc/cpuinfo 2>/dev/null)
[ "$cores" -eq "0" ] && cores=1
threshold="${cores:-1}.0"
if [ $(echo "`cut -f1 -d ' ' /proc/loadavg` < $threshold" | bc) -eq 1 ]; then
    echo
    echo -n "  System information as of "
    /bin/date
    echo
    /usr/bin/landscape-sysinfo
else
    echo
    echo " System information disabled due to load higher than $threshold"
fi



################################################################################################
# list all files in directory without extension
################################################################################################

#!/bin/bash
set -e

TARGET_FOLDER="."
TABLES_PATH="${TARGET_FOLDER}/tables/"


echo "Populating the tables"

for i in $(ls ${TARGET_FOLDER}/tables/*.csv)
  do
  table=$(basename $i .csv) # remove .csv extension
  echo $table
done


################################################################################################
# Bash log with time format
################################################################################################

#!/usr/bin/env bash
LOGFILE="/path/to/log.log"
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`

# Log file will looks like
2013-02-03 18:22:30 Say what you are doing



#####################################

for instance in master-1 master-2; do
  scp ca.crt ca.key kube-apiserver.key kube-apiserver.crt \
    service-account.key service-account.crt \
    etcd-server.key etcd-server.crt \
    ${instance}:~/
done



#############################
# One line for loop
############################

for i in {1..5}; do COMMAND-HERE; done
for((i=1;i<=10;i+=2)); do echo "Welcome $i times"; done
for i in *; do echo $i; done
for i in /etc/*.conf; do cp $i /backup; done




#############################
# One line for loop SCP
############################
for x in 0 1 2; do scp swimgw-install-bundle-20220119v1-6-1.zip core@10.44.1.1$x:~/; done




=============================================
= ENV var checker prior to start script
=============================================

# Sanity check - ensure all required vars are set
ERRORS=""
for required in CI_API_V4_URL API_TOKEN API_TOKEN2 API_TOKEN3; do
  var_val=$(eval echo "\$${required}")
  if [ -z "${var_val}" ]; then ERRORS="${ERRORS} ${required}"; fi
done

if [ -n "$ERRORS" ]; then
  echo "Error: one or more required environment vars missing:"
  for var in $ERRORS; do
    echo "* ${var}"
  done
  exit 1
fi


=============================================
# Create temporary file, and ensure it's cleaned up on exit
=============================================

secrets=$(mktemp -t secrets.XXXXXX)
trap 'rm "$secrets"' EXIT
echo "${CI_SECRET}" > "${secrets}" &&  source "${secrets}"
