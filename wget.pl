#!/usr/bin/env perl

use strict;
use warnings;
use 5.016;
use DDP;
use Getopt::Long;
use AnyEvent::Socket;
use AnyEvent::Handle;
use AnyEvent::HTTP;
use URI;
use URI::URL;
use JSON::XS;
use Web::Query;

our $JSON = JSON::XS->new->utf8;
$AnyEvent::HTTP::MAX_PER_HOST = 100;

my $q_nums;
my $r;
my $r_length;
my $relative;
my $s;
my $active = 0;

GetOptions("N=i" => \$q_nums, "r" => \$r, "l=i" => \$r_length, "L" => \$relative, "S" => \$s);

$r_length = 5 unless defined $r_length;
$q_nums = 3 unless defined $q_nums;

#say @ARGV;
my @urls = @ARGV;

my %url_length;
if ($r) {
    for my $i (@urls) {
        $url_length{$i} = $r_length;    
    }
}


my $cv = AE::cv;
$cv->begin;

my $i = 0;
my $request; $request = sub {
    my $cur = $i++;
    return if $cur > $#urls;
    $active++;
    $cv->begin;
    http_request GET => $urls[$cur], timeout => 1,
    sub {
        my ($body, $hdrs) = @_;
        if ($hdrs->{Status} == 200) {
            if ($s) {
                p $hdrs;    
            }    

            my $name = (split /\//, $urls[$cur])[-1];
            open(my $fh, ">", $name) or die "Cant open file: $!\n";
            print {$fh} $body;

            if ($hdrs->{"content-type"} =~ /text\/html/) {
                if ($r and $url_length{$urls[$cur]}) {
                    my @hrefs = wq($body)->find("a")->attr("href"); 
                    for my $v (@hrefs) {
                        if ($v =~ /^https?:/) {
                            if (!$relative) {
                                push(@urls, $v);
                                $url_length{$v} = $url_length{$urls[$cur]} - 1 unless defined $url_length{$v}; 
                            }
                        } else {
                            my $tmp = $urls[$cur]."/".$v;
                            push(@urls, $tmp);
                            $url_length{$tmp} = $url_length{$urls[$cur]} - 1 unless defined $url_length{$tmp};
                        }
                    }
                }
            }
            close($fh);
        } else {
            say "Connection error $hdrs->{Status} $hdrs->{Reason}\n host: $urls[$cur]";
        }
        $active--;
        while ($active < $q_nums) {
            $request->();
        }
        $cv->end;                                                                                                
    };
}; $request->() for 1..$q_nums;

$cv->end;
$cv->recv;
