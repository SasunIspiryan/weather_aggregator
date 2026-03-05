#!/bin/bash
#
#
#
echo SYSTEM_STATS="System Check:Root Disk Available is $(free -m | awk '/^Mem:/{print $7}')"

