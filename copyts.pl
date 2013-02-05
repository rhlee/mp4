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
      $pts += $element->att("CTSOffset") if ($element->att_exists("CTSOffset"));
      push(@ptss, $pts);
    }
  }
);
$twigin->parsefile($ARGV[0]);
@ptss = sort {$a <=> $b} @ptss;

my $count = 0;
my $twigout = XML::Twig->new(
  twig_handlers => {
    NHNTStream => sub {
      $_->set_att("timeScale", "1000");
    },
    NHNTSample => sub {
      my $element = $_;
      $element->set_att("DTS", $ptss[$count] * $factor);
      
      if ($element->att_exists("CTSOffset")) {
        die "cts offset detected";
      }
      $count++;
    }
  },
  pretty_print => "nice"
);
$twigout->parsefile($ARGV[1]);
$twigout->print;
$|++;
