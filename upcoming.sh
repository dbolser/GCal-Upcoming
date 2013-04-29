#!/usr/local/bin/bash

# BASH script suitable for calling from CRON. Fe' details, see
# https://github.com/dbolser/GCal-Upcoming

pwd=/homes/dbolser/GCal-Upcoming

source $pwd/local-lib.sh

$pwd/upcoming_gcal.plx
