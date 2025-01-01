# 22-12-2024

# apache basics 

## apache general knowledge 
- http uses port no. 80 and https uses 443
- apache's core feature was that it can host multiple sites using the same ip address eg. from the same machine 
- a ton of modules were made for apache web server that enables a ton of features such as auth, compression, etc.
- what gave apache a huge edge before is that one of the first that supported php

# 27-12-2024

## apache configurations
- the main configuration of httpd exists inside the /etc/conf/httpd.conf file 
- the main configuration of httpd is used on the main server hosted on /var/www/html while the virtual servers or websites are hosted from different locations so just keep in mind that the basic configuration is the configuration for the basic website only
### Directives
- The directive <listen> informs the server to listen on which port number whihc is kinda straightforward
- The directive <ServerRoot> informs the configuration file on where to count as the root directory inside the file for example if i said the serverRoot is "/etc"
then any path i put inside the configuration would be prefixed by /etc/"directoryName"
- the directive <Include> is used to modularize configuration files and reduce the amount of configurations inside the main config file and regexes or wild cards can be also used for example in the main config file has the line
```
Include conf.modules.d/*.conf
```
which includes any file ending with .conf inside conf.modules.d inside /etc/httpd /etc/httpd/conf.modules.d/\*.conf
- <User> directive is put in the global config to specify the service user any server either main or virtual will run on and <Group> will specify the group as well 
#### Main server configs

- The directory block config in the main server config is just like chrooting ftp users
```
<Directory />
    AllowOverride none
    Require all denied
</Directory>

```
this will basically deny access of the root directory by any user  
- <DocumentRoot> directive specifies the directory of which the main server will serve it files out from
- you can see that access for /var/www is allowed for anyone which can be changed but its allowed for all by default noting that helps in understanding the difference between the root directory denying access and allowing access only for the /var/www 

# 29-12-2024

- the <Ifmodule> directive only checks if the module is loaded or not as a conditional check if it exists then the requested directive inside is ran 
- the <TypesConfig> directive sets the location of the mime type file which tells the server which file types to configure for example assinging the pictures with extensions of jpg,png,webp as images to be treated as images inside the server
- <AddType> is a directive used to override or add mime configuration to the loaded typesconfig file 
- <IncludeOptional> is just an include statement but it is optional which means when no modules are found for your expression it fails silently wiht no erors and doesnt halt running
- Including external configuration files they are included alphabetically ordered which means the module with the name 00 will be added before 01 so 01 will have precedence if it includes overriding and if it has conflicting configurations with 00 this info is good to know for debugging purposes of the configurations of the apache server

## User-sepcific directories
- the main use of user specific directories is to enable different users on the same machine to have their own hosts directed to them only 
- Using UseDir followed by enabled or disabled and a user space seperated list will enable and disable accessing user directories for the user/s specified 
- UserDir is enabling the access to user home directory pubilc html files and are only accessed by accessing the home of the user for example:
```
# creating a user named saso
sudo useradd saso
sudo passwd saso 

# creating a public html file in the home dir of saso
su - saso

# public_html is the default name inside the userdir.conf you can name it 
# whatever you want 
mkdir public_html 

# adding any files inside will be visible to anyone trying to access
touch visible.html

# keep in mind you need to specificy that /home/saso should have execute access for others for the apache service to be able to see the folder otherwise anyone trying to access <ipaddress>/~/saso/public_html will have a forbidden error
# and the public_html dir should have read and execute access
chmod o+rx ~/public_html / or absolute path of "/home/saso/public_html"
chmod o+x /home/saso
``` 


## Virtual hosts

### Types of virutal hosting
- IP level virtual hosting which maps differnet ip addresses to different files on the same machine this could be done on machines with several network interfaces or several network virtual interfaces as well as the host can open one socket for all ip addresses hosted on it or oepn a socket for each ip address this is said to be discarded due to the overhead of assigning ip addresses to each of the websites and there is mostly not a good reasoning to set it up since it exhausts ip addresses as well.
- IP virtual hosting is useful when assigning a differnet ssl certificate with different security measures needed for the different domains

- Named virtual hosting is the redirecting  of the user on the same ip using different domain names whcich is much simpler to set up and si considered to be oene of the main powers of apache one of the caveats of doing such a thing is configuring the certificates for such websites to include all of these domain names added because certificate signing doesnt see while initiating the handshake the domain name (dont know the inner workings specifically just know that it is kind of the standard method in creating a virtual host) 


### systemctl vs services
- the difference between services and systemctl are both methods to initiate and stop services but in case of systemctl not existing services is a much better option than initd or initctl on its own since its considered a layer above both services since it utilizes both and utilizes both for different operations done on services
- in the presence of systemctl its not much of a difference or at least of what i know about it services includes systemctl when it exists on the system and one of the benefits that i know is that clears open sockets when stopping a service using systemctl it doesnt clean up the ports 
- ofcourse there is more to that but thats all i want and need to know about.

### initiating a named host instead of the default and adding a new one 
- first you need to add a host-conf and its best if you add them using a numbering system to avoid any conflicts and be able to visualize order of loading or execution w/e its called

```
# create a file called 00-replace_host.conf

touch /etc/httpd/conf.d/00-replace_host.conf 

# vim into the file and add the virtual host directive specifying serverName serveralias and document root,etc.
<VirtualHost __default__:80>
        Require all granted
        DocumentRoot /srv/virtual/za3bola
        ServerName www.za3bola.com
        ServerAlias za3bola.com *.za3bola.com
</VirtualHost>

<Directory /srv/virtual/za3bola>
        Require all granted
</Directory>

```
- the `__default__ directive` and `* directive` specifies that the default serving on the ip with port 80 redirects to that new directory instead of the original directory you can specify the ip address instead of the * to use ip based addressing only if the ip addresss exists on the network interfacce you have
- `Directory /srv/virtual/za3bola` specifies the access to the directory where the virtual host is served from 
- since all are mapped to the same ip address for example two domains domains are served with order of precedence either in the config files or the same file it looks for hosts with the given ip address and on the first occurence it is served
- `NameVirtualHost` is a deprecated directive no need to be used since apache 2.4 because 

# 1-1-2025

## SSH and TLS and HTTPS and ssl and diffie hellman (How it is all related)
- TLS is the first step in both ssh and HTTPS after the tcp connection is established to establish a secure connection
- Alright so first diffie hellman is a key exchange algorithm used to send a symmetric key between two clients or a client server which is used in TLS encryption specifically starting from TLS 1.3 
***what i dont understand if it is used to decrypt right away or passed through KDF (key derivation function)*** 

### Now what is SSL and certifcates and certificates are only used in https
- well the certificate has 2 things a public ccertificate which contains the public key and a private key which is generated from random bits on the processor which are more randomized and efficient depending on the processes running on the server enables more randomization to occur
- SSL is originally a protocol for encrypting data sent throughout the network like TLS and was replaced by it but the SSL certificates are still in use and people still to this day SSL/TLS are used interchangeable but the protocol of sending is TLS and the certificates are SSL
- certificates are generally signed by a certified author which could be found on your browser or your host and if its signed by them this informs the browser to trust the certificate author's public key which is in turn the client uses to create their private key and start the tls symmetric key sharing process
- and when the symmetric key is shared it is used to encrypt and decrypt like explained in the TLS process
- certicate signing is done by the server after generating the certificate and sending it to one of the authorities to be signed by them and typically done with a fee or a cost 

### SSH
- Now ssh uses as well TLS and dont use SSL certificates it initiates the handshake first and it uses the symmetric key for encrypting the connection on top of using public private key combination unlike https which just uses the ssl/tls for encryption the connection and securing it and no extra layer of security or signing because it would be expensive to implement with the amount of data sent during an http session.
- ssh uses public private key encryption for authentication which is assymetric and probably more secure but more costly to perform on large amounts of data and how it works is:
	- first the client generates a public private key pair and supposedly the server has the public key of the client before initiating the connection
	- second the client sends a request with the id of the public key pair it would like to authenticate with and the server checks for it in the authorized keys file 
	- the client sends the md5 hash value of the session symmetric key combined with the number got from decrypting the server's message sent encrypted by the public key and then sends it back to the server
	- the server uses the sent number and combines it with its own symmetric key and hashes it with md5 as well and compare it and if it matches the client is authorized to enter
