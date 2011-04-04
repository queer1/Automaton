package libs::DBCON;
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
use DBI;
use Getopt::Std;
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
#################################################
# My Modules
##
# All provided in the ./libs directory
##
use libs::LogHandle;
use libs::CMDHandle;
use libs::GenDate;
#use libs::FileHandle;
#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&db_connect &db_gather %user_db $username $passwd $ssh_type $ssh_key $ssh_mail $is_admin $is_deleted $expires);
use vars qw(%user_db $db_name $db_hid $db_host $username $passwd $ssh_type $ssh_key $ssh_mail $is_admin $is_deleted $expires);
#################################################
# Variables Exported From Module - Definitions
##
## DataBase Values 
%user_db=();
$username='';
$passwd='';
$ssh_type='';
$ssh_key='';
$ssh_mail='';
$is_admin='';
$is_deleted='';
$expires='';
### These are provided by cmd_handle 
# DISABLED
#$db_name='';
#$db_hid='';
#$db_host='';
#$db_user='';
#$db_pass='';
#$dbi='';
#$db_port='';
#our $opt_v="3";
#################################################
# Local Internal Variables for this Module
##
my $myname=":: module DBCON.pm";
#################################################
#  Sub-Routines / Functions Definitions
##
# This is the actual Body of the module 
##
# CONNECT TO DB AND PULL USER INFO 
# connect to database and grab info
# log into db:
##
sub db_connect {
  my $subname="sub db_connect";
  my $caller=$myname." :: ".$subname;
  &log_it("In db_connect","debug","3","$caller");
  my $dsn = "dbi:${dbi}:host=${db_host};database=${db_name}:${db_host}:${db_port}";
  my $dbh = DBI->connect($dsn,$db_user,$db_pass) or &log_it("cant connect :: $! $DBI::errstr","error","1");
  &db_gather($dsn,$dbh);
  &log_it("dsn == $dsn dbh == $dbh Leaving db_connect","debug","3","$caller");
}
##
# do a select grab all relevant info for this host
# and dump all info into a hash for later use 
##
#
# None of this currently works, db layout changed
sub db_gather{
  my $subname="sub db_gather";
  my $caller=$myname." :: ".$subname;
  my $dsn = shift(@_);
  my $dbh = shift(@_);

  &log_it("dsn == $dsn dbh == $dbh IN db_gather","debug","2","$caller");
  ##my $users_pass = $dbh->prepare("SELECT username, passwd, ssh_key, is_admin, accounts.is_deleted, expires FROM accounts, account_link WHERE accounts.id=account_link.account_id AND account_link.host_id=\'$db_hid\'");
  my $users_pass ="";

  $users_pass->execute;

  while (my @rows = $users_pass->fetchrow_array()){
    #chomp;
    &log_it("rows = @rows","debug","3","$caller");
    ($username, $passwd, $ssh_type, $ssh_key, $ssh_mail, $is_admin, $is_deleted, $expires) = split /\s/, "@rows";
    $ssh_key = "$ssh_type $ssh_key $ssh_mail";
    &log_it("username = $username passwd = $passwd ssh_key = $ssh_key is_admin = $is_admin is_deleted = $is_deleted expires = $expires date $date","debug","3","$caller");
    push (@{$user_db{"$username"}}, $passwd, $ssh_key, $is_admin, $is_deleted, $expires );
  }
  &log_it("Leaving db_gather","debug","3","$caller");
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
# To access documentation please use perldoc DBCON.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

DBCON.pm - Automaton Framework: Forensic Auditing Toolkit

=head1 SYNOPSIS

 Database Connection Handler 

=head1 DESCRIPTION

This consists of 2 main functions,

        1. db_connect
           This connects to the database, using either the command line options passed to it, 
           or the information from /etc/Automaton/automaton.cfg
        2. db_gather  
           This collects all of the information and outputs to whatever program calls this module.

The db_connect function should only ever be called from a script or another module.

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
