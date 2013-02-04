#!/usr/bin/env perl
use strict;
use warnings;
use IPC::Open2;

my $pid = open2(my $stdout, my $stdin, "file", $ARGV[0]) or die;
waitpid($pid, 0);
die "Can't file " . $ARGV[0] if ($? >> 8) != 0;
die "Not an XML file" if (<$stdout> !~ /XML/);
