#!/bin/bash
#the service would be a uuid generated or a hash
#having cgroups with the name of the UUID saving the name to the UUID
ocker_init () {
	BASE_DIR=/var/tocker
	if [[ ! -e $BASE_DIR ]]
	then
		sudo mkdir $BASE_DIR
	fi

	#location of the all the images created
	OUT_PATH=$BASE_DIR/tocker_images
	if [[ ! -e $OUT_PATH ]]
	then
		sudo mkdir $OUT_PATH
	fi
	# meta contains the cgroup names or mounted logs
	# some sort of persistent state for the image or entry command fro example
	# would be added under tocker_meta/$image_uuid
	META_PATH=$BASE_DIR/tocker_meta
	if [[ ! -e $META_PATH ]]
	then
		sudo mkdir $META_PATH 
	fi
	# if its invasive maybe it should be removed
	sudo groupadd tocker
	sudo usermod -aG tocker $USER
	sudo setfacl -dR -m "group:tocker:rwx" $BASE_DIR
	return 0
}

tocker_add_image () {
	declare image=$1
	declare id=$(uuidgen)
	echo "$image=$id" | sudo tee "$OUT_PATH/.ids" > /dev/null 2>&1
	return 0
}

get_id () {
	declare image=$1
	id=$(sudo grep -oP "(?<=$image=)\S*")
	[ -z $id ] && return 1
	return 0
}
