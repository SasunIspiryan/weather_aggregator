#!/bin/bash

DIR_PATH=${1:-.}

if [ ! -d "$DIR_PATH" ]; then
    echo "Error: Directory not found at $DIR_PATH"
    exit 1
fi

echo "Scanning for the largest file in: $DIR_PATH"

find "$DIR_PATH" -type f -print0 | xargs -0 du -b | sort -nr | head -n 1 | awk '{$1=$1/1024; print $1 " KB " $2}'

echo "Homework1 full done."

