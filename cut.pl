#!/usr/bin/env perl

use 5.016;
use warnings;
use Getopt::Std;

my %opts;
getopts('f:d:s', \%opts);

my @a = <STDIN>;
chop($_) for @a;

my $delim = "\t";
if (defined $opts{'d'}) {
    $delim = $opts{'d'};
}
my @fields;
if (defined $opts{'f'}) {
    @fields = split /,/, $opts{'f'};
}


for my $str (@a) {
    my @arr = split /$delim/, $str;
    if (defined $opts{'f'} and defined $opts{'s'}) {
        if ($arr[0] ne $str) {
            my @tmp;
            push @tmp, $arr[$_-1] for @fields;
            say join " ", @tmp;

        }
    } elsif (defined $opts{'f'}) {
        if ($arr[0] eq $str) {say $str;}
        else {
            my @tmp;
            push @tmp, $arr[$_-1] for @fields;
            say join " ", @tmp;
        }    
    } elsif (defined $opts{'s'}) {
        if ($arr[0] ne $str) {
            say join " ", @arr;
        }
    } else {
        say join " ", @arr;    
    }    
}
