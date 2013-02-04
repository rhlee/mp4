#!/usr/bin/env perl
use strict;
use warnings;
use IPC::Open2;

my $pid = open2(my $stdout, my $stdin, "file", $ARGV[0]) or die;
waitpid($pid, 0);
die "Can't file " . $ARGV[0] if ($? >> 8) != 0;
die "Not an XML file" if (<$stdout> !~ /XML/);

my $dts = 0;
open(my $file, $ARGV[0]) or die "Can't open file";
while (my $line = <$file>) {
  if ($line =~ /^<NHNTSample DTS="(\d+)"/) {
    print "$1\n";
  }
}
close $file;
