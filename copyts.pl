#!/usr/bin/env perl
use strict;
use warnings;
use XML::Twig;

my $factor = 4 / 1001;
my @ptss = ();

my $twigin = XML::Twig->new(
  twig_handlers => {
    NHNTSample => sub {
      my $element = $_;
      my $pts = $element->att("DTS");
      $pts += $element->att("DTS") if $element->att_exists("CTSOffset");
      push(@ptss, $pts);
    }
  }
);
$twigin->parsefile($ARGV[0]);
@ptss = sort {$a <=> $b} @ptss;
foreach (@ptss) {
  print $_ . "\n";
}
#$twig->print;
