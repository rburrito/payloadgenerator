#!/bin/bash


validate_arc(){
echo "Is it 32 or 64 bit? Please choose 32 or 64"
read correct_arc
case  $correct_arc in 
	32|64)
	;;
	*)
	validate_arc
	;;
esac
echo "$correct_arc"
}

validate_arc




#validate_arc() {
#case $architecture in
#        32|64)
#        correct_arc="true"
#        ;;
#        *)
#        echo "$architecture is not one of the options. Please choose 32 or 64 bit."
#        read architecture
#        ;;
#esac
#}

#while [ "${correct_arc}" = "false" ];
#do
#        validate_arc;
#done


