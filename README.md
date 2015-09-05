# bash-archive-weekly


## Usage  
    $ ./archive_prev_week.sh <source_path> <save_path> [filename_prefix]

- Both paths need to be absolute


## Notes

- The filename will be in the following date format: `2015W35_2015-08-24_-_2015-08-30.tar.gz`
- This script archives the previous week of year [source: Week Numbers](http://www.epochconverter.com/date-and-time/weeknumbers-by-year.php)
- For example, during any day of week 23, this script will **always** archive week 22 data
