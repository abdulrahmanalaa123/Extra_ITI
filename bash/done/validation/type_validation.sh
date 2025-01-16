#!/bin/bash


validate_type () {
	parameter_type=$1
	shift
	if [[ $parameter_type =~ ^(int|string|float)$ ]]	
	then
		case $parameter_type in
		int)
			#rpelacing all 0-9 digits with nothing so if its an empty string so its not an integer
			if [[ -n "${@//[0-9]}" ]]
			then
				echo "NaN"
			else
				echo $@
			fi
			;;
		float)
			#finding what's after the dot by deleting whats in the front
			after_dot=${@##*\.}
			#finding what's before the dot by deleting whats in the end
			before_dot=${@%%\.*}

			#after_dot and before_dot not empty so they have numbers 
			if [[ -n "$after_dot" ]] && \
			[[ -n "$before_dot" ]] && \
			[[ ! -n "${after_dot//[0-9]}" ]] &&  [[ ! -n "${before_dot//[0-9]}" ]];
			then
				echo $@
			else
				echo "NaN"
			fi
			;;
		*)
			echo $@
			;;
		esac

	else

		echo "please enter a valid type out of int | string | float"
		exit 1
	fi
}

