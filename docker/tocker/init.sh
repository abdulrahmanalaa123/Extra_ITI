#!/bin/bash
#the service would be a uuid generated or a hash
#having cgroups with the name of the UUID saving the name to the UUID
tocker_init () {
	BASE_DIR=/var/tocker
	if [[ ! -e $BASE_DIR ]]
	then
		sudo mkdir $BASE_DIR
	#sudo setfacl -dR -m "group:tocker:rwx" $BASE_DIR
		# i cant solve changing the current bash shell
		# as a group or forking the rest of the script inside the group
		# tocker
		#	sudo su -l $USER
	fi
	#location of the all the images created
	OUT_PATH=$BASE_DIR/tocker_images
	if [[ ! -e $OUT_PATH ]]
	then
		 mkdir $OUT_PATH
	fi
	# meta contains the cgroup names or mounted logs
	# some sort of persistent state for the image or entry command fro example
	# would be added under tocker_meta/$image_uuid
	META_PATH=$BASE_DIR/tocker_meta
	if [[ ! -e $META_PATH ]]
	then
		 mkdir $META_PATH 
	fi
	return 0
}

# adding permissions doesnt apply the newgrp to the user and i want to keep
# running the script but using newgrp starts a new shell as well as sudo su -l $USER
# might be a solution here https://superuser.com/questions/272061/reload-a-linux-users-group-assignments-without-logging-out#
set_permissions () {
	sudo groupadd tocker
	sudo gpasswd -a $USER tocker
	#sudo usermod -aG tocker $USER
	sudo chmod g+ws $BASE_DIR
	sudo chown :tocker $BASE_DIR
		
}
tocker_add_image () {
	declare image=$1
	declare id=$(uuidgen)
	echo "$image=$id" |  tee "$BASE_DIR/.ids" > /dev/null 2>&1
	return 0
}

tocker_remove_image () {
	declare image=$1
	 sed -E -i "/$image/d" "$BASE_DIR/.ids"
}

get_id () {
	declare image=$1
	id=$( grep -oP "(?<=$image=)\S*" $BASE_DIR/.ids)
	[ -z $id ] && return 1
	return 0
}
