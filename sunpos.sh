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


# Use current UTC time and date if only coordinates are given.
_run_only_coordinates()
{

    LAT=${1} # latitude
    LONG=${2} # longitude
    echo Received lat: $LAT long:$LONG

    # start date to end date
    S_YEAR=$(date -u +%Y) # start date
    S_MONTH=$(date -u +%m)
    S_DAY=$(date -u +%d)

    E_YEAR=$S_YEAR # end date
    E_MONTH=$S_MONTH
    E_DAY=$S_DAY

    # build command string
    myCom="${URL}"
    myCom+=syear\=${S_YEAR}\&smonth\=${S_MONTH}\&sday\=${S_DAY}
    myCom+=\&eyear\=${E_YEAR}\&emonth\=${E_MONTH}\&eday\=${E_DAY}
    myCom+=\&step\=10\&stepunit\=1
    myCom+=\&latitude\=${LAT}\&longitude\=${LONG}
    myCom+=\&timezone\=0\&elev\=0\&press\=835\&temp\=10\&dut1\=0.0
    myCom+=\&deltat\=64.797\&azmrot\=180\&slope\=0\&refract\=0.5667
    myCom+=\&field\=0\&field\=1\&zip\=0

    # execute command
    curl $myCom

}

# Use coordinates and step size and unit.
_run_coordinates_and_steps()
{
    LAT=${1} # latitude
    LONG=${2} # longitude

    # start date to end date
    S_YEAR=$(date -u +%Y) # start date
    S_MONTH=$(date -u +%m)
    S_DAY=$(date -u +%d)

    E_YEAR=$S_YEAR # end date
    E_MONTH=$S_MONTH
    E_DAY=$S_DAY

    if [ $3 -gt 60 -o $3 -lt 1 ]; then
        echo $0: invalid arguments
        _display_help
        exit
    fi
    STEP_SIZE=${3}

    if [ $4 != 's' -a $4 != 'm' ]; then
        echo $0: invalid arguments
        _display_help
        exit
    elif [ $4 == 's' ]; then
        STEP_UNIT=0
    elif [ $4 == 'm' ]; then
        STEP_UNIT=1
    fi

    echo Received lat:$LAT long:$LONG  \
        from:"${S_DAY}"/$S_MONTH/$S_YEAR to:$E_DAY/$E_MONTH/$E_YEAR \
        step:${STEP_SIZE}${4}

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

}

# Use coordinates and start and end date,
# and step size and unit.
_run_coordinates_date_and_steps()
{
    LAT=${1} # latitude
    LONG=${2} # longitude

    if [ $3 -gt 60 -o $3 -lt 1 ]; then
        echo $0: invalid arguments
        _display_help
        exit
    fi
    STEP_SIZE=${3}

    if [ $4 != 's' -a $4 != 'm' ]; then
        echo $0: invalid arguments
        _display_help
        exit
    elif [ $4 == 's' ]; then
        STEP_UNIT=0
    elif [ $4 == 'm' ]; then
        STEP_UNIT=1
    fi

    # parse start date
    IFS='/' read -ra S_DATE <<< "${5}"

    S_DAY="${S_DATE[0]}" # start date
    S_MONTH="${S_DATE[1]}"
    S_YEAR="${S_DATE[2]}"

    # parse end date
    IFS='/' read -ra E_DATE <<< "${6}"

    E_DAY="${E_DATE[0]}" # end date
    E_MONTH="${E_DATE[1]}"
    E_YEAR="${E_DATE[2]}"

    echo Received lat:$LAT long:$LONG  \
        from:"${S_DAY}"/$S_MONTH/$S_YEAR to:$E_DAY/$E_MONTH/$E_YEAR \
        step:${STEP_SIZE}${4}

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

}

_display_help(){
    echo Usage: $0 latitude longitude \[start_date end_date\]
    echo
    echo Default start and end dates are the current \(UTC\) date.
    echo
    echo latitude
    echo -e '\t'is given with 3 decimals precision.
    echo
    echo longitude
    echo -e '\t'is given with 3 decimals precision.
    echo
    echo date
    echo -e '\t' date format dd/mm/yyyy.
    echo
    echo step size
    echo -e '\t' a numerical value, 1 to 60.
    echo
    echo step unit
    echo -e '\t' either \'s\' or \'m\'.
    echo -e '\t' s: seconds.
    echo -e '\t' m: minute.
    echo
    echo e.g. Input:
    echo
    echo -e '\t'Ex.1: $0 39.743 -105.178
    echo -e '\t'Ex.2: $0 39.743 -105.178 25 m
    echo -e '\t'Ex.2: $0 39.743 -105.178 25 m 14/11/2014 16/11/2014
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

if [ $# -eq 2 ]; then
    _run_only_coordinates "$@"
elif [ $# -eq 4 ]; then
    _run_coordinates_and_steps "$@"
elif [ $# -eq 6 ]; then
    _run_coordinates_date_and_steps "$@"
else
    echo $0: invalid arguments
    _display_help
    #echo $@
    exit
fi
