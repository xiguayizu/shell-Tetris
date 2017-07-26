#!/bin/bash



for((i=0;i<50;i++))
do
	echo -ne "\033[${i}mHecho -ne \"[${i}m\" \r\n"
done


