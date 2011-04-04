package libs::CMDHandle;
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
use Pod::Usage;
#################################################
# My Modules
##
# All provided in the ./libs directory
##
use libs::GenDate;
use libs::Colour;
use libs::LogHandle;
#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT   = qw(cmd_handle $opt_D $opt_C $opt_c $opt_L $opt_h $opt_i $opt_f $opt_d $opt_u $opt_p $opt_P $opt_v $cfg_file $db_name $db_hid $db_host $db_user $db_pass $dbi $db_port $max_fsize $image_dd $image_size $image_dd_store $image_compress $opt_s $opt_S $opt_I $opt_Z $opt_T $opt_E $opt_m $opt_M $opt_H $use_mail $mail_to $mail_from $mail_host $remote_host);
use vars qw($opt_D $opt_C $opt_c $opt_L $opt_h $opt_i $opt_f $opt_d $opt_u $opt_p $opt_P $opt_v $cfg_file $db_name $db_hid $db_host $db_user $db_pass $dbi $db_port $max_fsize $image_dd $image_size $image_dd_store $image_compress $opt_s $opt_S $opt_I $opt_Z $opt_T $opt_E $opt_m $opt_M $opt_H $use_mail $mail_to $mail_from $mail_host $remote_host);
#################################################
# Variables Exported From Module - Definitions
##
$opt_D='';
$opt_C='';
$opt_c='';
$opt_L='';
$opt_h='';
$opt_i='';
$opt_f='';
$opt_d='';
$opt_u='';
$opt_p='';
$opt_P='';
$opt_v='';
$opt_s='';
$opt_I='';
$opt_S='';
$opt_Z='';
$opt_T='';
$opt_E='';
$opt_m='';
$opt_M='';
$opt_H='';
$cfg_file='/etc/Automaton/automaton.cfg';
$db_name='';
$db_hid='';
$db_host='';
$db_user='';
$db_pass='';
$dbi='';
$db_port="3206";
$max_fsize='';
$image_dd='no';
$image_size='';
$image_dd_store='';
$image_compress='';
$use_mail='';
$mail_to='';
$mail_from='';
$mail_host='';
$remote_host='';
#################################################
# Local Internal Variables for this Module
##
# SCRIPT VERSION AND NAME INFORMATION 
##
my $ScriptVer="v0.33";
my $ScriptTitle="Automaton Framework";
my $Name="Vamegh Hedayati";
my $modDate="2010";
my $modName="Vamegh Hedayati";
my $scriptName="Automaton";

## INIT VARS
my $user= $ENV{'USER'};
my ($uname, $upass, $uid, $ugid, $uquota, $ucomment, $ugcos, $udir, $ushell, $uexpire) = getpwnam("$user");
## set this to a decent value to allow for proper alignment -
## max no. of characters you are probably going to encounter.
my $nLen = 50;
my $myname="module CMDHandle.pm ";
#################################################
#  Sub-Routines / Functions Definitions
###
# This is the actual Body of the module 
##

&make_date;
#&log_loc;

$Getopt::Std::STANDARD_HELP_VERSION = 0;
$Getopt::Std::STANDARD_HELP_VERSION = 1;
## Full list of currently supported command line switches
getopts('v:s:E:m:M:H:I:S:Z:T:L:h:i:d:p:u:P:f:cCD') || pod2usage(2);

############ COMMAND LINE SETUP #################
############ & INITIALISE SCRIPT ################
# --help output
##
sub main::HELP_MESSAGE {
# arguments are the output file handle,
# the name of option-processing package, its version, and the switches string
## idea and design taken from linblock.pl script
  pod2usage( { -exitval => "1", -output => $_[0], -verbose => 1} );
  pod2usage(1);
}

#### --version output
sub main::VERSION_MESSAGE {
  print $blue."\n\t$ScriptTitle".$yellow." - ".$blue."$ScriptVer\n".$reset;
  print $blue."\tCreated by ".$yellow."$Name\n";
  print $blue."\tLast modified by ".$yellow."$modName ".$blue."at ".$cyan."$modDate \n";
  print $blue."\tCurrent Date: ".$yellow." $date\n";
  print $blue."\tCurrent USER is ".$yellow."$user\n";
  print $blue."\tCurrent USER home is ".$yellow."$udir";
  print $reset."\n\n";
}


sub cmd_handle {
  my $subname="sub cmd_handle";
  my $caller=$myname." :: ".$subname;
  ##
  if ($opt_C) {
    &Colour(1);
    &log_it("Colour settings enabled","debug","1","$caller :: using -c adding colour");
  }

  if ($opt_v ne '')  {
    &log_it("opt_v currently $opt_v","debug","3","$caller :: using -v");
    pod2usage("Error: verbose (-v) value outside of range, type --help for correct usage options") if (("$opt_v" > "3") or ("$opt_v" < "1"));
    $globlev=$opt_v;
  }

  if ($opt_s ne '') {
    &log_it("opt_s currently $opt_s","debug","3","$caller :: using -s");
    pod2usage("Error: max file size (-s) value outside of range, type --help for correct usage options") if (("$opt_s" > "10000") or ("$opt_s" < "1"));
    $max_fsize=$opt_s;
  }

  if ($opt_E ne '') {
    &log_it("You have chosen to specify email details manually, for help type --help or perldoc Automaton","debug","1","$caller :: using -E");     
    pod2usage("Error: Send emails can either be yes or no, type --help for correct usage options") if (("$opt_E" ne 'yes') and ("$opt_E" ne 'no'));
    $use_mail=$opt_E;
    switch ("$use_mail") {
      case("yes") {
        &log_it("Enabling the Mail Subsystem, use_mail is $use_mail","debug","3","$caller :: using -E $use_mail");
        if (defined($opt_m)) {
          $mail_to=$opt_m;
          &log_it("Mail to address set to $mail_to","debug","3","$caller :: using -m $mail_to");
        }
        if (defined($opt_M)) {
          $mail_from=$opt_M;
          &log_it("Mail from address set to $mail_from","debug","3","$caller :: using -M $mail_from");
        }
        if (defined($opt_H)) {
          $mail_host=$opt_H;
          &log_it("Mail Host set to $mail_host","debug","3","$caller :: using -H $mail_host");
        }
      } case("no") {
        &log_it("Disabling the Mail Subsystem, use_mail is $use_mail","debug","3","$caller :: using -E $use_mail");
      } else {
        &log_it ("Error: A correct value was not passed to the use_mail routine","error","1","$caller");
      }
    }
  }
    
  if ($opt_I ne '') {
    &log_it("You have chosen to specify image details manually, for help type --help or perldoc Automaton", "debug", "1", "$caller :: using -I");     
    pod2usage("Error: Image can either be yes or no, type --help for correct usage options") if (("$opt_I" ne 'yes') and ("$opt_I" ne 'no'));
    $image_dd=$opt_I;
    if ("$image_dd" eq "no"){
      &log_it("Not creating dd images as requested, opt_I is $opt_I - image_dd is $image_dd","debug","3","$caller :: using -I no");
      ##$max_fsize $image_dd $image_size $image_dd_store $image_compress
    } elsif ("$image_dd" eq "yes") {
      &log_it("Creating dd images as requested, opt_I is $opt_I - image_dd is $image_dd","debug","3","$caller :: using -I yes");
      
      if ("$opt_T" ne '') {
        &log_it("opt_T currently $opt_T","debug","3","$caller :: using -T");
        pod2usage("Error: Image storage (-T) can either be yes or no, type --help for correct usage options") if (("$opt_T" ne 'yes') and ("$opt_T" ne 'no'));
        $image_dd_store="$opt_T";
      }

      if ("$opt_S" ne '') {
        &log_it("opt_S currently $opt_S","debug","3","$caller :: using -S");
        pod2usage("Error: Max image size (-S) value outside of range, type --help for correct usage options") if (("$opt_S" > "10000") or ("$opt_S" < "1"));
        $image_size="$opt_S";
      }

      if ("$opt_Z" ne '') {
        &log_it("opt_Z currently $opt_Z","debug","3","$caller :: using -T");
        pod2usage("Error: Image Compression (-Z) can either be yes or no, type --help for correct usage options") if (("$opt_Z" ne 'yes') and ("$opt_Z" ne 'no'));
        $image_compress="$opt_Z";
      }
        
    } else {
      &log_it ("Error: A correct value was not passed to the dd image creation routine","error","1","$caller");
    }
  }

  if ($opt_D) {
    &log_it("Not logging to file as requested","debug","1","$caller :: using -D");
    $log_file="none";
  } elsif ($opt_L =~ /(\w+)/) {
    $log_file=$opt_L;
  } else {
    &log_it("Writing to $log_file, since none specified", "debug", "3", "$caller :: using -L");
  }

  if ($opt_c) {
    &log_it("You have chosen to specify details manually, for help type --help or perldoc Automaton", "debug", "1", "$caller :: using -c");
    $opt_c="true";

    #if ($opt_d =~ /(\w+)/;
    #pod2usage("Error: host(-h), database(-d), port(-P), username(-u) and password(-p) must be specified if specifying Command Line(-c)") if(!$opt_h && !$opt_d&&!$opt_P&&!$opt_u&&!$opt_p);

    if (!$opt_h or !$opt_d or !$opt_P or !$opt_u or !$opt_p or !$opt_i) {
      pod2usage("Error: host(-h), host_id (-i), database(-d), port(-P), username(-u) and password(-p) must be specified if specifying Command Line(-c)");
    } else {
      $dbi='mysql';
      $db_name=$opt_d;
      $db_host=$opt_h;
      $db_user=$opt_u;
      $db_pass=$opt_p;
      $db_port=$opt_P;
      $db_hid=$opt_i;
      &log_it("db_hid = $db_hid, db_user = $db_user, db_pass = \'$db_pass\', db_name = $db_name, db_host = $db_host, dbi = $dbi, db_port = $db_port", "debug", "1", "$caller :: using -c");
      #&db_connect();
      #&check_user();
    }
  } elsif ($opt_f=~ /(\w+)/) {
    &log_it("opt_f = $opt_f", "debug", "1", "sub cmd_handle :: using -f");
    $cfg_file=$opt_f;
    &log_it("Reading in cfg file - $cfg_file ", "debug", "3", "$caller :: using -f");
    #&read_cfg();
    #&db_connect();
    #&check_user();
  } else {
    #&db_connect();
    #&check_user();
    $opt_f="none";
    &log_it("using default cfg $cfg_file", "debug", "3", "$caller");
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
# To access documentation please use perldoc CMDHandle.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

CMDHandle.pm - Automaton FrameWork: Forensic Auditing Toolkit 

=head1 SYNOPSIS

Command Line options Handler 


=head1 DESCRIPTION

This is a sub-routine (function) That handles all of the command line arguement processing.
All of the command line options are optional and dont need to be used.

=head1 OPTIONS

The command line options are as follows:

=over

=item -C I<add colour>

Uses Term::Ansicolor to colourise the logging. If not specified, no colour is output. 

=item -D I<dont log to file>

Doesnt log to file, instead outputs everything to the command line.
With this specified -L will be ignored 

=item -s I<Maximum File Size>

This determines the maximum size of the directory that can be stored. 

It is advisable to set this via the configuration file, but this command line option is provided just in case.  

The permitted range is as follows:

I<1> Minnimum Value -C<(-s 1)>

I<2> Maximum Value  -C<(-s 10000)>

This is in MegaBytes, so any value between 1MB to 10,000MB is acceptable, The default value is 100MB. 

The larger this is set,

* the more storage space that will be required 

* the more processing time that will be needed.

Please use this with caution.

=item -I I<Create DD Images>

Specifies that DD Images should be created. 

Warning this adds a huge processing burden on the machine being imaged, use this with caution
This is not recommended.

The only permitted values are:

I<1> Create DD Image -C<(-I yes)>

I<2> Do not create DD image -C<(-I no)>

These are the only 2 options that this command line will accept. 

Please use with extreme caution as the burden on your infrastucture will be greatly increased.

Once this is specified , the following options can also be set:

Store Image Files -C<(-T)>

Maximum Image Size -C<(-S)>

Compress Images -C<(-Z)>

=item -T I<Store Image Files>

This can only be set if -I is specified above, otherwise the configuration file value is read in. 

This is not recommended as it takes up far too much storage space and should only be used if this feature is really needed.

The only permitted values are:

I<1> Store image files -C<(-T yes)>

I<2> Do not store image files -C<(-T no)>

These are the only 2 options that this command line will accept 

=item -S I<Maximum Image Size>

This can only be set if -I is specified above, otherwise the configuration file value is read in. 
The permitted range is as follows:

I<1> Minnimum Value C<(-S 1)>

I<2> Maximum Value  C<(-S 10000)>

This is in MegaBytes, so any value between 1MB to 10,000MB is acceptable, The default value is 100MB. 
The larger this is set,
* the more storage space that will be required 
* the more processing time that will be needed.
Please use this with caution.

=item -Z I<Compress the DD Image>

This can only be set if -I is specified above, otherwise the configuration file value is read in. 
Please be warned this is highly recommended, but will use more processing time on the Automaton Controller

The only permitted values are:

I<1> Compress the image files C<(-Z yes)>
I<2> Do not compress the image files C<(-Z no)>

These are the only 2 options that this command line will accept. 

=item -c I<command line input>

Specifies that all database values will be specified from command line.  If you specify this you need to specify the following:

hostname C<(-h)> 

port C<(-P)> 

database C<(-d)>

username C<(-u)> 

password C<(-p)> 

database host_id C<(-i)> 

Along with the mentioned flags,  this will not work without all of the above information

=item -L I<LOGGINGn>

Specifiy where to log to. If not specified logs to default location /var/log/Automaton/automaton.log.<date>

=item -h I<database host>

Specify which database host to connect to, used when the -c option is specified 

=item -d I<database>

Specify which database to use, used when the C<(-c)> option is specified.

=item -i I<databse host_id>

Specify which host_id to use, used when the C<(-c)> option is specified

=item -u I<database username>

Specify Username to connect to the database used when the C<(-c)> option is specified

=item -p I<database password>

Specifiy password to connect to the database with.  used when the C<(-c)> option is specified

=item -P I<database port>

Specifiy port to connect to the database.  used when the C<(-c)> option is specified

=item -f

Specify a different config file to use default - /etc/Automaton/automaton.cfg

=item -v 

Verbosity Level

I<1> verbosity low C<(-v 1)>

I<2> Verbosity medium C<(-v 2)>

I<3> Verbosity High C<(-v 3)>

=item --help

Print command line options summary.  For more detailed help, type C<perldoc -F Automaton>.

=item --version

Prints the version information.

=back

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
