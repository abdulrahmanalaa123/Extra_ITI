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
