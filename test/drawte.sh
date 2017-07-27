#!/bin/bash

DrawBorder() 
{
	((marginLeft=2))

	((mapWidth=10))
	((mapHeight=15))

	((x1=marginLeft+1))
	((x2= x1 + 2 + mapWidth*2))

	clear
	echo -ne "\033[1m\033[32m\033[42m"

	for(( i=0;i<mapHeight;i++ ))
	do
		echo -ne "\033[${i};${x1}H||"
		echo -ne "\033[${i};${x2}H||"
	done

	((y1=marginTop+1))
	((y2=marginTop+mapHeight))
	for(( i=0;i<mapWidth*2+3;i++ ))
	do
		((x1 = i+marginLeft+1))
		echo -ne "\033[${y1};${x1}H="
		echo -ne "\033[${y2};${x1}H="
	done
}

DrawBorder

while :
do
	sleep 1
done

