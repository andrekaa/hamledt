#!/usr/bin/env perl
use strict;
use warnings;

my %count;
my %test;

while (<>) {
    next if !/^HamleDT::Test/;
    chomp;
    my ($test,$file) = split;
    $file =~ /\/([a-z]+)\/treex/
        or die "file doesn't match expected pattern: $file";
    my $language = $1;
    $count{$language}{$test}++;
    $count{$language}{TOTAL}++;
    $count{TOTAL}{$test}++;
    $count{TOTAL}{TOTAL}++;
    $test{$test} = 1;
}

my @languages = sort keys %count;
my @tests = (sort( keys %test), 'TOTAL');

use Text::Table;

my $tb = Text::Table->new(
        'Test/Language', @languages,
    );

$tb->load(
    map {
        my $test = $_;
        [$_, map {$count{$_}{$test} || 0} @languages]
    } @tests
);

print $tb;
