#!/bin/sh 
#
#
###################################################################
#                                                                 #
# Vamegh Hedayati (c) 2010                                        #
#                                                                 #
#   Test Data Gathering Script                                    #
#                                                                 #
#                                                                 #
# This program is free software; you can redistribute it and/or   #
#  modify it under the terms of the GNU General Public License    #
#  as published by                                                #
# the Free Software Foundation; either version 2 of the License,  #
#  or (at your option) any later version.                         #
#                                                                 #
#  This program is distributed in the hope that it will be useful,#
# but WITHOUT ANY WARRANTY; without even the implied warranty of  #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the   #
# GNU General Public License for more details.                    #
#                                                                 #
# You should have received a copy of the GNU General Public       #
# License along with this program; if not, write to the           #
# Free Software Foundation, Inc.,                                 #
# 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.       #
#                                                                 #
#        check http://www.gnu.org/copyleft/gpl.html               #
###################################################################
#
#
#
###################### Global Vars ################################

#checking who this script is currently running as 
UserCheck=`id|awk -F"(" '{print $2}'|awk -F")" '{print $1}'`

# machine identification
System=`uname`
Machine=`uname -a`
SysFol=`uname -n`
Uptime=`uptime`
mPath="/opt/Automaton/audit"


# log path
Systempathexists=`ls $mPath/data|grep $System`
Serverpathexists=`ls $mPath/data/$System/|grep $SysFol`
log_Path="$mPath/data/$System/$SysFol"

GlobeVars()
{
#checking all of the users on the system
UserList=`cat /etc/passwd 2>&1|awk -F":" '{print $1"  "$5"  "$6"  "$7}'`
RootPriv=`cat /etc/passwd 2>&1|grep ":0:"`

# app versions
sshVer=`ssh -V 2>&1`
perlVer=`perl -v|grep v|head -1 2>&1`
apVer=`httpd -v 2>&1`
ipAddy=`/sbin/ifconfig -a 2>&1`

# More security audit
aliasFile=`cat /etc/aliases|grep -v "^#"|grep -v "^$"|grep -v "^$" 2>&1`
checkGroup=`cat /etc/group|egrep -i "(wheel)|(root)"|grep -v "^#"|grep -v "^$"|grep -v "^$" 2>&1`
checkcleanPWD=`cat /etc/passwd|awk -F: '{print $1}'|grep -v "^#"|grep -v "^$"|grep -v "^$" 2>&1`
checkcleanGRP=`cat /etc/group|awk -F: '{print $1" "$NF}'|grep -v "^#"|grep -v "^$"|grep -v "^$" 2>&1`
checkInetd=`cat /etc/inetd.conf|grep -v "^#"|grep -v "^$" 2>&1`
checkXinetd=`ls -l /etc/xinetd.d/ | grep -v total |awk '{print "echo @@@ /etc/xinetd.d/" $NF " @@@: && cat /etc/xinetd.d/" $NF}'|/bin/bash`
checkCron=`ls -l /var/spool/cron/* 2>&1 && cat /var/spool/cron/* 2>&1|grep -v "^#"|grep -v "^$"`
checkEtcCron=`ls -lR /etc/ |grep cron && ls -l /etc|grep cron|grep -v drw|awk '{print "echo @@@/etc/" $9 "@@@" " && " "cat /etc/"$9 "|grep -v ^$" }'|/bin/bash`
checkPorts=`lsof -i 2>&1`
checkSSH=`cat /etc/ssh/sshd_config|grep -v "^#"|grep -v "^$" 2>&1`
routeTableCheck=`netstat -nr`

# File Checking for -- 
exportCFcheck=`cat /etc/exports|grep -v "^#"|grep -v "^$" 2>&1`
fstabCFcheck=`cat /etc/fstab|grep -v "^#"|grep -v "^$" 2>&1`
mailCFcheck=`cat /etc/postfix/main.cf|grep -v "^#"|grep -v "^$" 2>&1`
apacheCFcheck=`cat /etc/httpd/httpd.conf|grep -v "^#"|grep -v "^$" 2>&1`
}

###################################################################
####### Functions to clean #########
root_Check()
{
    if [ "$UserCheck" != "root" ]; then	
	echo ""
	echo "" 
	echo "$UserCheck, "
	echo "please run me as root"
	exit
    fi
}
######################################


### making the required directories ####
func_mkd() {
if [ "$Systempathexists" != "$System" ]; then
`cd $mPath/data && mkdir $System`
`cd $mPath/data/$System && mkdir $SysFol`
elif [ "$Serverpathexists" != "$SysFol" ]; then
`cd $mPath/data/$System && mkdir $SysFol`
fi
}
########################################

########## Loading & running the checks ############################### 
LoadSpecificVars() 
{
if [ "$System" = "SunOS" ]; then
procInfo=`ps -elf 2>&1|awk '{print $3"\t"$12"\t"$13"\t"$16 $17 $NF}'|sort|uniq`
pkgIns=`showrev -p 2>&1`
cpuInfo=`psrinfo -v 2>&1`
memInfo=`prtconf 2>&1|grep Memory`
modInfo=`modinfo 2>&1`
whoSudo=`cat /usr/local/etc/sudoers 2>&1|grep -v "^#"|grep -v "^$"`
initCheck=`ls -l /etc/init.d/ 2>&1|awk '{print $3 " " $4 " " $9 $10 $11 }'`
prtdiag=`prtdiag`
elif [ "$System" = "FreeBSD" ]; then
procInfo=`ps auwx 2>&1|awk '{print $1"\t"$11 $12 $13}'|sort|uniq`
pkgIns=`pkg_info 2>&1| awk '{print $1}'`
cpuInfo=`egrep -i "(CPU)|(cpu)" /var/run/dmesg.boot 2>&1`
memInfo=`egrep -i "(memory)|(Ethernet)" /var/run/dmesg.boot 2>&1`
modInfo=`module_info -m 2>&1`
whoSudo=`cat /usr/local/etc/sudoers 2>&1|grep -v "^#"|grep -v "^$"`
initCheck=`echo "CHECKING RC.CONF" && cat /etc/rc.conf 2>&1 && echo "DONE" && echo "" && echo "CHECKING /USR/LOCAL/ETC/RC.D/" && echo "" && ls -l /usr/local/etc/rc.d/ 2>&1 && echo "DONE" && echo "" && echo "FINALLY CHECKING /ETC/RC.D IF IT EXISTS..." && echo "" && ls -l /etc/rc.d 2>&1 && echo "" && echo "ALL DONE" && echo ""`
elif [ "$System" = "Linux" ]; then
#isSysDeb=`ls /etc|grep debian_version`
#if [ "$isSysDeb" =  " " ]; then 
#echo " "
#echo "Unfortunately only Debian is supported... currently"
#echo "I am exiting now, bye"
#exit
#fi

procInfo=`ps auwx 2>&1|awk '{print $1"\t"$11 $12 $13}'|sort|uniq`
#pkgIns=`dpkg-query -W -f='${Package}\t${Version}\n' 2>&1`
pkgIns=`rpm -qa`
yumSources=`cat /etc/apt/sources.list |grep -v "^#"|grep -v "^$"`
cpuInfo=`egrep -i "(CPU)|(cpu)" /var/log/dmesg && egrep -i "(model_name)|(processor)|(MHZ)" /proc/cpuinfo 2>&1`
memInfo=`egrep -i "(memory)|(Ethernet)" /var/log/dmesg && free 2>&1`
whoSudo=`cat /etc/sudoers 2>&1|grep -v "^#"|grep -v "^$"`
initCheck=`ls -l /etc/init.d/ 2>&1|awk '{print $3 " " $4 " " $8 $9 $10}'`
else 
echo "You are running $System.. I currently do not support this "
echo "I am exiting now, bye "
exit
fi
}
############################################################################

HwInfo() 
{
echo "$SysFol -- Checking the current HardWare Config"
echo ""
echo "Machine Identification: $Machine "
echo ""
echo "Uptime: $Uptime"
echo ""
echo "Processor Info: $cpuInfo"
echo ""
echo "memory/Ethernet Info: $memInfo"
echo ""
echo "Checking the ip address(es) of this Machine: "
echo "Interface info: $ipAddy"
echo ""
echo "Currently running modules: "
echo "$modInfo"
echo ""
}

OsInfo()
{
echo "$SysFol -- Checking the current Software config"
echo ""
echo "Current Process List:"
echo "$procInfo"
echo ""
echo "Current Installed Packages:"
echo "$pkgIns"
echo ""
echo "Current Yum Sources"
echo "$yumSources"
echo ""
echo "Checking Routing table"
echo "$routeTableCheck"
echo ""
echo "Checking prtdiag info for sun boxes"
echo "$prtdiag"
echo ""
echo "Finally Checking the current Startup scripts: "
echo "$initCheck"
echo ""
}

UserInfo()
{
echo "$Sysfol -- Checking User information --"
echo ""
echo "Users that have root-priv"
echo "$RootPriv"
echo "root-priv check complete"
echo ""
echo "Users that have special group-privs:"
echo "$checkGroup"
echo "group-privs check complete"
echo ""
echo "Sudoers-list:"
echo "$whoSudo"
echo "Sudoers-list complete"
echo ""
echo "alias-file Contains the following:"
echo "$aliasFile"
echo "alias-file check complete"
echo ""
echo "All-Users on this system:"
echo "$UserList"
echo "All-user check complete"
echo ""
echo "Checking sshd-config: "
echo "$checkSSH"
echo ""
echo "sshd-config check complete"
echo ""
}

CleanupInfo()
{
echo ""
echo "######################### $SysFol - CHECKING CLEAN UP INFORMATION #########################"
echo ""
echo "*** ROOT PRIVILEGE CHECK ***"
echo "$RootPriv"
echo "*** ROOT PRIVILEGE CHECK COMPLETE ***"
echo ""
echo "*** GROUP PRIVILEGE CHECK ***"
echo "$checkGroup"
echo "*** GROUP PRIVILEGE CHECK COMPLETE ***"
echo ""
echo "*** FULL USER LIST ***"
echo "$checkcleanPWD"
echo "*** FULL USER LIST DISPLAYED ***"
echo ""
echo "*** FULL GROUP LIST ***"
echo "$checkcleanGRP"
echo "*** FULL GROUP LIST DISPLAYED ***" 
echo ""
echo "*** SUDOERS-LIST CHECK ***"
echo "$whoSudo"
echo "*** SUDOERS-LIST CHECK COMPLETE ***"
echo ""
echo "*** SSHD-CONFIG CHECK ***" 
echo "$checkSSH"
echo ""
echo "*** SSHD-CONFIG CHECK COMPLETE ***"
echo ""
echo "*** EXPORTS CONFIG FILE CHECK ***"
echo ""
echo "$exportCFcheck"
echo ""
echo "*** EXPORTS CONFIG FILE CHECK COMPLETE***"
echo ""
echo "*** FSTAB	CONFIG FILE CHECK ***"
echo ""
echo "$fstabCFcheck"
echo ""
echo "*** FSTAB	CONFIG FILE CHECK COMPLETE***"
echo ""
echo "*** POSTFIX CONFIG FILE CHECK ***"
echo ""
echo "$mailCFcheck"
echo ""
echo "*** POSTFIX CONFIG FILE CHECK COMPLETE***"
echo ""
echo "*** APACHE CONFIG FILE CHECK ***"
echo ""
echo "$apacheCFcheck"
echo ""
echo "*** APACHES CONFIG FILE CHECK COMPLETE***"
echo "######################### $SysFol - COMPLETE #########################"
echo ""
}

CheckVersions()
{
echo "$SysFol -- Checking application versions" 
echo ""
echo "ssh version: $sshVer "
echo ""
echo "Perl Version: $perlVer " 
echo ""
echo "Apache Version: $apVer"
echo "done"
echo ""
echo "$Sysfol -- General Security tests now"
echo ""
echo "Is inetd being used ? the list below should be empty"
echo "Checking Inetd: $checkInetd"
echo "done"
echo ""
echo "Checking Cron: $checkCron"
echo "done"
echo ""
echo "Checking /etc/cron* : "
echo "$checkEtcCron"
echo "done"
echo ""
echo "Checking lsof: $checkPorts"
echo "done"
echo ""
}

######################################################################


Main() 
{
echo "Automaton Operating System Audit"
echo ""
echo "Do you wish to log the files or just display on screen"
echo "L to log, any other key to continue without logging"
LoggingOn="L"
if [ "$LoggingOn" = "L" ] || [ "$LoggingOn" = "l" ]; then
root_Check
func_mkd
GlobeVars > $log_Path/OsInfo 
LoadSpecificVars >> $log_Path/OsInfo
HwInfo > $log_Path/HwInfo
OsInfo >> $log_Path/OsInfo
UserInfo > $log_Path/UserInfo
CleanupInfo > $log_Path/CleanupInfo
CheckVersions > $log_Path/VersionChecks
else
root_Check
func_mkd
GlobeVars
LoadSpecificVars
HwInfo
OsInfo
UserInfo
CheckVersions
fi
}

root_Check
Main

