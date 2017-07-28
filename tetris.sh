#!/bin/bash

APP_NAME="${0##*[\\/]}"   # {./tetris.sh} => tetris.sh
APP_VERSION="1.0"


#15:00

#
iSumColor=7
cRed=1
cGreen=2
cYellow=3
cBlue=4
cFuchsia=5
cCyan=6
cWhite=7

#
marginLeft=3
marginTop=2
((mapLeft=marginLeft+2))
((mapTop=$marginTop+1))
mapWidth=10
mapHeight=15

cBorder=$cGreen
cScore=$cFuchsia
cScoreValue=$cCyan

sigRotate=25
sigLeft=26
sigRight=27
sigDown=28
sigAllDown=29
sigExit=30



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


iSumType=7
boxStyle=(1 2 2 2 4 4 4)

iScoreEachLevel=50  # level up request source
sig=0   # receive signal
iScore=0  # total source
iLevel=0  # speed level
boxNext=()     # the next  box
iboxNextColor=0  # the next box color
iboxNextType=0   #the next box type
iboxNextStyle=0   #the next box style

boxCur=()     # the current box position
iBoxCurColor=0    # the current box color 
iBoxCurType=0   # the current box type
iBoxCurStyle=0   # the current box style

boxCurX=-1   # current box position x
boxCurY=-1    # current box position y
map=()          # checkerboard chart

for ((i=0;i<mapHeight*mapWidth;i++))
do
    map[$i]=-1
done



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


# arg : 0>clear   1>draw current box
DrawCurBox()
{
    local i x y bErase sBox
    bErase=$1
    if (( bErase == 0 )) then
        sBox="\040\040"
    else 
        sBox="[]"
        # highter   fground  bground
        echo -ne "\033[1m\033[3${iBoxCurColor}m\033[4${iBoxCurColor}m"
    fi

    for (( i=0;i<8;i+=2 ))
    do
        ((y=mapTop+1+${boxCur[$i]} + boxCurY ))
        ((x = mapLeft + 1 + 2 * (boxCurX+${boxCur[ $i + 1 ]}) ))
        echo -ne "\033[${y};${x}H${sBox}"
    done
    echo -ne "\033[0m"
}

#BoxMove(y, x)
BoxMove(){
    #  25: 50
}

CreateBox()
{

    # ${#boxCur[@]} => { number of array elements }
    if(( ${#boxCur[@]} == 0 )); then
        # current Box is Null
        ((iBoxCurType = RANDOM % iSumType))
        ((iBoxCurStyle = RANDOM % ${boxStyle[$iBoxCurType]} ))
        ((iBoxCurType = RANDOM % $iSumColor + 1 ))
    else
        # current box is already exists,  then put next box to current box
        iBoxCurType=$iboxNextType
        iBoxCurStyle=$iboxNextStyle
        iBoxCurColor=$iboxNextColor
    fi

    # the current square array
    boxCur=(`eval 'echo ${box'$iBoxCurType'_'$iBoxCurStyle'[@]}'`)  # box0_0
    # initialize the block starting coordinates
    boxCurY=boxCur[8]
    boxCurX=boxCur[9]

    DrawCurBox 1  # draw current box
    if ! BoxMove $boxCurY $boxCurX then
        kill -$sigExit $PPID
        ShowExit
    fi

    PrepareNextBox



    # show "Source"  and  "Level"
    echo -ne "\033[1m"
    (( y = marginLeft + mapWidth * 2 + 7 ))
    ((x1 = marginTop + 10))
    echo -ne "\033[3${cScore}m\033[${x1};${y}HScore"
    ((x1 = marginTop + 11))
    echo -ne "\033[3${cScoreValue}m\033[${x1};${y}H${iScore}"
    ((x1 = marginTop + 13))
    echo -ne "\033[3${cScore}m\033[${x1};${y}HLevel"
    ((x1 = marginTop + 14))
    echo -ne "\033[3${cScoreValue}m\033[${x1};${y}H${iLevel}"
    echo -ne "\033[0m"
}

InitDraw()
{
    clear             #
    DrawBorder    #
    CreateBox      #
}

RunAsDisplayer()
{
    local sigThis
    InitDraw       ##### 

    # addevent function sigle
    trap "sig=$sigRotate;" $sigRotate
    trap "sig=$sigLeft;" $sigLeft
    trap "sig=$sigRight;" $sigRight
    trap "sig=$sigDown;" $sigDown
    trap "sig=$sigAllDown;" $sigAllDown
    trap "ShowExit;" $sigExit

    while :
    do
        for (( i = 0; i < 21 - iLevel; i++ )); do
            sleep 0.02
            sigThis=$sig 
            sig=0

            if (( sigThis == sigRotate )); then BoxRotate;
            elif (( sigThis e== sigLeft )); then BoxLeft;
            elif (( sigThis == sigRight )); then BoxRight;
            elif (( sigThis == sigDown )); then BoxDown;
            elif (( sigThis == sigAllDown )); then BoxAllDown;
            fi
        done

        BoxDown
    done

    # trap 
}

function RunAsKeyReceiver(){
    local pidDisplayer key aKey sig cESC sTTY

    pidDisplayer=$1
    aKey=(0 0 0)

    cESC=`echo -ne "\033"`
    cSpace=`echo -ne "\040"`

    # save tty attributes
    sTTY=`stty -g`

    # catch sig code
    trap "MyExit;" INT QUIT
    trap "MyExitNoSub;" $sigExit

    # hide cursor
    echo -ne "\033[?251"
    # echo -ne "\033[?25h"

    while :
    do
        read -s -n 1 key

        aKey[0]=${aKey[1]}
        aKey[1]=${aKey[2]}
        aKey[2]=$key
        sig=0

        if [[ $key == $cESC && ${aKey[1]} == $cESC ]]
        then
                MyExit
        elif [[ ${aKey[0]} == $cESC && ${aKey[1]} == '[' ]]
        then
            if [[ $key == "A" ]]; then sig=$sigRotate
            elif [[ $key == "B" ]];  then sig=$sigDown
            elif [[ $key == "D" ]]; then sig=$sigLeft
            elif [[ $key == "C" ]]; then sig=$sigRight
            fi
        elif [[ $key == "W" || $key == "w" ]]; then sig=$sigRotate
        elif [[ $key == "S" || $key == "s" ]]; then sig=$sigDown
        elif [[ $key == "A" || $key == "a" ]]; then sig=$sigLeft
        elif [[ $key == "D" || $key == "d" ]]; then sig=$sigRight
        elif [[ $key == "[]" ]]; then sig=$sigAllDown
        elif [[ $key == "Q" || $key == "q" ]];
        then
            MyExit
        fi

        if [[ $sig != 0 ]]
        then
            kill -$sig $pidDisplayer  # send sig
        fi
    done


}

MyExitNoSub()
{
    local y

    # revert tty attribute
    stty $sTTY
    ((y = marginTop + mapHeight + 4))

    # show curos
    echo -e "\033[?25h\033[${y};0H"
    exit
}
MyExit()
{
    echo -ne "\033[?251"
    echo "sigExit"$sigExit
    echo "pid"$pidDisplayer
    kill -$sigExit $pidDisplayer
    
    exit

    MyExitNoSub
}


# #---------------------------------------
if [[ "$1" == "--version" ]]; then
    echo "$APP_NAME $APP_VERSION"
elif [[ "$1" == "--show" ]]; then
    # run show function
    RunAsDisplayer
else 
    bash $0 --show&   # as --show run again
    RunAsKeyReceiver $!   # 
fi





#  17:11



