#!/bin/bash

# This script is used to get the static fan speed of the Dell PowerEdge server using iDRAC IPMI
# Tested on Dell PowerEdge R410
# Usage: ./idrac-fan.sh <IP> <fan_1> <fan_2> <fan_3> <fan_4> <fan_5> <fan_6> [username] [password]

# Print out help message if the number of arguments is less than 7
# The message should notify that fan speed values are 0-100 as a percentage of maximum fan speed
if [ $# -lt 7 ]; then
	echo "Usage: $0 <IP> <fan_1> <fan_2> <fan_3> <fan_4> <fan_5> <fan_6> [username] [password]"
	echo "Fan speed values are 0-100 as a percentage of maximum fan speed"
	exit 1
fi

IP=$1
# If $IDRAC_USER is not set, take $8 as username
# if $8 is still not set, print out error
if [ -z "$IDRAC_USER" ]; then
	if [ -n "$8" ]; then
		USER=$8
	else
		echo "Error: username is required"
		exit 1
	fi
else
	USER=$IDRAC_USER
fi
# Same with $IDRAC_USER
if [ -z "$IDRAC_PASS" ]; then
	if [ -n "$9" ]; then
		PASS=$9
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

# Iterate from $2 to $7 to check if the fan speed is valid
for i in {2..7}; do
	# If the fan speed is not a number or not in range 0-100, print out error
	if ! [[ ${!i} =~ ^[0-9]+$ ]] || [ ${!i} -lt 0 ] || [ ${!i} -gt 100 ]; then
		echo "Error: ${!i} is not a valid fan speed"
		exit 1
	fi
done
# Convert the fan speed values to hex with HH format, store them in an array
# The fan speed values are 0-100 as a percentage of maximum fan speed
for i in {2..7}; do
	FAN[$i]=$(printf "%02x" ${!i})
done
