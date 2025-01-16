#!/bin/bash
column_type_src=$(dirname ${BASH_SOURCE[0]})

. "$column_type_src/metadata_parsing.sh"

#you can use type_list after using the columns_extraction
#although its useless after figuring out you can use col_types rightaway
#but its here for convenience
columns_extraction () {

	table_name=$1
	shift
	col_list=($@)

	type_extraction $table_name
	echo $col_types

	declare -a type_list
	#col_types
	for elem in ${col_list[@]}
	do
		if [[ -z ${col_types[$elem]} ]]
		then
			echo "column $elem doesnt exist"
		fi
		type_list+=("${col_types[$elem]}")
	done

	echo -e "$type_list"
}

