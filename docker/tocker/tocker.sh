#!/bin/bash

. ./init.sh

tocker_pull() {
	declare image=$1
	declare image_name_modified=${image/:/_}
	
	if [[ -n $(sed -nE '/docker.io/p' ~/.docker/config.json) ]]
	then
		declare out_path="$OUT_PATH/$image_name_modified.tar.gz"
		declare temp_cont=$(docker create $image)
		docker container export $temp_cont |  tee $out_path > /dev/null 2>&1
		docker container rm $temp_cont > /dev/null
		if [[ -e $out_path ]]
		then
			declare output_dir=${out_path%.tar.gz}
			mkdir $output_dir
			 tar -mxf $out_path --directory=$output_dir --no-same-owner --no-same-permissions
			if [[ $? -eq 0 ]]
			then
				rm $out_path > /dev/null 2>&1
				rm .dockerenv > /dev/null 2>&1
				tocker_add_image $image_name_modified
			fi
		fi
	else
		echo "please login into docker first"
	fi
}

tocker_ps () {
	declare out=$( grep -oP ".+?(?==)" $BASE_DIR/.ids)
	echo -e ${out/$'\n'/$'\t'}
}

tocker_init
tocker_pull alpine:latest
