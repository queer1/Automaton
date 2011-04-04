package libs::FileHandle;
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
@EXPORT = qw(&read_cfg $cfg_type @default_accounts @system_accounts %file_user %shad_user @wheel);
use vars qw($cfg_type @default_accounts @system_accounts %file_user %shad_user @wheel);
#################################################
# Variables Exported From Module - Definitions
##
$cfg_type='cmspars';
@default_accounts=();
@system_accounts=();
%file_user=();
%shad_user=();
@wheel=();
#################################################
# Local Internal Variables for this Module
##
my $handle="none";
my $act_expires;
my $group_wheel="none";

my $myname="module FileHandle.pm";
#################################################
#  Sub-Routines / Functions Definitions
##
# This is the actual Body of the module 
##
################## READ_CFG #####################
#
# Read in /etc/cms.cfg and start gathering
# database connection information
#
##
sub read_cfg {
        my $subname="sub read_cfg";
        my $caller=$myname." :: ".$subname;

        if ("@_" ne '') {
                $cfg_type=shift(@_);
        } if ("@_" ne '') {
                $cfg_file=shift(@_);
        } if ("@_" ne '') {
                $handle=shift(@_);
        }

        my $n_line;

        open (readCFG, "$cfg_file") or die &log_it("Cant open $cfg_file :: $!","error","1","$caller");
                my @cfg_params=<readCFG>;
        close (readCFG);

        switch($cfg_type) {
                case "cmspars" {
                        foreach (@cfg_params) {
                                chomp;
                                &log_it("\$_ currently $_ currently in $cfg_file","debug","3","$caller");
                                next if $_=~ /^\s*#/;
                                next if $_=~ /^[#]/;
                                if ($_=~/XX_HOST_ID/) {
                                        $_ =~ s/(\w*)[=](\d+).*/$2/;
                                        $db_hid=$_;
                                }
                                if ($_=~/CMS_CONFIG_URL/) {
                                        &log_it("\$_ Matches CMS_CONFIG_URL currently $_ currently in $cfg_file","debug","2","$caller");
                                        $_ =~ s/export (\w*)[=]["](\w*)["]/$2/;
                                        (undef, $dbi, $n_line)=split /[:]/;
                                        ($db_db, $db_host)=split /[;]/ , "$n_line";
                                        (undef, $db_db) = split /[=]/ , "$db_db";
                                        (undef, $db_host) = split /[=]/ , "$db_host";
                                        #$db_host=~s/(\w*)["].*/$1/;
                                        $db_host=~s/["']?//g;
                                } if ($_=~/CMS_CONFIG_USER/) {
                                        &log_it("\$_ Matches CMS_CONFIG_USER currently $_ currently in $cfg_file","debug","2", "$caller");
                                        (undef, $db_user)=split /[=]/;
                                        #$db_user=~s/["](\w*)["].*/$1/;
                                        #$db_user=~s/["]?[']?//g;
                                        $db_user=~s/["']?//g;
                                        &log_it("db_user currently $db_user","debug","3");
                                } if ($_=~/CMS_CONFIG_PASS/) {
                                        (undef, $db_pass)=split /[=]/;
                                        &log_it("\$_ Matches CMS_CONFIG_USER currently $_ currently in $cfg_file","debug","2", "$caller");
                                        $db_pass=~s/["]?[']?//g;
                                        &log_it("db_pass currently $db_pass","debug","3");
                                }
                        }
                        &log_it("db_hid = $db_hid, db_user = $db_user, db_pass = $db_pass, db_db = $db_db, db_host = $db_host, dbi = $dbi currently in $cfg_file","debug","3","$caller");
                }

                case "passpars" {
                        foreach (@cfg_params) {
                                chomp;
                                #       if (/[.]/) {
                                #}
                                my ($sys_user,$user_status) = (split /[:]/,$_)[0,6] ;
                                foreach (@system_accounts) {
                                        if ($sys_user eq $_) {
                                                &log_it("$sys_user matches $_ , This account is a system account skipping","debug","3","$caller :: passpars :: system_account");
                                                $sys_user="none";
                                        }
                                }

                                foreach(@default_accounts) {
                                        if ($sys_user eq $_) {
                                                &log_it("$sys_user matches $_ , This account is a default account, ignoring","debug","3","$caller :: passpars :: default_account");
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

                case "pars1" {

                ;}

                case "pars2" {

                ;}
                case "pars3" {

                ;}
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
# To access documentation please use perldoc LogHandler.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

 FileHandle.pm - vFATS  Forensic Auditing Toolkit System

=head1 SYNOPSIS

 FileHandle.pm - File Handler
 A sub-routine (function) to handle all of the file parsing events

=head1 DESCRIPTION

 This consists of main function &read_cfg, 
 To use this function, the function requires 2 parameters:

        1. Type of file,
           Each file is evaluated according to type, these are currently:
                * cmspars
                * userpars 
                * shadpars
                * grouppars
                * passpars
                There are 3 others put in but not used pars1, pars2, pars3 for future use

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

Please refer to the COPYING file which is distributed with vFATS 
for the full terms and conditions

=cut
#
#################################################
#
######################################### EOF  #######################################################
