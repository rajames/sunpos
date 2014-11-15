#!/bin/sh

# base URL
URL="http://www.nrel.gov/midc/apps/spa.pl\?"

# when only coordinates are given. The current unix time and date is used.
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

    # see http://www.nrel.gov/midc/solpos/spa.html
    # for more details on the parameters


    # issue command
    curl ${URL}syear\=${S_YEAR}\&smonth\=${S_MONTH}\&sday\=${S_DAY}\&eyear\=${E_YEAR}\&emonth\=${E_MONTH}\&eday\=${E_DAY}\&step\=10\&stepunit\=1\&latitude\=${LAT}\&longitude\=${LONG}\&timezone\=0\&elev\=0\&press\=835\&temp\=10\&dut1\=0.0\&deltat\=64.797\&azmrot\=180\&slope\=0\&refract\=0.5667\&field\=0\&field\=1\&zip\=0

}

# Use coordinates and start and end date.
_run_coordinates_and_date()
{
    LAT=${1} # latitude
    LONG=${2} # longitude

    #parse start date
    IFS='/' read -ra S_DATE <<< "${3}"

    S_DAY="${S_DATE[0]}" # start date
    S_MONTH="${S_DATE[1]}"
    S_YEAR="${S_DATE[2]}"

    # parse end date
    IFS='/' read -ra E_DATE <<< "${4}"

    E_DAY="${E_DATE[0]}" # end date
    E_MONTH="${E_DATE[1]}"
    E_YEAR="${E_DATE[2]}"

    echo Received lat:$LAT long:$LONG  from:"${S_DAY}"/$S_MONTH/$S_YEAR to:$E_DAY/$E_MONTH/$E_YEAR

    # issue command
    curl ${URL}syear\=${S_YEAR}\&smonth\=${S_MONTH}\&sday\=${S_DAY}\&eyear\=${E_YEAR}\&emonth\=${E_MONTH}\&eday\=${E_DAY}\&step\=10\&stepunit\=1\&latitude\=${LAT}\&longitude\=${LONG}\&timezone\=0\&elev\=0\&press\=835\&temp\=10\&dut1\=0.0\&deltat\=64.797\&azmrot\=180\&slope\=0\&refract\=0.5667\&field\=0\&field\=1\&zip\=0

}


if [ $# -eq 2 ]; then
    _run_only_coordinates "$1" "$2"
elif [ $# -eq 4 ]; then
    _run_coordinates_and_date "$@"
else
    echo $0: invalid arguments
    echo Usage: $0 \<latitude\> \<longitude\> \[ \<start_date\> \<end_date\> \]
    echo e.g.
    echo Ex.1: $0 39.743 -105.178
    echo Ex.2: $0 39.743 -105.178 14/11/2014 16/11/2014
    echo ""
    #echo $@
    exit
fi
