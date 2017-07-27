#!/bin/bash

GetKey()
{
	aKey=(0 0 0)
	cESC=`echo -ne "\033"`  # esc   -n {don't newline}   -e {enable interpretation of backslash escapes}
	cSpace=`echo -ne "\040"`  # space

	while true
	do
		read -s -n 1 key   # -s {don't show}  -n {n chars}
		# echo $key
		# echo "xxx"


		aKey[0]=${aKey[1]}
		aKey[1]=${aKey[2]}
		aKey[2]=$key  # double esc

		if [[ $key == $cESC && ${aKey[1]} == $cESC ]]  # double esc
			then
			MyExit
		elif [[ ${aKey[0]} == $cESC && ${aKey[1]} == '[' ]]
			then
			if [[ $key == "A" ]];  then echo UP
			elif [[ $key == "B" ]]; then echo DOWN
			elif [[ $key == "C" ]]; then echo RIGHT
			elif [[ $key == "D" ]]; then echo LEFT
			fi
		fi

	done
}

GetKey


# :16,30s/^#//

