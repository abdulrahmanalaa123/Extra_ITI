#!/bin/bash

table_drop_source=$(dirname ${BASH_SOURCE[0]})


drop_table () {	
	query="$@"
	drop_table_check
	# echo "the table is:$table_name"
	if [[ -n $table_name ]]
	then
		path="$table_drop_source/../Databases/$database/$table_name.csv"
		meta_path="$table_drop_source/../Databases/$database/$database.meta"
		if [[ ! -e $path ]]
		then
			echo "table $table_name doesnt exist"
			return 1
		else
			sed -nr --in-place "/table: $table_name/,/^(=)+$/d" "$meta_path"
			rm $path
			echo "successfuly deleted table: $table_name"
		fi
	fi
}
# can be extracted to helpers and has query as an input 
# instead of using it directly
drop_extraction () {
	main_command=$(echo $query | grep -Eo "^(drop)+[[:space:]]+")
	main_command=${main_command// /}
	#turning the main_command lower_case to standardize syntax
	main_command=${main_command,,}		
}

drop_table_check () {
	#extract table name from the query
	#[[:space:]]+(\w)+[[:space:]]?$'	
	table_name=$(echo ${query// /} | grep -ioP '(?<=droptable).*')
	#remove the extra delimiting which is the bracker
}

