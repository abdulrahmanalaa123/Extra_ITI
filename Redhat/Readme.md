# 17-12-2024

## Linux basic commands
- tty is just an abbreviation for tele type terminal which was called tele type terminal because fo the history of unix which was used because accsesing the terminal was used to be using a window and a keyboard ocnnected to a machine very far away so youre were typing and accessing the machine remotely 
- TLDR tty is just simply a terminal interface 
- tty is a virtual terminal which enables you to run several processes on your machine in different terminals its just like opening a new tab.
- now for tty you can only access that if you have local access to the machine a server youre adminstrating locally or your local machine navigating between tty and the others you use alt+f2 to f6 each given to each f represents a different tty
- to know the current tty you can type tty in your terminal and to swtich from a terminal tty to GUI you press ctrl + alt + f1 and to switch from the GUI to any tty you need to press ctrl + alt + fn with n respective to the tty you want to open 
- the root user is always given the id of 0 and the normal users are given id ranges starting from 1000 and above 
- switch users you type su to switch between users asking to switch from a higher privileged user like root to another low privileged user password prompt isnt required but on the other hand when switching from a user to root a password is required to enter
- to get out of the exited user's terminal you can press ctrl+d or just type exit in the terminal

## FHS
- users you use which have a terminal i presume and can have a home dir are called normal users and their id ranges starts from 1000+
- for system users their ids are reserved from 0 to 1000 system users are dummy users which are given an id range for it to run services in a localized authority scope
- which means the user of service x can only look at its files and isnt authorized to rwx anything outside of its ownership scope unless widened by group level access
### file descriptors
- file types are devices, sockets, dirs, character streaming devices, and block devices as far as i remember
- alright what i understand is a bit scuffed but its what i've got so far its a unique integer defined at runtime which is always 0,1,2 reserved for stdin,stdout,stderr respectively and there is a limit for each process.
- so lets define 3 things the file struct in files.c or files.h i dont remember and the files table in the process and the file lock table(ftable)
- first the file struct:
	- it is the structure of a file which is pointed to by the file descriptor
	- it contains several properties or variables or attributes whatever the fuck its called type (FD_NONE,FD_DEVICE,FD_INODE,FD_PIPE) and a readable and writable flags which determines the current excution process where if its readable then the inode pointer is used which points to the file used which is used only in the FD_INODE (files and dirs) and if writeable an the offset field is used which contains the offset of the current write process.
	- it contains ref in all to show the amount of references currently pointing to this fd and for FD_DEVICE specifically there is a major attribute which i dont understand and dont want to.
	- for FD_PIPE specific there is a pipe pointer which points to the pipe structure which i dont what is it 
	**I understand these things barely i guess its too deep right now should be revisited later**
- second is the files table:
	- the files table is simply initiated in the process initiation which contains the current file descriptors used by this file or processes that calls something specific initiates a new available file descriptor
	- an important file descriptors are inherited by child processes to enable multiple usage managing and locking this shared memory especially when writing is something i wont and cant go deep into
- third and finally is the ftable:
	- the ftable is the table that contains the main files initiated on booting which is used system-wide and are managed by the spin lock as well to manage access and references a file table as well but these are devices, pipes, and normal files used by the system so it needs to be managed
https://www.youtube.com/watch?v=PIb2aShU_H4
https://www.youtube.com/watch?v=oWuVGDese4k
***this part is so scuffed and fucked up wont revisit unless later i just understood file types and what are file_descriptors and thats what i got***
### linux file system
- the root file is called the root file system the root file system can only be edited by the root user and even some files have only read access by the root.
- everything in linux is treated as a file whatever the thing is directory, excutable even file types are a layer above but at the kernel deep down theyre only a file i presume 
#### now explaining the dirs in the root dir there are a couple:
- /bin contains the bins used by the system which is one of the main paths used to define the commands we run where are all the places they could be saved is stored in $PATH environmnental variable
- /etc contains the configuration files of the system for any service or the system itself i think
- /var contains the variable files which means are files that are written to oftenly or that could change over time.
- /dev contains the devices files anything you use that can be presumed as a device is located there, keyboard, mouse, monitor, as well as the storage drivers, etc.
- /home contains the home dirs of all the actual users and not service users which have no home dir and cant login on the machine a new user home directory is populated with files from /etc/skel
- /root contains the home dir of the root user only and with root level privelages only
- /proc proc is a virtual file system which is stored in the memory and not your disk which changes constantly and contains all the running processes the proc is usually managed by the kernel only and cant be accessed by normal users
- /boot is a kernel directory which contains the info or files needed to boot up your system (the kernel boot loader)
- /tmp contains temporary files which are routinely cleaned up or cleaned immediately on system reboot
- /usr contains shared files between the users e.g (fonts, backgrounds, themes, help, etc.)
- /sbin contains the super user binaries which are binaries only accessible by users with adminstrative permissions
- /opt is a dir where some softwares install all of its related info in teh opt file and i dont need to knwo more than that
- /srv is where servers are installed like apache or for example creating an ftp server you'll serve from the /srv files
- /media is where you can access the files located on any removable media 
- /lib , /lib64 contains the libraries needed by applications (header files, actual libraries, etc.) lib and lib64 is 32bits and 64btis libraries
- linux is case sensitive 


# 21-1-2025

## cgroups
- cgroups are based on the big four controllers it is a resource constraining element which limits resources whether its network or cpu or memory or disk
- cgroups controllers can be viewed in the VFS `/sys/fs/cgroup/`
- cgroups resource sharing is done on the parent cgroup cgroups decending from the root directly has total access to the whole cpu resources yet descending further and creating child cgroups will limit such resources if parents were set such a limit
### Cpuset
- the cpu controllers are for example cpuset which is repsonsible for setting the cpu required for handling the process or the number of cpus required to handle the process
#### NUMA
- to explain cpuset you must first understand the NUMA (non uniform memory addressing) to understand you need to first understand what is a UMA (uniform memory address)
- the uma is the standard memory addressing which is used for frequent memory accessing which means a one cpu or socket machine that has memory bound to that cpu
- frequent memory addressing means that if a process or a program is running and it needs to access its stored data on the memory frequently 
- now imagine a server with several cpus managing memory would be difficult without NUMA each cpu accessing the memory would starve the whole system from accessing the memory
- NUMA assigns memory and all the peripherals to a socket or a processor and calls it a numa node
- when a numa node is fully utilized in memory to access the memory in a different numa node it should first call the other socket to access its memory and it cant access it directly
- it decides the most optimum numa node to access using the numa distance you can view the numa distances of your numa using and your numa nodes `numactl --hardware`
- managing a network for example parsing requests coming in on ports configured on different which means managing the single process across different numa nodes and communicating between them through the bus which creates a huge deal of overhead resulting in a cpu overload of a simple network request processing application
- this process is done inside a cpu with different cores which is called context switching a process is running on a core switching up to another during execution.
### Cpuacc
- there is also as well the cpuacc which is cpu accounting which limits the resources taken up by the process limiting the process's using different limits such as cpu shares and quota and period

#### period and quota
- period is the specified period for a cycle of the core to finish all the tasks it has for example the core or cpu has to finish 10 tasks in 1000ms which means evenly distributing without assigning quotas would be distributed for each 100ms max equally
- the quota is set for the process the max amount of time specified from the period  

#### shares
- shares are a numer of shares of each process from the total share pool for example specifyiing that the share pool of the core is 1024 giving 20 processes share of 50 shares means they all have the same privelage or cycle time sharing but for example giving two processes A,B A has a share of 750 and B has a share of 250 means that A has 75% and B has 25% of the total time it can use inside the cycle

#### how they interact 
[Very Neat Explanation](https://stackoverflow.com/questions/55901070/what-is-the-relationship-between-cpu-shares-and-cpu-cfs-quota-us-in-context-of-c)
quoting because i cant explain it any better
```
cpu.share and cpu.cfs_quota_us are working together.

Given a total cpu quota, we should firstly distribute the cpu.share of each cgroup. Then find the cgroups whose exact quota exceeds their cpu.cfs_quota_us, find all such cgroups and keep their quota as their cpu.cfs_quota_us, and collect the exceeded part as unused cpu pool. Distribute these unused cpu pool among other cgroups by cpu.share again, and iterate as above, until no cgroup is exceeding the upper limit.
```

# 24-1-2025

## each controller has its own configuration files for limiting resources related to said resource for example in memory you can define the oom_control or specify the swappiness or create a soft_limit or a hard limit which we will explain and its pretty straight forward and for the cpu as well we only used and most would be used on demand and no need to know all
- files in /cgroups or /proc aren't actually files they're an interface to lower-levels of the OS so you cant edit them using vim or nano you can echo values into them thats why echo was used before rather than just vim and edit the contents

## memory controller
- memory limiting controllers and memory swap limiting controller 
- the limiting factors of memory are size and swap size 
- the OOM killer (OUT Of MEMORY KILLER) will select one of the processes when the memory runs out of space to kill and if this process is system critical for you you should enable auto-restart for example in systemd 
	- oom is determined by the cpu on which to kill to lower the percentage of killing your current process you can edit its oom_score by going into `/proc/$PID/oom_score` the value ranges from -1000 to 1000 the lower the value the lower the chance that the process is killed
- a simple rule for assigning limits of swap and main memory the swap limit cant be less than the memory limit because in case it needs to swap out the whole memory it needs to has space enough to swap such memory 
- for example having a memory limit of 1gb and a swap memory size of 512mb swapping the 1gb into the 512mb would mean loss in memory which doesnt make sense in the eyes of the controller so thats simply the rule


### page memory fault
- The memory address space (the address space is decided by the word size which is determined by the cpu architecture 32-bit, 64-bit) is divided where each page is a contigous block of memory for example 4kb
- swapping out memory is done on pages and not individual bytes

### virtual address space
***(needs to be researched further)***
- each process or application running is assigned a virtual address space mapped to a physical address to the main memory 

## freeze
- the freeze controller is used to freeze a process either by chance or adding the task to a freezed state controller and while running its in a state of thawed can be viewed also by accessing `/sys/fs/cgroups` and modifying `freeze.state`
## block controller
- specify read and write bytes limit or specify read and write iops limit (input output operations)
### block specifications
- to edit into the read write you write the major and minor number of the device youre trying to edit followed by the read limit and the write limit `253:1 1000`
#### major , minor
- you can view the device numbers used in major by viewing `cat proc/devices`
- the major is the driver number for managing the current device you can view it by going into `/dev` and using `ls -l` command you can see the major and minor number seperated by a comma
- the minor is the number of the driver which is only managed by the major driver only
- a combination of these two can be used to uniquely identify the device the system doesnt always use it to identify the device it can be extracted from the inode numbers since its a unique identifier for the device and then the major and minor are extracted after if needed

### testing the limits specified
- they can be tested using the dd operation reading from /dev/zero into a file
- dd is a command that writes on memory and then writes files to disk and you can specify if it writes to disk directly or not you can specify the reading block size and writing block size and the amount of writes and reads


## capabilities and namespaces

### Introduction
- capabilities are specifying the privileges and capabilities of the process which can be changing for example in docker capabilities what is allowed is changing depending on which stage of the process is runnign for example the allowed capabilities are chown at first but when its running it is removed it iwll be explained later but this is a breif of what is coming

- namespaces are isolating the user in its root file system for simulating that its the only user on the machine such as chroot there are types of isolation:
	- user namespaces simulates being the only used in the system
	- process ID namespaces assigning process ids inside the namespaces is independent from the running processes on the system
	- network namespaces the file system has its own network stack , routing tables , firewalls, etc.
	- mount namespaces independent mounting points seen only by the namespace without affecting the host
	- IPC namespaces independent ipc resources
	- Unix time sharing namespace appearing to have different hosts and different domian names on the namespace

# 28-1-2025

## special permissions
- there are three setuid and setgid and sticky bit

- set user id if put on the file and that file is runnable and you have execute privelage in your group or other when ran your user privilages when running the script would be the same as the owner specifying a script with root as its owner then if the script is ran then the user id would be root. 

- permissions of setuid and setgid are specified are S capital and s depedning if the owner or group permission had execute permissions in the beginning 

- if set gid is assigned then the file group permission while running it is the same as the group permissions assigned to it and for directories any file or directory created inside the directory take sthe owner group would be the owner group of said files no matter who created them

- the sticky bit works on programs different than directories where on programs it enables keeping the program loaded on the ram while on directories it disables users in the same group accessing the directory to delete each other's files

## ACLs 
- ACLS also known as access control list is a permission setting command and you can get your current acl using `getfacl ./`
- ACL has rules to be set if read from a file certain checks done to be able to parse the acl file
- adding named ACLS either user or group for example `group:gname:rwx` should be followed by a mask if not specified the mask is specified with the same rules as the group entry `mask:r-x` but these rules are applied automatically if added using the setfacl
- named ACLS if wanted to set no permissions it should be followed with a permision of `user:usr1:---` and not left without a permission parameter
- default ACLS means is an ACL thats applied to all the folders and subfolders by default (idk if its when its created or generally but i presume generally)
- default ACLS has rules as well is that creating a default acl named group using the -d flag for example `setfacl -d -m "group:grp1:r-x" .` automatically generates default original facl which is the `user::rw` `group::rx` `other::r` which corresponds to the `chmod u=rw g=rx o=r` it will end up looking like this
```
user::rw
group::rx
other::r
mask::r
default:user::rw
default:group::rx
default:other::r
default:group:grp1:r-x
default:mask::r-x
```
- masks are added with a bitwise & to the specified permissions to 
- ACL check goes first with the owner,user named user,group named group,other
[Really Useful explained the form in depth and a great link in general](https://documentation.suse.com/sles/15-SP6/html/SLES-all/cha-security-acls.html)

# 1-2-2025

## Creating and formatting file systems
- `lsblk` is used to view all blk devices it gets so from reading the sysfs files on startup (dont know wwhat that means but dont want to go too much in depth)

- and you can view using `fdisk -l` as well to view the available block devices `fdisk is used for manipulating the partition table to divide the disk into logical partitions saved in the partition table in sector 0 of the disk you can view the sectors sizes in fdisk -l`

- mbr partitioning is also known as dos on most operating systems

- The system id in the `fdisk -l` shown as `ID` specifies the partitioning schema is the file system ID (what type of file system is it)

- The default system id on a linux device is a linux type System so it initiates it with a linux file system default 

- fdisk manages disks and not partitions and you can find the current disks using `lsblk` to determine the disks currently available in your machine  and the fdisk is used to format disks and partition them and not file systems


- `fdisk` changes are done in memory and not writtent to the disk unless using the write command to view the `fdisk` command you can use the m command for help

- there is a reserved space other than the partition table done in mbr reserver when starting fdisk when creating partitions can be viewed as reserved with a size of 2048 on an mbr virtual disk idk if its different for other types

- changing partitions in the disk the kernel needs to re read the partition table of said disk you can do so using `partprobe /dev/(disk name)`

- `mkfs` used to create a file system done on a partition either a primary or logical partition and depending on the file system there is a default block size for example in ext4 the default is 4kb block size where each block represent an inode number

- when making the file system for your partition it creates whats called as `superblocks` which are copies and redundancies of your inode table reserved in case of failure of said blocks storing the inode table (the metadata data about the file system created)  

- `dd if=inputfile of=outputfile bs=blocksize count=count of blocks needed to be writted` 

- using dd with /dev/random as the inputfile and dd with /dev/zero and outputting into a file then the random wont make uniform characters or uniform size for each block and the output is outputted as a 100mb unicode data but saved as ansi encoding whcih specifies much lower size and max size for each character conforming to a lower size overall

- you can overwrrite and format a partition using dd and using dev 0 and writing to the `dev/partitionname` 

- mounting is done to enable the disk or partition to be viewed inside the file system or be used as part of the file directory and mounting is mounting the partition to the selected location of the file system writing to said directory will write to said partition there are several types of mounting but this is the basic idead

- you can use `df -h` to view the current file system and where each is binded to 
- using `unmount dirname` would detach the partition 

- `dumpe2fs` can be used to view everything about the information of the file system you're querying which works on ext2,ext3,ext4 

- `e2fsck` checks the file system for issues and filesystem checks need to happen while being unmounted and you preferrably shouldnt efscheck while being mounted becaues it might corrupt the data while being run 

- filesystem checks checks the inode tables it doesnt actually check the whole blocks of the filesystem

- always backup your data you can do so by using `dd if=/dev/partitionname of=anylocation` 

## Mounting file systems
- mounting means linking files or directories allows access to the said partition
- the shutdown process for example unmounts the root file system from your system partition

- mounting a partition to the root file system and then mounting another to a child directory specifies the max limit of the child directory to that of its partition and not the root file limit and writing to it is completely offloaded from the root file system main partition

- mounting is done heirarchial which means mounting two devices to the same directory the limit given and the writing done is done to the latest mounted device

***difference between primary and extended and logical partitions?***

- extended takes up 1 of the 4 primary ids

- you cant format the file system using mkfs you can only format the logical partitions inside the 

- using extended file system you can create inside both logical and primary partitions

# 12-2-2025

## Cgroups v2 with systemd
- systemd controls the resources of the whole machine slicing it into 3 parts
- `system` slice (slice of the resources used by the system to be initiated)
- `user` slice (slicing the resources across the users on the machine)
- `machine` slice (virtual machine slices across the machines initiated)
- limits by default or slices by default isnt limited unless specified and its service specific
- `systemd-cgtop` shows you the control groups resources across all the cgroups running on your system
- `systemd-cgls` is the command for listing the available cgroups currently available or activated i presume on your system
- `systemctl show /` which shows the root cgroup and all of its contents
- allowing cgroups on your services you must first enable accounting on your resource that you want to limit
- you can find the state of the current Accounting vlaues using `systemctl show / | grep -i accounting` 
- to change the value of the accounting property of a resource you can use `systemctl set property / xAccounting=true` here we specified the "/" to specify that its enabled in the root cgroup that spans the whole system resources

# 13-2-2025

## MakeFile
- actually i have nothing to say but this great [resource](https://makefiletutorial.com/) for makefiles explaining the makefile process in parsing the makefile

## Sudoers file
- running a command with sudo setting environment variables inside it would reset just right after the command is ran and that is set with the defaults inside the sudoers file with `env_reset`
- the `secure_path` specifies the path of the commands which requires sudo user privelage
- [DIgital Ocean Basic reference for editing](https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file)
- the syntax for the sudoers can be found inside the digital ocean link but yet a quick sum up is 
```
user or %group --> user or group which are specified by the rule
ALL --> is the matching the hostname to specify all hosts you can use ALL which is more commonly used
=
(
ALL --> run as user defaults to root if not specified
:
ALL --> run as group defaults to root if not specified
)
command tags 
command --> location of the command specified

```
- [link of the man with refernce to the tags](https://www.sudo.ws/docs/man/sudoers.man/#Tag_Spec)


