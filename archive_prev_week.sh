#!/bin/bash

# This script has to finish within 24hrs of the prev week ending
#   This is because the offset will max out at 1 day
#   If it is run any later you will miss days in the archive

# Handle args
if [ "$#" -ne 2 ]; then
    echo "Pass 2 args: <source> <save_location>"
    exit
fi

source_location=$1
save_location=$2

start_year=`date --date="7 days ago" +%Y`
start_month=`date --date="7 days ago" +%m`
start_day=`date --date="7 days ago" +%d`
end_year=`date --date="1 day ago" +%Y`
end_month=`date --date="1 day ago" +%m`
end_day=`date --date="1 day ago" +%d`
week_of_year=`date --date="1 day ago" +%V`

week=${end_year}W${week_of_year}
start_day=${start_year}-${start_month}-${start_day}
end_day=${end_year}-${end_month}-${end_day}

archive_name="${save_location}_${week}_${start_day}_-_${end_day}.tar.gz"

current_min=`date +%M`
current_hour=`date +%H`

time_offset=`echo $(( (60*$current_hour)+$current_min ))`
files_newer=`echo $(( (60*24*7)+$time_offset ))`
files_older=$time_offset

cd $source_location && find . -type f \
    -mmin -$files_newer \
    -mmin +$files_older | \
    sed 's/.*/"&"/' | \
    xargs tar -zcvf $archive_name 

