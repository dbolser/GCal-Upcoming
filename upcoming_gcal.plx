#!/usr/bin/perl

use strict;
use warnings;

use Net::Google::Calendar;
use DateTime;

## See https://developers.google.com/google-apps/calendar/v2/developers_guide_protocol#AuthMagicCookie
my $private_url = 'http://www.google.com/calendar/feeds/me%40gmail.com/private-sekrett/full';

my $now = DateTime->now;

my $cal = Net::Google::Calendar->
    new( url => $private_url );

## QUERY OPTIONS
my %query_opts = (
    'start-min' => $now,
    'max-results' => 10_000,
    );

my @events = $cal->
    get_events( %query_opts );
print "got ", scalar @events, " events\n\n";

for (@events) {
    print $_->title, "\n";
    #print $_->content->body."\n*****\n\n";
    
    ## Get event time
    my ($start, $end, $all_day_flag) = $_->when;
    
    if(defined $start){
        #print "$start\n";
        print "All day\n" if $all_day_flag;
        
        ## Hopefully date logic is internally consistent...
        my $until = $start - $now;
        print "WARNING ", $until->in_units('days'), " days remaining!\n";
    }
    else{
        ## This will happen for repeating events in the past (AFAICT)
        die "why no time for eveent?\n";
    }
    
    print $_->html_url, "\n";
    
    print "\n";
}
