#!/usr/bin/env perl
use strict;
use warnings;
use XML::Twig;

my $factor = 4 / 1001;

my $twig = XML::Twig->new(
  twig_handlers => {
    NHNTStream => sub {
      $_->set_att("timeScale", "1000");
    },
    NHNTSample => sub {
      my $element = $_;
      $element->set_att("DTS",  $element->att("DTS") * $factor);
      $element->set_att("CTSOffset", $element->att("CTSOffset") * $factor)
        if ($element->att_exists("CTSOffset"));
    }
  },
  pretty_print => 'nice'
);
$twig->parsefile($ARGV[0]);
$twig->print;
