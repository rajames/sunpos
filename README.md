sunpos
======

A simple shell script to get the sun's position based on [NREL's](http://www.nrel.gov/midc/spa/) sun position algorithm (spa).

## Usage 
    ./sunpos.sh <lat> <long> [ [ <step_size> <step_unit> ] <start_date> <end_date> ] ``

### Example

    ./sunpos.sh 39.743 -105.178
    ./sunpos.sh 39.743 -105.178 25 m
    ./sunpos.sh 39.743 -105.178 25 m 14/11/2014 16/11/2014

	
