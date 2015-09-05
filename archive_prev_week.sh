#!/bin/bash

# Handle args
if [ "$#" -lt 2 ]; then
    echo ""
    echo "Error: Pass 2-3 args: <source_path> <save_path> [filename_prefix]"
    echo ""
    exit
fi

source_location=$1
save_location=$2
filename_prefix=$3

current_min=`date +%-M`  # %-M removes any leading 0 that %M would have returned
current_hour=`date +%k`  # 24hr time 0-23
current_day_of_week=`date +%u`  # 1-7 starting on Monday

current_day_offset=$(( (60 * $current_hour) + $current_min ))  # Brings back to midnight of this day
previous_days_offset=$(( ($current_day_of_week - 1) * 1440 ))  # 1440 mins in each day
total_offset=$(( $previous_days_offset + $current_day_offset ))  

files_newer=$(( (60*24*7) + $total_offset ))
files_older=$(( $total_offset + 1 ))  # +1 is so we get 11:59 and not 00:00

start_year=`date --date="$files_newer minutes ago" +%Y`
start_month=`date --date="$files_newer minutes ago" +%m`
start_day=`date --date="$files_newer minutes ago" +%d`
end_year=`date --date="$files_older minutes ago" +%Y`
end_month=`date --date="$files_older minutes ago" +%m`
end_day=`date --date="$files_older minutes ago" +%d`
previous_week_of_year=$(( `date +%V` - 1 ))  # Gets previous week number

week="${end_year}W${previous_week_of_year}"
start_day="${start_year}-${start_month}-${start_day}"
end_day="${end_year}-${end_month}-${end_day}"

archive_name="${filename_prefix}${week}_${start_day}_-_${end_day}.tar.gz"

cd $source_location && find . -type f \
    -mmin -$files_newer \
    -mmin +$files_older | \
    sed 's/.*/"&"/' | \
    xargs tar -zcvf $archive_name 
