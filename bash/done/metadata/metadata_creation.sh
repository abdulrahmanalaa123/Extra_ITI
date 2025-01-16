#!/bin/bash

creation_source=$(dirname ${BASH_SOURCE[0]})
. "$creation_source/../validation/type_validation.sh"

# metadata_creation needs to be ran inside the source of database 
# assuming it wont be ran unless you're connected where cd'd inside the database
metadata_creation () {
	# this should be turned into a module on its own but not right now	
	table_name=$1
	col_amount=$2

	shift 2
	rest=${#@}
	create_validate_input
	
	if [[ $? -eq 1 ]]
	then
		return 1
	fi
	#converting the seperationg to a list explicitly
	declare -a col_list=(${@:1:$col_amount})
	shift $(($col_amount))

	#converting the seperationg to a list explicitly
	declare -a val_list=(${@:1:$col_amount})
	shift $(($col_amount))
	
	primary_index=$1
	metadata_string=$(printf "================\ntable: $table_name\n")

	col_string="${col_list[@]}"
	col_string=${col_string//[ ]/,}
	val_string="${val_list[@]}"
	val_string=${val_string//[ ]/,}

	metadata_string+=$(printf "\ncolumn_names: $col_string\n")
	metadata_string+=$(printf "\ncolumn_types: $val_string\n")

	add_primary	

	if [[ $? -eq 1 ]]
	then
		return 1
	fi
	meta_path="$creation_source/../Databases/$database/$database.meta"
	echo -e "$metadata_string" >> "$meta_path" 

}

create_validate_input () {
	validation=$(validate_type int $col_amount)
	if [[ $(validate_type int $col_amount) = "NaN" ]]
	then
		echo "please enter a valid integer "
		return 1
	fi
	if [[ $rest -ne  $(((2*$col_amount)+1)) ]]
	then
		echo "invalid amount of types with number of columns"
		return 1
	fi	
}


add_primary () {

	if [[ $(validate_type int $primary_index) != "NaN" ]]
	then
	if [[ $primary_index -ge  0 ]] && [[ $primary_index -lt $col_amount ]]
	then
		metadata_string+=$(printf "\nprimary_key_index: $primary_index\n")	
		metadata_string+=$(printf "\nprimary_key: ${col_list[primary_index]}\n")	
	else
		echo "please enter a valid primary key index"
		return 1
	fi
	else
		echo "please enter a valid primary key index starting from 0"
		return 1
	fi

}


