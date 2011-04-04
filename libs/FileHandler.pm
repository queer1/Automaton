package libs::FileHandler;
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
use Switch '__';
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
use Getopt::Std;
use File::Path;
use File::Copy;
use File::stat;
#################################################
# My Modules
##
# All provided in the ./libs directory
##
use libs::DBCON;
use libs::LogHandle;
use libs::CMDHandle;
#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&read_cfg $cfg_type @default_accounts @mail_body @system_accounts %file_user %shad_user %cfg_values @wheel $host_cfg);
use vars qw($cfg_type @default_accounts @mail_body @system_accounts %file_user %shad_user %cfg_values @wheel $host_cfg);
#################################################
# Variables Exported From Module - Definitions
##
$cfg_type='cmspars';
@default_accounts=();
@system_accounts=();
%file_user=();
%shad_user=();
%cfg_values=();
@wheel=();
$host_cfg='';
@mail_body=();
#################################################
# Local Internal Variables for this Module
##
my $handle="none";
my $act_expires;
my $group_wheel="none";

my $myname="module FileHandle.pm";

#$loglev="1";
#$logtype="debug";
#$message="";
#################################################
#  Sub-Routines / Functions Definitions
##
# This is the actual Body of the module 
##
################## READ_CFG #####################
#
# Read in /etc/Automaton/automaton.cfg and start gathering
# database connection information
#
##
sub read_cfg {
  my $subname="sub read_cfg";
  my $caller=$myname." :: ".$subname;
  my $n_line;
  my $read_conf='';

  if ("@_" ne '') {
    $cfg_type=shift(@_);
  } if ("@_" ne '') {
    $cfg_file=shift(@_);
  } if ("@_" ne '') {
    $handle=shift(@_);
  }

  
  if ("$cfg_type" eq "mailpars") {
    $read_conf=$cfg_file."/".$handle."_email.tmplt";
  } else {
    $read_conf="$cfg_file";
  }

  open (readCFG, "$read_conf") or die &log_it("Cant open $read_conf :: $!","error","1","$caller");
    my @cfg_params=<readCFG>;
  close (readCFG);

  switch($cfg_type) {
    case "cfgpars" {
      my $caller = "$caller :: cfgpars";
      foreach (@cfg_params) {
        chomp;
        #&log_it("\$_ currently $_ currently in $cfg_file","debug","3","$caller");
        next if $_=~ /^\s*#/;
        next if $_=~ /^[#]/;

        if ($_=~/logfile_location/) {
          (undef, $log_file)=split /[=]/;
          $log_file =~ s/(\w+)(\s).*/$1/;
          &log_it("logfile_location currently $log_file...","debug","3", "$caller");
        } 

        if ($_=~/log_verbosity/) {
          $_ =~ s/(\w*)[=](\d+).*/$2/;
          $opt_v=$_;
          &log_it("log_verbosity currently $opt_v...","debug","3", "$caller");
        } 

        if ($_=~/host_files/) {
          (undef, $host_cfg)=split /[=]/;
          $host_cfg =~ s/(\w+)(\s).*/$1/;
          &log_it("host_files currently $host_cfg...","debug","3", "$caller");
        }
 
        if ($_=~/database_dbi/) {
          (undef, $dbi)=split /[=]/;
          $dbi =~ s/(\w+)(\s).*/$1/;
          &log_it("database_dbi currently $dbi...","debug","3", "$caller");
        }
  
        if ($_=~/database_name/) {
          (undef, $db_name)=split /[=]/;
          $db_name =~ s/(\w+)(\s).*/$1/;
          &log_it("database_name currently $db_name...","debug","3", "$caller");
        } 
        
        if ($_=~/database_host/) {
          (undef, $db_host) = split /[=]/;
          $db_host =~ s/(\w+)(\s).*/$1/;
          &log_it("database_host currently $db_host...","debug","3", "$caller");
        } 
        
        if ($_=~/database_user/) {
          (undef, $db_user) = split /[=]/;
          $db_user =~ s/(\w+)(\s).*/$1/;
          &log_it("database_user currently $db_user...","debug","3", "$caller");
        } 
        
        if ($_=~/database_pass/) {
          (undef, $db_pass) = split /[=]/;
          $db_pass =~ s/^["]//;
          $db_pass =~ s/["](\s+)?$//;
          &log_it("database_pass currently $db_pass","debug","1", "$caller");
        }

        if ($_=~/max_filesize/) {
          (undef, $max_fsize) = split /[=]/;
          $max_fsize =~ s/(\w+)(\s).*/$1/;
          &log_it("database_user currently $max_fsize...","debug","3", "$caller");
        } 

        if ($_=~/image_dd/) {
          (undef, $image_dd) = split /[=]/;
          $image_dd =~ s/(\w+)(\s).*/$1/;
          &log_it("database_user currently $image_dd...","debug","3", "$caller");
        } 

        if ($_=~/image_size/) {
          if ($image_dd eq 'no') {
            &log_it("ignoring image_size option as image_dd is disabled","debug","3", "$caller");
          } else {  
            (undef, $image_size) = split /[=]/;
            $image_size =~ s/(\w+)(\s).*/$1/;
            &log_it("database_user currently $image_size...","debug","3", "$caller");
          }
        } 

        if ($_=~/image_dd_store/) {
          if ($image_dd eq 'no') {
            &log_it("ignoring image_dd_store option as image_dd is disabled","debug","3", "$caller");
          } else {  
            (undef, $image_dd_store) = split /[=]/;
            $image_dd_store =~ s/(\w+)(\s).*/$1/;
            &log_it("database_user currently $image_dd_store...","debug","3", "$caller");
          }
        } 
  
        if ($_=~/image_compress/) {
          if ($image_dd eq 'no') {
            &log_it("ignoring image_size option as image_dd is disabled","debug","3", "$caller");
          } else {  
            (undef, $image_compress) = split /[=]/;
            $image_compress =~ s/(\w+)(\s).*/$1/;
            &log_it("database_user currently $image_compress...","debug","3", "$caller");
          }
        } 

        if ($_=~/use_mail/) { 
          (undef, $use_mail) = split /[=]/;
          $use_mail =~ s/(\w+)(\s).*/$1/;
          &log_it("use_mail is $use_mail...","debug","3", "$caller");
        } 

        if ($_=~/remote_host/) { 
          (undef, $remote_host) = split /[=]/;
          $remote_host =~ s/(\w+)(\s).*/$1/;
          &log_it("remote host is $remote_host...","debug","3", "$caller");
        } 

        if ($_=~/mail_host/) { 
          (undef, $mail_host) = split /[=]/;
          $mail_host =~ s/(\w+)(\s).*/$1/;
          &log_it("mail host is $mail_host...","debug","3", "$caller");
        } 

        if ($_=~/mail_to/) { 
          if ($use_mail eq 'no') { 
            &log_it("ignoring mail_to option as use_mail is disabled","debug","3", "$caller");
          } else {  
            (undef, $mail_to) = split /[=]/;
            $mail_to =~ s/(\w+)(\s).*/$1/;
            &log_it("mail_to address is $mail_to...","debug","3", "$caller");
          } 
        } 

        if ($_=~/mail_from/) { 
          if ($use_mail eq 'no') { 
            &log_it("ignoring mail_from option as use_mail is disabled","debug","3", "$caller");
          } else {  
            (undef, $mail_from) = split /[=]/;
            $mail_from =~ s/(\w+)(\s).*/$1/;
            &log_it("database_user currently $mail_from...","debug","3", "$caller");
          } 
        } 
      }
    }

    case "genericpars" {
      my $caller = "$caller :: genericpars";
      #### simple generic parser  
      ## produces simple hash that can be passed off to the correct module / sub and then processed there
      foreach (@cfg_params) {
        chomp;
        next if $_=~ /^\s*#/;
        next if $_=~ /^[#]/;
        if ($_ =~ /(\w+)=(\".+?\"|\'.+?\'|.+)\s*(#.*|)/) {
          my $varName=$1;
          my $varVal=$2;
          $varVal =~ s/^["]//;
          $varVal =~ s/["](\s+)?$//;
          $cfg_values{$varName} = $varVal ;
        }
      }
      while ( my ($key, $value) = each(%cfg_values) ) {
        &log_it("key $key => value $value","debug","3","$caller");
      }
    }

    case "rulespars" { 
      my $caller = "$caller :: rulespars";
      &log_it("selected","debug","3","$caller");
    }

    case "mailpars" { 
      my $caller = "$caller :: mailpars";
      &log_it("selected","debug","3","$caller");
      my $mail_dir="$cfg_file";
      my $handler="$handle";

      ## Sticking all email templates into @mail_templates, maybe necessary later.
      chdir("$mail_dir") or die &log_it("Premature Evacuation :: Cannot chdir to $mail_dir ($!)\n","error","1","$caller");
      my @mail_templates=<*.tmplt>;
      
      my $mail_cfg=$mail_dir."/".$handler."_email.tmplt";
      
      ## This has been enabled,
      ## but this has been put into place so that multiple email templates can be read in and then the appropriate one
      ## can be passed to libs::MailHandler dependant on what the $mail_template is. 
      ##  
      switch("$handler"){
        case "generic" {
          &log_it("Scanning mail template directory, $handler defined","debug","3","$caller");
          if (-e "$mail_cfg") {
            foreach (@cfg_params) {
              chomp;
              next if $_=~ /^\s*#/;
              next if $_=~ /^[#]/;
              push(@mail_body, "$_");
            }
          } else {
            die &log_it("Premature Evacuation :: config file $mail_cfg does not exist ($!)\n","error","1","$caller");
          }
        } case "alert" {
          &log_it("Scanning mail template directory, $handler defined","debug","3","$caller");
          if (-e "$mail_cfg") {
            foreach (@cfg_params) {
              chomp;
              next if $_=~ /^\s*#/;
              next if $_=~ /^[#]/;
              push(@mail_body, "$_");
            }
          } else {
            die &log_it("Premature Evacuation :: config file $mail_cfg does not exist ($!)\n","error","1","$caller");
          }
        } else {
          die &log_it("Handler specified is $handler, this is not valid","debug","3","$caller");
        }
      }
    }

    case "passpars" {
      my $caller = "$caller :: passpars";
      foreach (@cfg_params) {
        chomp;
        my ($sys_user,$user_status) = (split /[:]/,$_)[0,6] ;
        foreach (@system_accounts) {
          if ($sys_user eq $_) {
            &log_it("$sys_user matches $_ Account is a system account skipping","debug","3","$caller :: system_account");
            $sys_user="none";
          }
        }
        foreach(@default_accounts) {
          if ($sys_user eq $_) {
            &log_it("$sys_user matches $_ Account is a default account ignoring","debug","3","$caller :: passpars :: default_account");
            $sys_user="none";
          }
        }
        if ("$sys_user" eq "none") {
          &log_it("sys_user -> $sys_user == 0, skipping this as it is a system or default account","debug","3","$caller");
        } else {
          &log_it("sys_user -> $sys_user, adding this entry as this is not system account","debug","3","$caller");
          $file_user{$sys_user} = $user_status;
        }
      }
    }

    case "shadpars" {
      my $caller = "$caller :: shadpars";
      foreach (@cfg_params) {
        #&log_it("Parsing shadow file\n","debug","3","$caller :: shadpars"); 
        chomp;
        if ($handle eq "none") {
          &log_it("IGNORING :: Parsing shadow file, user currently $_","debug","2","$caller");
          #my ($shadname, $local_pass, $pass_sdate, $pass_bcdate, $pass_acdate, $pass_warn, $pass_expires, undef)=split /[:]/;
          #&log_it("user=$shadname password=$local_pass account expires=$act_expires \n","debug","3","$caller"); 
          #push (@{$shad_user{$shadname}}, $local_pass, $pass_sdate, $pass_bcdate, $pass_acdate, $pass_warn, $pass_expires);
        } else {
          if ($_ =~ /$handle/) {
            &log_it("Parsing shadow file, user currently $_","debug","2","$caller");
            my ($shadname, $local_pass, $pass_sdate, $pass_bcdate, $pass_acdate, $pass_warn, undef, $pass_expires, undef)=split /[:]/;
            &log_it("user=$shadname password=$local_pass account expires=$pass_expires","debug","3","$caller");
            push (@{$shad_user{$shadname}}, $local_pass, $pass_sdate, $pass_bcdate, $pass_acdate, $pass_warn, $pass_expires);
            $handle="none";
          }
        }
      }
    }

    case "grouppars" {
      my $caller = "$caller :: grouppars";
      foreach (@cfg_params) {
        #&log_it("Parsing group file","debug","3","$caller");
        chomp;
        if ($handle eq "none") {
          #$group_wheel=(split /[:]/,$_)[3];
          #@wheel=(split /[,]/,$group_wheel);
          &log_it("IGNORING :: Parsing group file handle $handle provided","debug","3","$caller");
        } else {
          if ($_ =~ /$handle/) {
            $group_wheel=(split /[:]/,$_)[3];
            if (defined($group_wheel)) {
              @wheel=(split /[,]/,$group_wheel);
            }else{
              $group_wheel="none";
              @wheel="none";
              &log_it("Wheel Group completely empty","debug","1","$caller");
            }
            $handle="none";
          }
        }
      }
    }

    case "userpars" {
      my $caller = "$caller :: userpars";
      my $csys=0;
      my $cdef=0;
      foreach (@cfg_params) {
        chomp;
        next if $_=~ /^\s*#/;
        next if $_=~ /^[#]/;
        #$_=~ /^(\w+)(\s)?/$1/;
        if ($_ =~ /cfg_type/) {
          $handle=(split /[=]/,$_)[1];
          &log_it("type == $handle _ == $_","debug","3","$caller :: userpars");
        }
        switch ($handle) {
          case ("system_accounts") {
            &log_it("\$_ currently $_ currently in $cfg_file","debug","3","$caller :: HANDLE == SYSTEM_ACCOUNTS");
            $system_accounts[$csys]=$_;
            $csys++;
          } case ("default_accounts") {
            &log_it("\$_ currently $_ currently in $cfg_file","debug","3","$caller :: HANDLE == DEFAULT_ACCOUNTS");
            $default_accounts[$cdef]=$_;
            $cdef++;
          }
        }
      }
    }
  }
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
# To access documentation please use perldoc FileHandler.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

FileHandler.pm - Automaton Framework: Forensic Auditing Toolkit

=head1 SYNOPSIS

FileHandler.pm - File Handler
A sub-routine (function) to handle all of the file parsing events

=head1 DESCRIPTION

This consists of main function &read_cfg, 
To use this function, the function requires 2 parameters:

1. Type of file,
Each file is evaluated according to type, these are currently:
* cfgpars
* genericpars
* mailpars
* userpars 
* shadpars
* grouppars
* passpars

2. The file name, 
This should be the path and the filename to pars.


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
