#!/usr/bin/env perl

# Query Google callendar and produce a list of upcoming events. Fe'
# details, see https://github.com/dbolser/GCal-Upcoming

use strict;
use warnings;

use Data::Dumper;

use DateTime;
use POSIX qw/ceil/;

use Net::Google::Calendar;



## Used for querying calendar for future events
my $now = DateTime->now;

## Sad, but we have to get into it to print times correctly
our $TZ = DateTime::TimeZone->new( name => 'local' );

## See https://developers.google.com/google-apps/calendar/v2/developers_guide_protocol#AuthMagicCookie
my $private_url =
    'http://www.google.com/calendar/feeds/me%40gmail.com/private-sekrett/full';



## Connect to the calendar
my $cal = Net::Google::Calendar->
    new( url => $private_url );

## QUERY OPTIONS
my %query_opts = (
    'start-min' => $now,
    'max-results' => 10_000,
    );

my @events = $cal->
    get_events( %query_opts );
warn  "got ", scalar @events, " events\n";
print "got ", scalar @events, " events\n\n";



## Process @events into @events_list
my @events_list;

for ( sort start @events ) {
    print $_->title, "\n";
    #print $_->content->body."\n*****\n\n";
    
    my ($start, $end, $all_day_flag) = $_->when;
    
    ## This will happen for repeating events in the past (AFAICT).
    die "why no date/time for event\n"
        if !defined $start;
    
    ## Hopefully date logic is internally consistent (re. TZ)
    
    ## Below we don't use simple subtraction because the resulting
    ## DateTime::Duration object isn't easily convertable into days.
    
    ## This is still ugly...
    #my $remain = $start->delta_days($now);
    #my $remain_days = $remain->in_units('days');
    
    ## I understand this better === sleeps remaining ;-)
    my $remain = $start->epoch - $now->epoch;
    my $remain_days = ceil( $remain/60/60/24 );
    
    ## Set current time zone for printing...
    $start->set_time_zone( $TZ );
    
    ## Format the start date / time
    my $start_string = $start->strftime("%a %d %b %Y");
    
    if($all_day_flag){
        $start_string .= ", all day.";
    }
    else{
        $start_string .= $start->strftime(", %I:%M %p");
    }
    
    print "$start_string\n";
    print "WARNING $remain_days days remaining!\n";
    print $_->html_url, "\n";
    print "\n";
}

warn "DONE\n";


## Note, $event->when is sometimes undef! This will happen for
## repeating events in the past (AFAICT).
sub start {
    my ($start_a, $end_a, $all_day_flag_a) = $a->when;
    my ($start_b, $end_b, $all_day_flag_b) = $b->when;
    $start_a <=> $start_b;
}
