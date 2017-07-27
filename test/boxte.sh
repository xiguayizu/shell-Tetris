#!/bin/bash

# position verible
marginLeft=8  
marginTop=6
((mapLeft=marginLeft+2))   # 
((mapTop=$marginTop+1))     #
mapWidth=10
mapHeight=15

# 7 - 19
# 8->coordinate   2->posotion
box0_0=(0 0 0 1 1 0 1 1 0 4)

box1_0=(0 1 1 1 2 1 3 1 0 3)
box1_1=(1 0 1 1 1 2 1 3 -1 3)

box2_0=(0 0 1 0 1 1 2 1 0 4)
box2_1=(0 1 0 1 1 1 2 1 0 4)

box3_0=(0 1 1 0 1 1 2 0 0 4)
box3_0=(0 0 0 1 1 1 1 2 0 4)

box4_0=(0 2 1 0 1 1 1 2 0 3)
box4_1=(0 1 1 1 2 1 2 2 0 3)
box4_2=(1 0 1 1 1 2 2 0 -1 3)
box4_3=(0 0 0 1 1 1 2 1 0 4)

box5_0=(0 0 1 0 1 1 1 2 0 3)
box5_1=(0 1 0 2 1 1 2 1 0 3)
box5_2=(1 0 1 1 1 2 2 2 -1 3)
box5_3=(0 1 1 1 2 0 2 1 0 4)

box6_0=(0 1 1 0 1 1 1 2 0 3)
box6_1=(0 1 1 1 1 2 2 1 0 3)
box6_2=(1 0 1 1 1 2 2 1 -1 3)
box6_3=(0 1 1 0 1 1 2 1 0 4)

DrawBorder()
{
    clear
    local i y x1 x2
    echo -ne "\033[1m\033[32m\033[42m"
    ((x1 = marginLeft + 1))
    ((x2 = x1 + 2 + mapWidth *2))
    for((i=0 ; i<mapHeight ; i++))
    do
        ((y = i + marginTop + 2))
        echo -ne "\033[${y};${x1}H||"
        echo -ne "\033[${y};${x2}H||"
    done

    ((marginBottom = marginTop + mapHeight + 2))
    for((i=0 ; i<mapWidth + 2 ; i++))
    do
        ((x = i * 2 +marginLeft + 1))
        echo -ne "\033[${mapTop};${x}H=="
        echo -ne "\033[${marginBottom};${x}H=="
    done
}

DrawBox()
{
    local i x y xPos yPos
    yPos=${box0_0[8]}
    xPos=${box0_0[9]}
    echo -ne "\033[1m\033[35m\033[45m"
    for(( i=0 ; i<8 ; i+=2 ))
    do
        (( y = mapTop + 1 + ${box0_0[$i]} + yPos ))
        (( x = mapLeft + 1 + 2 * (${box0_0[$i + 1]}) + xPos ))
        echo -ne "\033[${y};${x}H[]"
    done
    echo -ne "\033[0m"
}

clear
DrawBorder
DrawBox

while :
do
    sleep 1
done


