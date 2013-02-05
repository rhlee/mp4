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
      $pts += $element->att("DTS") if ($element->att_exists("CTSOffset"));
      push(@ptss, $pts);
    }
  }
);
$twigin->parsefile($ARGV[0]);
@ptss = sort {$a <=> $b} @ptss;

my %elements = ();
my $count = 0;
my $twigout = XML::Twig->new(
  twig_handlers => {
    NHNTStream => sub {
      $_->set_att("timeScale", "1000");
    },
    NHNTSample => sub {
      my $element = $_;
      my $oldDts = $element->att("DTS");
      my $oldPts = $oldDts;
      
      $element->set_att("DTS", $ptss[$count] * $factor);
      
      print $oldPts . "\n";
      if ($element->att_exists("CTSOffset")) {
        $oldPts += $element->att("CTSOffset");
        print $oldPts . "\n";
        
        #outside if?
        if (defined (my $deferredElement = $elements{$oldDts})) {
          die "sagdahakd";
          #delete
        }
        
        $elements{$oldPts} = $element;
      }
      $count++;
    }
  },
  pretty_print => "nice"
);
$twigout->parsefile($ARGV[1]);
#$twigout->print;
