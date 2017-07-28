#!/bin/bash


trap "_reload $1" 1
trap "echo 123; exit" 2
_f1(){
    echo $$
    while((1))
    do
        date
        sleep 0.5
    done
}

_f2(){
    echo $$
    while((1))
    do
        uptime
        sleep 0.5
    done
}

_reload(){
    [ $1 -eq 2 ]&&echo $$
}

case $1 in
    1)
        _f1;;
    2)
        _f2;;
esac




# kill -l
# ./trap.sh 1
# ./trap.sh 2
# ctrl + c




