#!/bin/bash

list_input_source=$(dirname ${BASH_SOURCE[0]})

. "$list_input_source/type_validation.sh"
. "$list_input_source/../metadata/metadata_parsing.sh"

# input is considered table_name col_amount cols_list vals_list
list_validation () {
	table_name=$1
	col_amount=$2
	shift 2
	rest_count=${#@}
	validate_input_count
	#converting the seperationg to a list explicitly
	declare -a col_list=(${@:1:$col_amount})
	shift $(($col_amount))

	#converting the seperationg to a list explicitly
	declare -a val_list=(${@:1:$col_amount})
	shift $(($col_amount))
	#col_types	
	type_extraction $table_name

	for index in ${!col_list[@]}
	do
		col=${col_list[index]}	
		col_type=${col_types[col]}
		value=${val_list[index]}

		if [[ -z $col_type ]]
		then
			echo "column ${col_list[index]} doesnt exist"
			return 1
		fi
		validated_val=$(validate_type $col_type $value)
		if [[ $validated_val = "NaN" ]]
		then
			echo "$value doesnt match type $col_type of $col"
			return 1
		fi
	done

	echo "valid"
}

validate_input_count () {
	if [[ $(validate_type int $col_amount) = "NaN" ]]
	then
		echo "please enter a valid integer "
		return 1
	fi
	if [ ${#@} -ne $(((2*$col_amount))) ]
	then
		echo "please enter a valid amount of columns with their respective column types"
		return 1	
	fi	
}


