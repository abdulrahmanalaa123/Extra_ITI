#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h> // socket, bind, recvfrom, close , includes ssize_t definition as well in arpa might include it or they include a sys/type.h header themselves
#include <netinet/in.h> //sockaddr_in type, INADDR_LOOPBACK if needed, htons, htonl 
#include <arpa/inet.h> // inet_addr might be omitted if i use htonl but i will keep it

// i really dont know the implications of calling alot of headers but i dont think its that detremintal the compilation process just secludes the used definintions and omits the rest of the headers

typedef struct sockaddr_in sockaddr_ipv4;
#define PORT 5501 
#define IPV4_CONNECTION AF_INET
#define UDP SOCK_DGRAM
#define IP_PROTOCOL 0


int main(int argc, char **argv){
	int port = 5501;
	// socket file descriptor
	// a file descriptor is a unique identifier for the socket or the 
	// connection establisjed which contians the source address and its port number
	// which is unique for each process running on the machine
	int sockfd;
	sockaddr_ipv4 myaddr, remoteaddr;
	// creating a buffer to hold in the data of the incoming
	char buffer[1024];
	socklen_t addr_size;
	socklen_t myaddr_size;

	sockfd = socket(IPV4_CONNECTION, UDP, IP_PROTOCOL);
	myaddr_size = sizeof(myaddr);
	memset(&myaddr, '\0', sizeof(myaddr));
	myaddr.sin_family = IPV4_CONNECTION;
	// htons ensures that the port is specified to network byte ordering
	myaddr.sin_port = htons(PORT);
	// transform  the string into an ip address
	// this defines the ip for the socket address
	// couldve used htonl(INADDR_LOOPBACK) instead of inet_addr("127.0.0.1")
	// which has the same value but htonl is a different method
	// to convert from a unsigned integer to network byte order
	// network byte order is specified to be in big endian so htonl ensures that
	myaddr.sin_addr.s_addr = inet_addr("127.0.0.1");
	// writing struct sockaddr* referring or casting the type of pointer
	// to a sockaddress pointer type but specificying struct is to define
	// the type called from the header here as a struct or we couldve
	// defined it as a type beforehand just like sockaddr_in as sockaddr_ipv4
	bind(sockfd, (struct sockaddr*)& myaddr, sizeof(myaddr)); 

	addr_size =  sizeof(remoteaddr);
	// Used for a count of bytes or an error indication.
	// that is what is written by the posix standard but idk its actual byte size but its the return type of recv from thats what im sure of
	ssize_t recieved_data_size =recvfrom(sockfd, buffer , 1024, IP_PROTOCOL, (struct sockaddr *)& remoteaddr, &addr_size);

	printf("got data of size %zd \n", recieved_data_size);
	printf("got data from %s \n", buffer);
	return 0;
}
