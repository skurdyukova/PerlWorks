#!/usr/bin/env perl

use 5.016;
use warnings;
use Getopt::Std;

my %opts;
getopts('A:B:C:civFn', \%opts);
my $pattern = $ARGV[$#ARGV];

my @a = <STDIN>;
my @res;
my $count = 0;
chop($_) for @a;

for my $i (0..$#a) {
    my $m;
    my $str = $a[$i];
    if (defined $opts{'i'} and defined $opts{'F'} and defined $opts{'v'}) {
        $m = !(fc($str) eq fc($pattern)); 
    } elsif (defined $opts{'i'} and defined $opts{'F'}) {
        $m = fc($str) eq fc($pattern);
    } elsif (defined $opts{'F'} and defined $opts{'v'}) {
        $m = !($str eq $pattern);
    } elsif (defined $opts{'i'} and defined $opts{'v'}) {
        $m = !($str =~ /$pattern/i);
    }elsif (defined $opts{'i'}) {
        $m = $str =~ /$pattern/i;
    } elsif (defined $opts{'F'}) {
        $m = $str eq $pattern;
    } elsif (defined $opts{'v'}) {
        $m = !($str =~ /$pattern/);
    } else {
        $m = $str =~ /$pattern/;
    }
    if ($m) {
        if (defined $opts{'c'}) {
            ++$count;
        } elsif (defined $opts{'A'} and defined $opts{'B'} and defined $opts{'n'}) {
            for my $j ((($i - $opts{'B'}) >= 0 ? $i - $opts{'B'} : 0)..(($i + $opts{'A'}) <= $#a ? $i + $opts{'A'} : $#a)) {
                if ($j == $i) {push @res, $j.':'.$a[$j];}
                else {push @res, $j.'-'.$a[$j];}
            } 
        } elsif (defined $opts{'A'} and defined $opts{'B'}) {
            for my $j ((($i - $opts{'B'}) >= 0 ? $i - $opts{'B'} : 0)..(($i + $opts{'A'}) <= $#a ? $i + $opts{'A'} : $#a)) {
                push @res, $a[$j];
            }
        } elsif (defined $opts{'C'} and defined $opts{'n'}) {
            for my $j ((($i - $opts{'C'}) >= 0 ? $i - $opts{'C'} : 0)..(($i + $opts{'C'}) <= $#a ? $i + $opts{'C'} : $#a)) {
                if ($j == $i) {push @res, $j.':'.$a[$j];}
                else {push @res, $j.'-'.$a[$j];}
            }
        } elsif (defined $opts{'A'} and defined $opts{'n'}) {
            for my $j ($i..(($i + $opts{'A'}) <= $#a ? $i + $opts{'A'} : $#a)) {
                if ($j == $i) {push @res, $j.':'.$a[$j];}
                else {push @res, $j.'-'.$a[$j];}
            }
        } elsif (defined $opts{'B'} and defined $opts{'n'}) {
            for my $j ((($i - $opts{'B'}) >= 0 ? $i - $opts{'B'} : 0)..$i) {
                if ($j == $i) {push @res, $j.':'.$a[$j];}
                else {push @res, $j.'-'.$a[$j];}
            }
        } elsif (defined $opts{'C'}) {
            for my $j ((($i - $opts{'C'}) >= 0 ? $i - $opts{'C'} : 0)..(($i + $opts{'C'}) <= $#a ? $i + $opts{'C'} : $#a)) {
                push @res, $a[$j];
            }
        } elsif (defined $opts{'A'}) {
            for my $j ($i..(($i + $opts{'A'}) <= $#a ? $i + $opts{'A'} : $#a)) {
                push @res, $a[$j];
            }
        } elsif (defined $opts{'B'}) {
            for my $j ((($i - $opts{'B'}) >= 0 ? $i - $opts{'B'} : 0)..$i) {
                push @res, $a[$j];
            }
        } elsif (defined $opts{'n'}) {
            push @res, $i.':'.$a[$i];
        } else {
            push @res, $a[$i];
        }
    }
}

if (defined $opts{'c'}) {
    say $count;
} else {
    say join "\n", @res; 
}
