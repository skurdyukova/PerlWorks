#!/usr/bin/env perl

use 5.016;
use warnings;
sub clone;
use Data::Dumper;
sub clone {
    my $what = shift; 
    if (my $ref = ref $what) {
        if ($ref eq 'ARRAY') {
            my @arr;
            while (my ($i, $v) = each @$what) {
                $arr[$i] = clone($v);
            }
            return \@arr;
        }
        elsif ($ref eq 'HASH') {
            my %hsh;
            while (my ($k,$v) = each %$what) {
                $hsh{$k} = clone($v);
            }
            return \%hsh;
        }
        elsif ($ref eq 'SCALAR') {
           my $tmp = $$what;
           return \$tmp;
        }
        else { die "unsupported: $ref"; }
    }
    else {
        my $tmp = $what;
        return $tmp;
    }
}


my $a = 1;
my @arr = (\$a, 2, 3, 4);
my %hash = (key1 => 1, key2 => 2, key3 => 3, key4 => 4);
my @AoA = (
    [ "fred", "barney", "pebbles", "bambam", "dino", ],
    [ "george", "jane", "elroy", "judy", ],
    [ "homer", "bart", "marge", "maggie", ],
    );

my %hardhash = (
    sv => "string",
    av => [ qw(some elements) ], # ARRAY REF
    hv => {
        nested => "value",
        key => [ 1,2,undef ],
    },
);

#print Dumper \@AoA;
#say clone($a);
#say clone(\$a);
#my $varr = clone(\@arr);
#say join " ", @$varr;
#say join " ", clone(\%hash);
#say Dumper (clone(\@AoA));
#say Dumper clone(\@arr);
say Dumper \%hardhash;
say Dumper clone(\%hardhash);
