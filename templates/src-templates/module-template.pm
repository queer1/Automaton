package libs::<MODULE_NAME>;
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
use libs::LogHandle;
#################################################
# Exporting variables out of module
##
use vars   qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(&db_connect &db_gather %user_db $username $passwd $ssh_type $ssh_key $ssh_mail $is_admin $is_deleted $expires);
use vars qw(%user_db $db_db $db_hid $db_host $username $passwd $ssh_type $ssh_key $ssh_mail $is_admin $is_deleted $expires);
#################################################
# Variables Exported From Module - Definitions
##
#################################################
# Local Internal Variables for this Module
##
my $myname=":: module <MODULE_NAME>.pm";
my $caller="$myname";
#################################################
#  Sub-Routines / Functions Definitions
###
# This is the actual Body of the module 
##

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
# To access documentation please use perldoc <MODULE_NAME>.pm, This will provide 
# the formatted help file for this specific module 
##
#################################################
#
__END__

=head1 NAME

<MODULE_NAME> - Automaton Framework: Forensic Auditing Toolkit

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
