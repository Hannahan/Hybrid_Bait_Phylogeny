#!/bin/bash
file=$1
if [ -e "$file" ]; then
    echo $1 "File exists"
else 
    echo $1 "File does not exist"
fi 
