#!/usr/local/bin/bash

# BASH script suitable for calling from CRON. Fe' details, see
# https://github.com/dbolser/GCal-Upcoming

pwd=/homes/dbolser/GCal-Upcoming

source $pwd/local-lib.sh

mutt \
    dbolser@ebi.ac.uk \
    -s Upcoming-$(date --iso) \
    < <( $pwd/upcoming_gcal.plx )
