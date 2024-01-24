#!/bin/bash

# This script is used to power on/off the Dell PowerEdge server using iDRAC IPMI
# Tested on Dell PowerEdge R410
# Usage: ./idrac-power.sh <IP> <on|off> [username] [password]

if [ $# -lt 2 ]; then
	echo "Usage: $0 <IP> <on|off> [username] [password]"
	exit 1
fi

IP=$1
# If $2 is either `on` or `off`, print out error
if [ "$2" != "on" ] && [ "$2" != "off" ]; then
	echo "Error: $2 is not a valid option"
	exit 1
fi
ACTION=$2
# If $IDRAC_USER is not set, take $3 as username
# if $3 is still not set, print out error
if [ -z "$IDRAC_USER" ]; then
	if [ -n "$3" ]; then
		USER=$3
	else
		echo "Error: username is required"
		exit 1
	fi
else
	USER=$IDRAC_USER
fi
# Same with $IDRAC_USER
if [ -z "$IDRAC_PASS" ]; then
	if [ -n "$4" ]; then
		PASS=$4
	else
		echo "Error: password is required"
		exit 1
	fi
else
	PASS=$IDRAC_PASS
fi

# Check if `ipmitool` is installed
if ! which ipmitool > /dev/null; then
	echo "Error: ipmitool is not installed"
	exit 1
fi

# Invoke `ipmitool` to power on/off the server
ipmitool -I lanplus -H $IP -U $USER -P $PASS power $ACTION

