sunpos
======

A simple shell script to get the sun's position based on [NREL's](http://www.nrel.gov/midc/spa/) sun position algorithm (spa).

## Usage
    ./sunpos.sh <lat> <long> [ <step_size> <step_unit> [ <start_date> <end_date> ] ]

### Example

#### Input

    ./sunpos.sh 39.743 -105.178
    ./sunpos.sh 39.743 -105.178 25 m
    ./sunpos.sh 39.743 -105.178 25 m 14/11/2014 16/11/2014

#### Output

    Date,Time,Topocentric zenith angle,Top. azimuth angle (eastward from N)
    11/14/2014,0:00:00,93.234296,248.983741
    11/14/2014,0:10:00,95.038832,250.532635
    11/14/2014,0:20:00,96.860576,252.065377
