#!/bin/bash

echo INT 

trap 'echo "INTREEUPTED!"; exit' INT 
sleep 100



