package libs::UserHandle;
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
# Refer to the installation directory which will 
# provide auto installation scripts for all 
# required perl modules
##
use Digest::MD5 qw(md5_hex);
use File::Path;
use File::Copy;
use File::stat;
#################################################
# My Modules
##
# All provided in the ./libs directory
##
use libs::LogHandle;
use libs::FileHandler;
use libs::DBCON;
use libs::GenDate;
#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT   = qw(&check_user &del_user &sus_user &add_user $account_cfgs $pass_file $shad_file $group_file);
use vars qw($account_cfgs $pass_file $shad_file $group_file);
#################################################
# Variables Exported From Module - Definitions
##
#variables exported to the calling program
##
$account_cfgs='';
#@wheel=();
#%file_user=();
#%shad_user=();
##
# required passwd files dont change here 
# override when calling this with whatever you want 
##
$pass_file="/etc/passwd";
$shad_file="/etc/shadow";
$group_file="/etc/group";
#################################################
# Local Internal Variables for this Module
##
my $user_shell="/bin/bash";
my $disable_shell="/usr/sbin/nologin";
my $user_add="/usr/sbin/useradd";
my $user_mod="/usr/sbin/usermod";
my $user_del="/usr/sbin/userdel";
my $admin_group="wheel";
my $user_group="users";
my $daytosec="86400";
##if accounts need to be deleted quicker than 180 days then change this value.
my $daystodel="180";
my (@loc_user, @user_key, @new_user ) ;
my ($user, $user_pass, $user_sshkey, $user_isadmin, $user_isdel, $user_expires, $user_path );

my $myname="Module UserHandle :: ";
#################################################
#  Sub-Routines / Functions Definitions
###
# This is the actual Body of the module 
##
######### USER CHECKING AND GENERATION ##########


#####
# This module was originally developed by me for another project, but it is very suitable for this project and for user manipulation.
# It has been manipulated for use in Automaton and should work pretty much as is, requires user information from database though. 
# - Vamegh (c) GNU/GPL 
#####


sub check_user {
  my $subname = "sub check_user";
  my $caller=$myname." :: ".$subname;
  ## Read thorugh the password file 
  ## Grab all users and their shell
  ## dump this info into a hash
  &log_it("In check_user","debug","3","$caller");
  ## calling in read_cfg from libs::filehandle
  ## This populates the hash arrays with user accounting data
  &read_cfg("userpars","$account_cfgs");
  &read_cfg("passpars","$pass_file");
  ## calling read_cfg to read through group file and populate @wheel.
  &read_cfg("grouppars","$group_file","$admin_group");
  ## hash %file_user populated by FileHandler.pm
  ## the read_cfg should have populated the file_user hash, time to work on the data.
  for my $sys_user (sort keys %file_user) {
  my $user_status = $file_user{$sys_user};
  @loc_user=(keys %file_user);
  }
  ## hash user_db is populated from DBCON.pm 
  ## this is called from the main program and should already have populated the user_db
  ## time to compare the users in the db against the system.
  my $i=0;
  ## user_key is the users on the database (the key of the user_db hash)
  ## These are all of the users that are on the db for this system. 
  @user_key = (keys %user_db);
  my @exists_user=grep(defined($file_user{$_}),@user_key);
  &log_it("Users that exist on the system and in db :: \@exists_user == @exists_user","debug","2","$caller");
  ## First check to see which ones dont exist. 
  my @not_exists=grep(!defined($file_user{$_}),@user_key);
  &log_it("Users that dont exist on system and are on db :: \@not_exists == @not_exists","debug","2","$caller");

  if ("@exists_user" eq '') {
    ## checking to see if array above is blank, if it is means no users on system
    ## so adding all of the users relevent to this system from user_db
    &log_it("No users on system, creating them all","debug","1","$caller");
    foreach(@user_key) {
      ##calling db_populate to populate the variables dealing with the db settings for said user.
      &db_populate("$_");
      switch ($user_isdel) {
        case "1" {
          &log_it("Seems user $_ has been set to be added, but db has asked for user to not be added, ignoring user","debug","1","$caller");
        } case "0" {
          ##adding said user to the system
          &add_user("$_");
          ##checking to see if said user is an admin
          &check_perm("$_","yes");
          ## checking to see if user has key on system, if they dont adding it..
          &cnc_key("$_");
        }
      }
    }
  } else {
    ## There are users on this system already,
    ## Need to sort through these users and check their status. 
    foreach my $user(@not_exists){
      ##calling db_populate to populate the variables dealing with the db settings for said user.
      &db_populate($user);
      switch ("$user_isdel") {
        case "1" {
          &log_it("Seems user $user has been set to be added, but db has asked for user to not be added, ignoring user","debug","2","$caller");
        } case "0" {
          &log_it("looks like $user doesnt exist adding","debug","2","$caller");
          ##adding said user to the system
          &add_user("$user");
          ##checking to see if said user is an admin
          &check_perm("$user","yes");
          ## checking to see if user has key on system, if they dont adding it..
          &cnc_key("$user");
        }
      }
    }
    foreach my $user(@exists_user){
      &log_it("User $user exists on the system checking and managing user","debug","1","$caller");
      ## If this matches the user is already on the system, 
      ## so now need to check if the users ssh_key or password has been updated, need to check to see if the account is disabled or expired.
      ## so passing this off to manage_user sub to work all of that out for this user
      &manage_user($user);
    }
  }
  &log_it("Leaving Check User","debug","3","$caller");
}

sub manage_user {
  my $user=shift(@_);
  my $subname="sub manage_user";
  my $caller=$myname." :: ".$subname;
  #if ("@_" ne '') { my $user=shift(@_); }
  ##calling db_populate to populate the variables dealing with the db settings for said user.

  &db_populate("$user");
  my $user_status=$file_user{"$user"};
  &log_it("In manage_user","debug","3","$caller");
  &log_it("Checking user :: $user :: of system compared to status on system","debug","3","$caller");
  &log_it("user_status == $user_status user = $user","debug","2","$caller");

  switch ($user_isdel) {
    case "1" {
      if ("$user_status" ne "$disable_shell") {
        &log_it("User $user should be disabled..","debug","2","$caller");
        &log_it("Deleting user $user and corresponding key","debug","1","$caller");
        &sus_user($user);
        &del_key($user);
      } else {
        &log_it("User $user is already disabled, need to check if $user should be deleted from the system now also making sure ssh key is removed..","debug","2","$caller");
        &del_user($user);
        &del_key($user);
      }
    } case "0" {
      if ("$user_status" ne "$disable_shell") {
        &log_it("User $user has login shell $user_status, which means user is enabled, checking users permissions, password and key now, to make sure nothing changed","debug","2","$caller");
        &cnc_key($user);
        &check_perm($user,"no");
        &check_pass($user);
      } elsif ("$user_status" eq "$disable_shell") {
        &log_it("User $user has login shell $user_status == $disable_shell -- account disabled it should be enabled ..","debug","1","$caller");
        &enable_user($user);
        &cnc_key($user);
        &check_perm($user,"no");
      }
    }
  }
}

sub cnc_key {
  my $user=shift(@_);
  my $subname="sub cnc_key";
  my $caller=$myname." :: ".$subname;
  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");
  ## Check and create ssh key, Checks to see if ssh key is valid still and creates key if the key has been updated or doesnt exist.
  &log_it("In create_key","debug","3","$caller");
  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $user_path=shift(@_); }
  ## calling getpwnam to grab username and group id for new user so chown works !!

  my ($uid, $gid) = (getpwnam($user))[2,3] or &log_it("User $user not in passwd file :: $!","error","1","$caller");
  &log_it("at key writing stage path is $user_path caller $caller","debug","1","$caller");

  if (! -e "$user_path" ) {
    #if ( ! -e "$user_path" ) {
    eval { mkpath ("$user_path/",1,0755) } or &log_it("Cannot make path :: $user_path $!","error","1","$caller");
    eval { chown ($uid,$gid,$user_path) } or &log_it("Cannot Chown :: $!","error","1","$caller");
    #}
    open (WRITEKEY, ">$user_path/authorized_keys") or &log_it("Cannot open file :: $user_path/authorized_keys","error","1","$caller");
      print WRITEKEY "$user_sshkey";
    close (WRITEKEY);
    eval { chmod oct(644), "$user_path/authorized_keys" } or &log_it("cannot CHMOD :: $!","error","1","$caller");
    eval { chown ($uid,$gid,"$user_path/authorized_keys")} or &log_it("cannot open file :: $!","error","1","$caller");
  } else {
    ## Read through key file stick it into an array and compare to db key value..
    open (ReadKey, "$user_path/authorized_keys") or &log_it("Cannot currently open users key file  :: $!","error","1","$caller");
      my $users_loc_key=<ReadKey>;
    close (ReadKey);

  my $dbkey_digest=md5_hex($user_sshkey);
  my $lockey_digest=md5_hex($users_loc_key);

  &log_it("local key MD5SUM == $lockey_digest -- database_key MD5SUM == $dbkey_digest","debug","2","$caller");

  if ("$dbkey_digest" eq "$lockey_digest") {
    &log_it("Keys Match not doing anything","debug","3","$caller");
  } elsif ("$dbkey_digest" ne "$lockey_digest") {
    &log_it("Keys Have Changed, Updating User $user  Key","debug","1","$caller");
    open (writeKey, ">$user_path/authorized_keys") or &log_it("Cannot open file :: $!","error","1","$caller");
      print writeKey "$user_sshkey";
    close (writeKey);
    eval { chmod oct(644), "$user_path/authorized_keys" } or &log_it("cannot CHMOD :: $!","error","1","$caller");
    eval { chown ($uid,$gid,"$user_path/authorized_keys")} or &log_it("cannot open file :: $!","error","1","$caller");
    }
  }
}

sub check_perm {
  my $subname="sub check_perm";
  my $caller=$myname." :: ".$subname;
  my $user=shift(@_);
  my $nuser=shift(@_);

  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $nuser=shift(@_); }

  &log_it("","debug","3","$caller");

  switch ($user_isadmin) {
    case "0" {
      switch ($nuser) {
        case "yes" {
          &log_it("New User is not an admin, not adding to the admin group which is currently $admin_group","debug","2","$caller");
        } case "no" {
          &log_it("User $user Not an admin modifying to a normal account the admin group is currently $admin_group","debug","3","$caller");
          if (@wheel eq 'none') {
            &log_it("No user matching :: $user :: in wheel not adding","debug","3","$caller");
          } else {
            my $logged="false";
            foreach my $admins(@wheel) {
              if ("$admins" eq "$user" ) {
                &log_it("User $user in wheel moving to only users now!","debug","1","$caller");
                system ("$user_mod -g $user_group -G $user_group -s $user_shell $user");
              } else {
                if ("$logged" ne "true") {
                  &log_it("User $user not member of wheel good not doing anything","debug","1","$caller");
                  $logged="true";
                }
              }
            }
          }
        }
      }
    } case "1" {
      switch ($nuser) {
        case "yes" {
          &log_it("New user $nuser is an admin, adding to admin ( $admin_group ) group","debug","2","$caller");
          system ("$user_mod -g $user_group -G $admin_group $user");
        } case "no" {
          if (@wheel eq 'none') {
            &log_it("No user matching :: $user :: in wheel adding this user now","debug","1","$caller");
            system ("$user_mod -g $user_group -G $admin_group $user");
          } else {
            my $user_admin="false";
            foreach my $admins(@wheel) {
              if ("$admins" eq "$user" ) {
                &log_it("User $user already in wheel not doing anything","debug","3","$caller");
                $user_admin="true";
                last;
              }
            }
            if ("$user_admin" eq "false") {
              system ("$user_mod -g $user_group -G $admin_group $user");
              &log_it("User $user not member of wheel adding now","debug","1","$caller");
            }
          }
        }
      }
    } else {
      &log_it("User $user is not an admin nor a normal user account ignoring","debug","2","$caller");
    }
  }
}


sub check_pass {
  my $subname="sub check_pass";
  my $caller=$myname." :: ".$subname;

  my $user=shift(@_);
  ## Checking to see if users password has been updated::
  ## local_pass = $local_pass 
  ## db_pass = $user_pass
  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  &log_it("In check_pass","debug","3","$caller");
  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $user_pass=shift(@_); } 

  ## calling read_cfg from libs::FileHandle.pm, and passing in the shadow file 
  ## so that the password information is read in for comparison purposes. 
  &read_cfg("shadpars","$shad_file","$user");
  my @local_shadow_variables = @{$shad_user{$user}};
  my $local_pass=$local_shadow_variables[0];

  ## MD5_HEX CHECKSUMS created of the passwords for comparison purposes.
  ## The md5_hex of the passwords is not actually used, 
  ## because passwords string can easily be compared against each other.. 
  ## put here just in case.. 

  my $pass_digest=md5_hex($user_pass);
  my $localpass_digest=md5_hex($local_pass);

  &log_it("DB password == $user_pass digest == $pass_digest","debug","3","$caller");
  &log_it("LOCAL password == $local_pass digest == $localpass_digest","debug","3","$caller");

  if ( "$local_pass" eq "$user_pass"){
    &log_it("Passwords $local_pass and $user_pass are the same not updating","debug","3","$caller");
  } elsif ("$local_pass" ne "$user_pass"){
    &log_it("User $user -- Passwords are not the same - updating","debug","1","$caller");
    system ("$user_mod -p \'$user_pass\' $user");
  }
}

sub del_key {
  my $subname="sub del_key";
  my $caller=$myname." :: ".$subname;
  my $user=shift(@_);
  &log_it("In del_key","debug","3","$caller :: sub del_key");
  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $user_path=shift(@_); }

  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  if (-e "$user_path/authorized_keys") {
    unlink("$user_path/authorized_keys");
  } else {
    &log_it("User $user already has the key removed not removing a non existent ssh_key.","debug","1","$caller :: sub del_key");
  }
}

sub enable_user {
  my $subname="sub enable_user";
  my $caller=$myname." :: ".$subname;
  my $user=shift(@_);
  &log_it("In enable_user","debug","3","$caller");
  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $userexp=shift(@_); }

  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  ## calling getpwnam to grab username and group id for new user so chown works !!
  my ($uid, $gid) = (getpwnam($user))[2,3] or &log_it("User $user not in passwd file :: $!","error","1","$caller");
  system ("$user_mod -s $user_shell -u -e $user_expires $user");
}

sub add_user {
  my $subname="sub add_user";
  my $caller=$myname." :: ".$subname;

  my $user=shift(@_);
  #if ("@_" ne '') { my $user=shift(@_); } 
  &log_it("In add_user","debug","3","$caller");

  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  system ("$user_add -g $user_group -p \'$user_pass\' -s $user_shell -m -e $user_expires $user");
  &log_it("Added user $user to system","debug","1","$caller");
}

sub sus_user {
  my $subname="sub sus_user";
  my $caller=$myname." :: ".$subname;

  my $user=shift(@_);
  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $user_path=shift(@_); }
  &log_it("In sus_user","debug","3","$caller");

  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  ## lock the password change the shell to nologin and set the expiry date to todays date.. !
  system ("$user_mod -s $disable_shell -L -e \"$date\" $user");
}

sub del_user {
  my $subname="sub del_user";
  my $caller=$myname." :: ".$subname;

  my $user=shift(@_);
  #if ("@_" ne '') { my $user=shift(@_); } 
  #if ("@_" ne '') { $user_path=shift(@_); }
  &log_it("In del_user","debug","3","$caller");

  ##calling db_populate to populate the variables dealing with the db settings for said user.
  &db_populate("$user");

  ## To delete the user we need to make sure user has been disabled for greater than 90 days (should be 6 months which is roughly 180 days ). 
  ## when user is suspended the shell is set to nologin, password is locked and account set to expiry date of the day it has been suspended.
  ## so first thing we do is read in the shadow file, this contains the expiry date for user.
  ## once we have the expiry date, this is in unix time but in days instead of seconds
  ## GenDate.pm generates uxtime, which is unixtime in seconds, we change this to days so it matches against shadow entry.
  ## then minus the shadow time from the actual time. this will give us the resultant days from suspension and if this is greater than 90 days the account is removed. 

  ## calling read_cfg from libs::FileHandle.pm, and passing in the shadow file 
  ## so that the password information is read in for comparison purposes. 
  &read_cfg("shadpars","$shad_file","$user");

  ## from the shadow file we have the following:
  ## push (@{$shad_user{$shadname}}, $local_pass, $pass_sdate, $pass_bcdate, $pass_acdate, $pass_warn, $pass_expires);
  ## pass_expires is what we want [5]th entry of array

  my @local_shadow_variables = @{$shad_user{$user}};
  my $local_expired=$local_shadow_variables[5];

  my $daytoday=$uxtime/$daytosec;

  my $daysexpired=$daytoday - $local_expired;

  if ($daysexpired > $daystodel) {
    &log_it("User $user has been suspended for more than $daystodel days, Deleting user from the system","debug","1","$caller");
    system ("$user_del $user");
  }
}

sub db_populate {
  my $subname="sub db_populate";
  my $caller=$myname." :: ".$subname;

  my $user=shift(@_);
  ## This populates the below variables from the hash %user_db, which the calling sub can then use.
  ## %user_db is populated from DBCON.pm 
  ## this is called from the main program and should already have populated %user_db
  #my $user="none";
  #if ("@_" ne '') { $user=shift(@_); } 

  my @db_user_variables = @{$user_db{$user}};
  ## reading elements from array of db_user_variables, to grab all relevant user info,
  ## if array ever changes please change these lines.
  $user_pass=$db_user_variables[0];
  $user_sshkey=$db_user_variables[1];
  $user_isadmin=$db_user_variables[2];
  $user_isdel=$db_user_variables[3];
  $user_expires=$db_user_variables[4];
  $user_path="/home/$user/.ssh";
  &log_it("db_user_variables = @db_user_variables -- user_isadmin = $user_isadmin user_isdel = $user_isdel user_expires == $user_expires","debug","3","$caller");
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
# To access documentation please use perldoc UserHandle.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

UserHandle.pm - Automaton  Forensic Auditing Toolkit System

=head1 SYNOPSIS

UserHandle.pm - User Handler

=head1 DESCRIPTION

This Module is a set of functions (sub routines), that handles all of the user manipulation. 
This should not need to be changed, but if anyone feels like improving it, feel free. 
This depends on everything, and most of the variables can be over-ridden from the calling script, so again shouldnt need to be modified. 

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
