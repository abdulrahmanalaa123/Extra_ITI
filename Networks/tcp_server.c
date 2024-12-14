#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h> 
#include <netinet/in.h> 
#include <arpa/inet.h> 

typedef struct sockaddr_in sockaddr_ipv4;
#define PORT 8801
#define IPV4_CONNECTION AF_INET
#define TCP SOCK_STREAM
#define IP_PROTOCOL 0
#define BACKLOG 5

int main(int argc, char **argv){
	int sockfd,new_sock;
	sockaddr_ipv4 source_addr,dest_addr;
	char buffer[1024];
	socklen_t dest_len = sizeof(dest_addr);	
	socklen_t source_len = sizeof(source_addr);

	sockfd = socket(IPV4_CONNECTION, TCP, 0);
	memset(&source_addr,'\0',source_len);
	source_addr.sin_family = IPV4_CONNECTION;
	source_addr.sin_port = htons(PORT);	
	source_addr.sin_addr.s_addr = inet_addr("127.0.0.1");

	bind(sockfd,(struct sockaddr*) &source_addr, source_len);
	printf(" - Binding to port %d \n",PORT);

	// number is the number of backlog the connection can handle
	// before sending failure or terminating the requeset
	// keep in mind the back log is of requests not connections
	// so if 5 requests are in the queue and a client was just sent a syn/ack
	// his ack wouldnt reach the server and the connection would fail
	// since it couldnt reach
	// the solutions would be either handling more at a time reducing 
	// parallelizing and threading would increase the throughput or increase
	// the queue or a bit of both
	listen(sockfd,BACKLOG);
	printf("Listening with a backlog of %d \n", BACKLOG);
	

	new_sock = accept(sockfd, (struct sockaddr*) &dest_addr, &dest_len);
	printf("new sock is %d\n",new_sock);

	// now we opened a connection and we have its file descriptors we can
	// now send to the client
	// adding hello to the buffer so we can send it
	strcpy(buffer, "Hello\n");
	send(new_sock, buffer, strlen(buffer),0);
	printf("terminating the connection");
	return 0;
}
