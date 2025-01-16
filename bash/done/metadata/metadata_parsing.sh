
# assuming source execution for looking at current working dir
type_source=$(dirname ${BASH_SOURCE[0]})

#after calling the function you can use the return
# by calling the associative array called col_types
type_extraction () {
	table_name=$1
	meta_source="$type_source/../Databases/$database/$database.meta"
	table_data=$(sed -nr "/table: $table_name/,/^(=)+$/p" "$meta_source")

	
	declare -A ary

	while IFS=": " read -r key value;
	do
		if [[ -n $value ]]
		then
			ary["$key"]="$value"	
		fi
	done < <(echo -e "$table_data");

	# using comma as a seperator and printing out the output of such a list inside an array and looping over them
	# both to assign each col its respective type

	IFS="," read -r -a col_names < <(echo -e "${ary["column_names"]}")
	IFS="," read -r -a types < <(echo -e "${ary["column_types"]}")

	primary=${ary["primary_key"]}

	col_types=()

	col_types["primary"]=$primary
	#using the indirect exapnsion to get the indeces as a space speerated list
	for index in ${!col_names[@]}
	do
		name=${col_names[index]}
		val=${types[index]}
		col_types["$name"]="$val"
	done
}
