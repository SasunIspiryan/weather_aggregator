#!/bin/bash

find . -type f -printf '%k KB %p\n' | sort -nr | head -n 1

echo "Homework1 done."
