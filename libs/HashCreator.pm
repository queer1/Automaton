package libs::HashCreator;
#
##
##########################################################################
#                                                                        #
#       Automaton Framework                                              #
#                                                                        # 
#       Forensic Auditing Toolkit                                        #
#                                                                        #
#       Forensic Auditing System - Designed to build an audit trail      #
#       and health check on all systems                                  #
#                                                                        #
#       Copyright (C) 2010 by Vamegh Hedayati                            #
#       vamegh@gmail.com                                                 #
#                                                                        #
#       Please see Copying for License Information                       #
#                               GNU/GPL v2 2010                          #
##########################################################################
##
#
#################################################
# Integrity Checks
##
use strict;
use warnings;
#################################################
# Builtin Modules
##
# These should be available by default 
##
#################################################
# My Modules
##
# All provided in the ./libs directory
##
use libs::ChkMods;
use libs::LogHandle;
#################################################
# External Modules 
##
# These will need to be installed on the system
# running this script 
#
# Rrefer to the installation directory which will 
# provide auto installation scripts for all 
# required perl modules
##

#use Digest::MD5 qw(md5_hex);
#use Digest::SHA qw(sha1_hex sha512_hex);

use Digest::MD5;
use Digest::SHA;

#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&createHash $md5digest $sha1digest $sha512digest);
use vars qw($md5digest $sha1digest $sha512digest);
#################################################
# Variables Exported From Module - Definitions
##
$md5digest='';
$sha1digest='';
$sha512digest='';
#################################################
# Local Internal Variables for this Module
##
my $myname="module HashCreator.pm";
#################################################
#  Sub-Routines / Functions Definitions
###
# This is the actual Body of the module 
##
# print "caller is $caller\n";


sub createHash {
  my $indata = shift(@_);
  my $type=shift(@_);

  my $subname="sub createHash";
  my $caller=$myname." :: ".$subname;

  my $md5 = Digest::MD5->new;
  my $sha1 = Digest::SHA->new(1);
  my $sha512 = Digest::SHA->new(512);

  if ($type eq "var") {
    $md5->add($indata);
    $sha1->add($indata);
    $sha512->add($indata);
  } elsif ($type eq "file") {
    open(INFILE, $indata) or die "$indata $!\n";
      $md5->addfile(*INFILE);
      $sha1->addfile(*INFILE);
      $sha512->addfile(*INFILE);
    close(INFILE);
  } else {
    &log_it("The type should either be var or file, cant process this request","error","1","$caller");
 }
  $md5digest=$md5->hexdigest;
  $sha1digest=$sha1->hexdigest;
  $sha512digest=$sha512->hexdigest;
  &log_it("\nmd5=$md5digest\nsha1=$sha1digest\nsha512=$sha512digest -- $indata \n","debug","3","$caller");
}

END { }       # Global Destructor

1;

#################################################
#
################################### EO PROGRAM #######################################################
#
################################ MODULE HELP / DOCUMENTATION SECTION #################################
##
# Original implementation idea from linblock.pl http://www.dessent.net/linblock/ (c) Brian Dessent GNU/GPL
# This actually uses no code from linblock.pl, but the implementation was learnt by studying the above script
##
# To access documentation please use perldoc GenDate.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

HashCreator - Automaton Framework: Forensic Auditing Toolkit

=head1 SYNOPSIS

HashCreator takes any file as a quick description of the functionality 

=head1 DESCRIPTION

 This Module is a set of functions (sub routines), that handles ... 
 This should not need to be changed, but if anyone feels like improving it, feel free. 
 Defaults should be overridden from the the calling script, so again shouldnt need to be modified. 

=head1 AUTHOR

=over

=item Vamegh Hedayati <vamegh AT gmail DOT com>

=back

=head1 LICENSE

Copyright (C) 2010  Vamegh Hedayati <vamegh AT gmail DOT com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

Please refer to the COPYING file which is distributed with Automaton 
for the full terms and conditions

=cut
#
#################################################
#
######################################### EOF  #######################################################
