#!/bin/bash

columns_validation=$(dirname ${BASH_SOURCE[0]})
. "$columns_validation/../metadata/metadata_parsing.sh"

#column_exists table_name col1 col2 col3
column_exists () {
	table_name=$1
	shift
	col_list=$@
	
	type_extraction $table_name

	for col in ${col_list[@]}
	do
		if [[ -z ${col_types[col]} ]]
		then
			echo "column ${col} doesnt exist in table ${table_name}"
			exit 1
		fi
	done
}

