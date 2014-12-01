sunpos
======

A simple shell script to get the sun's position based on [NREL's](http://www.nrel.gov/midc/solpos/spa.html) sun position algorithm (spa).

## Usage
    ./sunpos.sh [-sS <step_size>] [-fF <start_date> ] [-tT <end_date> ] [-v] <lat> <long>

### Example

#### Input

    ./sunpos.sh 39.743 -105.178
    ./sunpos.sh -s 25 39.743 -105.178
    ./sunpos.sh -S 50 -39.743 -105.178
    ./sunpos.sh -s 25 -f 14/11/2014 -t 16/11/2014 39.743 -105.178
    ./sunpos.sh -s 25 -F 11/14/2014 -T 11/16/2014 39.743 -105.178

#### Output

    Date,Time,Topocentric zenith angle,Top. azimuth angle (eastward from N)
    11/14/2014,0:00:00,93.234296,248.983741
    11/14/2014,0:10:00,95.038832,250.532635
    11/14/2014,0:20:00,96.860576,252.065377
