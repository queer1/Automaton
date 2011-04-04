package libs::MailHandler;
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
#                               GNU/GPL v2 or later 2010                 #
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
use Switch '__';
#################################################
# External Modules 
##
# These will need to be installed on the system
# running this script 
#
# Refer to the installation directory which will 
# provide auto installation scripts for all 
# required perl modules
##
#################################################
# My Modules
##
# All provided in the ./libs directory
##
use libs::FileHandler;
use libs::CMDHandle;
use libs::GenDate;
use libs::LogHandle;
use libs::ChkMods;
use libs::RCON;
#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&send_mail $mailer $locate_mailer $mail_type $mail_template);
use vars qw($mailer $locate_mailer $mail_type $mail_template);
#################################################
# Variables Exported From Module - Definitions
##
$mailer="/usr/sbin/sendmail";
$locate_mailer=`which sendmail`;
##need to get rid of blank space/new line from system command hence chomp
chomp($locate_mailer);
$mail_type='generic';
$mail_template="/etc/Automaton/templates/email-messages";
#################################################
# Local Internal Variables for this Module
##
my $myname=":: module MailHandler.pm";
my $mail_subject="Automaton Email System";
my $mail_ctype="Content-Type: text/plain; charset=UTF-8";
my $mail_cenc="Content-Transfer-Encoding: 8bit";
my $smtp='';
my %email_header=();
my @message_content='';
my $user="Test User";
my @mail_header;

#################################################
#  Sub-Routines / Functions Definitions
###
# This is the actual Body of the module 
##
 
#$message_type = " 
$user="Vamegh Hedayati";

## This module has been inspired by the following script:  
## http://svn.apache.org/repos/asf/subversion/branches/1.6.x/contrib/hook-scripts/commit-email.pl.in $
## Which is licensed under the APACHE v2.0 License, terms available here: 
## http://svn.apache.org/repos/asf/subversion/trunk/LICENSE
## None of the code is actually being used, to avoide breaking license terms although, GPLv3 and Apache v2 licensese are compatible. 

sub send_mail {
  my $subname="sub send_mail";
  my $caller=$myname." :: ".$subname;
  &make_date;
  &read_cfg("mailpars","$mail_template","$mail_type");
  

  if ($use_mail=~/no/i) {
    &log_it ("eMail Alerts are disabled from within the configuration, emails will not be sent","debug","2","$caller");
  } elsif ($use_mail=~/yes/i) {
    push(@message_content, "\nRemote Machine: $host_name has just been scanned, \nthis is just an alert to inform you of this\n\n");
    ##
    # This has been done this way for future expansion
    # Ideally several different templates need to be created
    # for different types of emails. 
    ##
    # This is where the $mail_type comes in each type corresponds to a different mail_template file 
    # Right now only generic is available in a future revision , many different template types 
    # can be added and can be added to the below switch statement. 
    ##
    switch($mail_type) {
      case "generic" {
        &log_it("Creating new email type $mail_type","debug","3","$caller");
        ##push (@{$email_header{"$mail_type"}}, $fdate, $mail_to, $mail_from, $mail_subject, $mail_ctype, $mail_cenc );
        ## @mail_body is populated by libs::FileHandle, where the template file is read in.

        foreach (@mail_body) {
          chomp;
          s/\@\@\@DATE\@\@\@/$fdate/;
          s/\@\@\@USER\@\@\@/$user/;
          s/\@\@\@BEGIN\@\@\@/@message_content/;
        }

        &log_it("Created new email body for $mail_type","debug","3","$caller");
        &log_it("email created which reads \n @mail_body","debug","3","$caller");
      } else {
        &log_it("mail type $mail_type, not supported please verify","debug","3","$caller");
      }
    }

    push(@mail_header, "Date: $fdate\n");
    push(@mail_header, "To: $mail_to\n");
    push(@mail_header, "From: $mail_from\n");
    push(@mail_header, "Subject: $mail_subject\n");
    push(@mail_header, "$mail_ctype\n");
    push(@mail_header, "$mail_cenc\n");
    push(@mail_header, "\n");

    ##
    # Currently disabled -- Is this really necessary ? really messy if nesting - Do I care if user gets choice on how to send email?.. 
    # Possibly, badly configured mta, specific policy of only using centralised mta or anything to that effect -- 
    # too much error checking used though, need to clean this up and work out a better way of doing this
    ##
    # if (("$remote_host" eq "no") || ("$remote_host" eq '') || (!defined("$remote_host"))) {
    # } else {
    #  &log_it("Sorry mailer $mailer not found, Cannot send emails please correct this","error","1","$caller");
    # }
    ##
    &log_it("Remote host is currently $remote_host","error","1","$caller");

    if ($remote_host=~/yes/i) {
      &mail_smtp;
    } else {
      &log_it("mail host currently $mail_host","debug","3","$caller");
      if (("$mail_host" eq "localhost") || ("$mail_host" eq "127.0.0.1") || (!defined("$mail_host")) || ("$mail_host" eq '')) {
        ##$remote_host="no";
        if (-e "$mailer") {
          &mail_simple;
          &log_it("Mailer $mailer found, processing using \&mail_simple","debug","3","$caller");
        } else {
          if ($locate_mailer !~ /sendmail/) {
            &log_it ("cant find sendmail binary, moving to Net::SMTP method","error","2","$caller");
            &mail_smtp;
          } else {
            $mailer="/usr/sbin/sendmail";
            $locate_mailer=`which sendmail`;
            &log_it("Mailer $mailer found, processing using \&mail_simple","debug","3","$caller");
            &log_it("Preparing email","debug","3","$caller");
            &mail_simple;
          }
        }
      } else {
        &log_it("Mailer $mailer found and remote_host is disabled still will try using \&mail_smtp","error","1","$caller");
        ##$remote_host="yes";
        &mail_smtp;
      }
    }
  } else {
    &log_it("Use Emails currently set to $use_mail, this is an unknown option, emails will not be processed","error","2","$caller");
  }
}


sub mail_simple {
  my $subname="sub mail_simple";
  my $caller=$myname." :: ".$subname;

  #my $email_admin=shift(@_);
  #my $email_message=shift(@_);

  #my @mail_header = @{$email_header{$mail_type}};
  ## reading elements from array of db_user_variables, to grab all relevant user info,
  ## if array ever changes please change these lines.
  ##push (@{$email_header{"$mail_type"}}, $fdate, $mail_to, $mail_from, $mail_subject, $mail_ctype, $mail_cenc );

  &log_it("date is $fdate, mailto is $mail_to, mailfrom is $mail_from, subject is $mail_from","debug","1","$caller");

  my $mailDate="Date: $fdate";
  my $mailTo="To: $mail_to";
  my $mailFrom="From: $mail_from";
  my $mailSubject="Subject: $mail_subject";
  my $syscommand="$mailer -f'$mail_from' $mail_to";
  
  &log_it("header is @mail_header and mail body is @mail_body message content is @message_content\n\n","debug","1","$caller");

  if (open(MAILER, "| $syscommand")) {
    print MAILER @mail_header; 
    foreach(@mail_body) {
      print MAILER $_."\n";
    }
    close MAILER or &log_it("Could not close MAILER :: $syscommand :: $!\n","error","1","$caller");
  } else {
    &log_it(":: Could not open Mailer $mailer:: Cannot send emails" ,"error","1","$caller");
  }
}

sub  mail_smtp {
  my $subname="sub mail_smtp";
  my $caller=$myname." :: ".$subname;

  &chkmod_exists("Net::SMTP");
  &log_it("It appears $mod_use is available using this","debug","3","$caller");
  eval {
    require "$mod_use.pm";
    "$mod_use.pm"->import();
  };
  &log_it("In $myname :: Using $mod_name loaded $mod_use, eval returned $@","debug","3","$caller");

  my $mailer = Net::SMTP->new(
                                Host => $mail_host,
                                Timeout => 10,
                                Debug   => 1,
                              );
  $mailer->mail($mail_from);
  $mailer->recipient($mail_to, { Notify => ['FAILURE','DELAY'], SkipBad => 1});
  $mailer->data();
  $mailer->datasend(@mail_header);
  foreach(@mail_body) {
    $mailer->datasend($_."\n");
  }
  $mailer->dataend();
  $mailer->quit();
  
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
# To access documentation please use perldoc MailHandler.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

MailHandler.pm - Automaton Framework: Forensic Auditing Toolkit

=head1 SYNOPSIS

 A Quick description of the functionality 

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
