#!/bin/sh
# file: sunpos.sh
# author: Raul James
#
# This simple script
# accesses http://www.nrel.gov/midc/solpos/spa.html
# and gets the sun's zenith and azimuth angles
# referenced to the South and
# outputs it as ASCII text.
#
# Latitude, longitude, start date and end date, and
# step size parameters are exposed to user.
# See http://www.nrel.gov/midc/solpos/spa.html
# for more details on available parameters
#############################################################################

# base URL
URL="http://www.nrel.gov/midc/apps/spa.pl\?"

_display_help(){
    echo Usage: $0 \[-sS steps\] \[-fF date\] \[-tT date\] \[-v\] latitude longitude
    echo
    echo OPTIONS
    echo -e '\t'-s'\t'steps in minutes. 1 to 60.
    echo
    echo -e '\t'-S'\t'steps in seconds. 1 to 60.
    echo
    echo -e '\t'-f'\t'start date in dd/mm/yyyy format.
    echo
    echo -e '\t'-F'\t'start date in mm/dd/yyyy format.
    echo
    echo -e '\t'-t'\t'end date in dd/mm/yyyy format.
    echo
    echo -e '\t'-T'\t'end date in mm/dd/yyyy format.
    echo
    echo -e '\t'-v'\t'verbose. Prints received arguments.
    echo
    echo ARGUMENTS
    echo -e '\t'latitude
    echo -e '\t\t'is given in up to 3 decimals precision. -90 to 90.
    echo
    echo -e '\t'longitude
    echo -e '\t\t'is given in up to 3 decimals precision. -180 to 180.
    echo
    echo Defaults
    echo -e '\t'start and end dates are by default the current \(UTC\) date.
    echo
    echo -e '\t'steps is by default 10 min.
    echo
    echo e.g. Input:
    echo
    echo -e '\t'Ex.1: $0 39.743 -105.178
    echo -e '\t'Ex.2: $0 -s 25 39.743 -105.178
    echo -e '\t'Ex.2: $0 -S 50 -39.743 -105.178
    echo -e '\t'Ex.2: $0 -s 25 -f 14/11/2014 -t 16/11/2014 39.743 -105.178
    echo -e '\t'Ex.2: $0 -s 25 -F 11/14/2014 -T 11/16/2014 39.743 -105.178
    echo
    echo e.g Output:
    echo
    echo -e '\t' Date,Time,Topocentric zenith angle,Top. azimuth angle \(eastward from N\)
    echo -e '\t' 11/14/2014,0:00:00,93.234296,248.983741
    echo -e '\t' 11/14/2014,0:10:00,95.038832,250.532635
    echo -e '\t' 11/14/2014,0:20:00,96.860576,252.065377
    echo
    echo NOTE:
    echo -e '\t' the output date format: mm/dd/yyyy
    echo

}


# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
verbose=0

# start date to end date
S_YEAR=$(date -u +%Y) # start date
S_MONTH=$(date -u +%m)
S_DAY=$(date -u +%d)

E_YEAR=$S_YEAR # end date
E_MONTH=$S_MONTH
E_DAY=$S_DAY

# default step size is 10 [ 1 <-> 60 ]
STEP_SIZE=10
# default step unit is in minutes [0:sec, 1:min]
STEP_UNIT=1

while getopts ":h?vs:S:f:F:t:T:123456789" opt; do
    case "$opt" in
    h)
        _display_help
        exit 0
        ;;
    v)  verbose=1
        ;;
    s)  STEP_SIZE=$OPTARG
        ;;
    S)  STEP_SIZE=$OPTARG
        STEP_UNIT=0
        ;;
    f)
        # parse start date
        # format: dd/mm/yyyy
        IFS='/' read -ra S_DATE <<< "${OPTARG}"
        S_DAY="${S_DATE[0]}"
        S_MONTH="${S_DATE[1]}"
        S_YEAR="${S_DATE[2]}"
        ;;
    F)
        # parse start date
        # format: mm/dd/yyyy
        IFS='/' read -ra S_DATE <<< "${OPTARG}"
        S_DAY="${S_DATE[1]}"
        S_MONTH="${S_DATE[0]}"
        S_YEAR="${S_DATE[2]}"
        ;;
    t)
        # parse end date
        # format: dd/mm/yyyy
        IFS='/' read -ra E_DATE <<< "${OPTARG}"
        E_DAY="${E_DATE[0]}"
        E_MONTH="${E_DATE[1]}"
        E_YEAR="${E_DATE[2]}"
        ;;
    T)
        # parse end date
        # format: mm/dd/yyyy
        IFS='/' read -ra E_DATE <<< "${OPTARG}"
        E_DAY="${E_DATE[1]}"
        E_MONTH="${E_DATE[0]}"
        E_YEAR="${E_DATE[2]}"
        ;;
    \?)
        echo "$0: Invalid option: -${OPTARG}" >&2
        echo "Try '-h' for help."
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        echo "Try '-h' for help."
        exit 1
        ;;
    *) # otherwise break
        break
        ;;
    esac
done

shift $((OPTIND-1))

if [ $# -eq 2 ]; then
    LAT=${1}
    LONG=${2}
else
    echo $0: not enough arguments
    echo "Try '-h' for help."
    exit 1
fi

if [ $verbose -eq 1 ]; then
echo -e "\
\nSTEP_SIZE: $STEP_SIZE\
\nSTEP_UNIT: $STEP_UNIT\
\nfrom: $S_DAY/$S_MONTH/$S_YEAR\
\nto: $E_DAY/$E_MONTH/$E_YEAR\
\nLAT: $LAT\
\nLONG: $LONG\
"
fi

# build command string
myCom="${URL}"
myCom+=syear\=${S_YEAR}\&smonth\=${S_MONTH}\&sday\=${S_DAY}
myCom+=\&eyear\=${E_YEAR}\&emonth\=${E_MONTH}\&eday\=${E_DAY}
myCom+=\&step\=${STEP_SIZE}\&stepunit\=${STEP_UNIT}
myCom+=\&latitude\=${LAT}\&longitude\=${LONG}
myCom+=\&timezone\=0\&elev\=0\&press\=835\&temp\=10\&dut1\=0.0
myCom+=\&deltat\=64.797\&azmrot\=180\&slope\=0\&refract\=0.5667
myCom+=\&field\=0\&field\=1\&zip\=0

# execute command
curl $myCom
