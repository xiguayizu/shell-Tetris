#!/bin/bash

DrawBorder()
{
	local i y x1 x2

	echo -ne "\033[1m\033[32m[033[42m"

	((x1 = marginLeft +1))
	((x2 = mapWidth *2))
	for((i=0;i<mapHeight;i++))
	do
		((y = i + marginTop + 2))
		echo -ne "\033[${y};${x}H||"
		echo -ne "\033[${y};${x2}H||"
	done
	((x1=marginTop + mapHeight + 2))
	
	for((i=0;i<mapWidth+2;i++))
	do
		((y=i*2+marginLeft+1))
		echo -ne "\033{"
	done


}








# \033[1m					 set a high measure
# \033[30m ~~ \033[37m    	 set foreground color
# \033[40m ~~ \033[47m 		 set background color

# 033[32m  ->  green
# 033[42m  ->  green

# echo -> (1,1) 
# echo -ne "\033[1;1Hths is test" 


