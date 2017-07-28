#!/bin/bash

sigRotate=25
sigLeft=26
sigRight=27
sigDown=28
sigAllDown=29
sigExit=30

sTTY=`stty -g`

position=(0 0)
BoxRotate()
{
	((position[0]=${position[0]}-1))
}
BoxLeft()
{
	((position[1]=${position[1]}-1))
}
BoxRight()
{
	((position[1]=${position[1]}+1))
}
BoxDown()
{
	((position[0]=${position[0]}+1))
}

drawBox()
{
	clear 
	echo -ne "\033[${position[0]};${position[1]}H~"
}

RunAsDisplayer()
{	
    trap "sig=$sigRotate;" $sigRotate
    trap "sig=$sigLeft;" $sigLeft
    trap "sig=$sigRight;" $sigRight
    trap "sig=$sigDown;" $sigDown
    trap "ShowExit;" $sigExit

	while :
	    do
	        for (( i = 0; i < 21 - iLevel; i++ )); do
	            sleep 0.02
	            sigThis=$sig 
	            sig=0
	            # echo $sigThis;

	            if (( sigThis == sigRotate )); then BoxRotate;
	            elif (( sigThis == sigLeft )); then BoxLeft;
	            elif (( sigThis == sigRight )); then BoxRight;
	            elif (( sigThis == sigDown )); then BoxDown;
	            fi
	            # echo $position
	            drawBox
	        done
	done
}

RunAsKeyReceiver()
{
	local pidDisplayer key sig
	pidDisplayer=$1
	echo "pidDisplayer:"$pidDisplayer
	sig=0

	trap "kill $pidDisplayer; exit; stty $sTTY" INT

	while :  
	do
		read -s -n 1 key
		# echo $key
		if [[ $key == "A" ]]; then sig=$sigRotate
		elif [[ $key == "B" ]]; then sig=$sigDown
		elif [[ $key == "D" ]]; then sig=$sigLeft
		elif [[ $key == "C" ]]; then sig=$sigRight
		fi


		if [[ $sig != 0 ]]; then
			kill -$sig $pidDisplayer
		fi
	done


}




if [[ $1 == "--show" ]] 
	then
	RunAsDisplayer
else
	bash $0 --show&
	RunAsKeyReceiver $!
fi

