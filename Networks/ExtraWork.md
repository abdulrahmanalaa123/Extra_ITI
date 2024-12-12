# 3-12-2024

## Stateless vs stateful

- Discussing stateless vs stateful applications in his videos opened up some great topics
such as:

### Stateless and stateful is a loose term
- stateful means that the application stores state and whenever it loses said state it breaks.
- stateless means that the state is found in the request(at least mostly so) and it doesnt store any additional info.
- now this opens up several things imagine a stateful system that uses the database request for storing its persistent state is it considered stateless or stateful?
- the purist response would be you can call it stateful since it stores the state somewhere but the average response is call it whatever the heck you like you can call it a stateless service with a stateful system.

### stateless can be built on top of stateful and vice versa:
- There is a bunch of stateless and stateful protocols built upon stateless protocols as well
- DNS is built over UDP
- One example is quic which is stateful built upon UDP
- And another which ill go on a rant on is.
#### HTTP built over TCP
- https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview great link as well as the typical http session link
- Now HTTP is a stateless protocol which saves its state inside its cookies running over tcp where each http request is sent over a tcp connection tcp is actually a streaming protocol with each packet sent is given a segment giving it its state it needs to know the current segment we have.
- HTTP 1 used to just send 1 request over a tcp connection which was an inefficient then in 1.1 it allowed one stream to send multiple http requests 
- fun fact: back in the day when sessions was used to hit different servers using a load balancer which stored your session inside their cache which would revoke your session requesting a login 
- A connection is controlled at the transport layer, and therefore fundamentally out of scope for HTTP.
 HTTP doesn't require the underlying transport protocol to be connection-based; it only requires it to be reliable, or not lose messages (at minimum, presenting an error in such cases). Among the two most common transport protocols on the Internet, TCP is reliable and UDP isn't. HTTP therefore relies on the TCP standard, which is connection-based. 
- the enhancements of 1 and 1.1 will hopefully be explained later

#### DNS built over UDP

- https://excalidraw.com/#json=tq3bX7ghXUt1jCN3WMWHU,LnQceGNuJXzmvoob_saaAg

## Protocols

- Protocol is a set of rules which was defined to serve a purpose as a solution to the problem it was trying to solve

### Protocol properties (what disntincts each protocol from the other)

#### Data format
- Text based communication (Human Readable) JSON , XML, Txt
- Binary (portobuf, Resp, http2 , http3 http2 and 3 are text based in usage but the actual communication is done in binary format) 
#### Transfer Mode
- Message based (UDP,HTTP)
- Stream (TCP,WebRTC)
#### Addressing System
- DNS name, IP, MAC
#### Directionality
- Bidirectional TCP
- Unidirectional HTTP
- Full/Half duplex (Like the wifi)?

# 8-12-2024 / 11-24-2024
***Alright so there is a bit of inconsistency where when i studied the DNS i wrote it here but it was hussein i guess but its extra work in general so this md is transformed to extra work in general its knowledge here in my garage*** 

## DHCP
https://www.nwkings.com/dora-process-in-dhcp
https://www.nwkings.com/what-is-dhcp-in-networking

- Alright i spent mroe than needed on DHCP so lets start with the basics and explain the basics first
- I didnt write was waiting to create a drawing just for linkedIN which was a blockage rather than a motivation so fuck it ill write what i understood and fuck the drawing so i could go on
- So lets explain the DHCP first well first its built upon udp its not connection based it just broadcasts requests throughout the network
- its divided into 4 phases DORA

### Discovery
Discovery is a broadcast from the client sent throughout the network with ip address in the network layer of a mask with a mask or 255.255.255.255 i think means it goes to all ip addresses in the network coming from port 67 using udp targeted to a broadcast mac address FF.FF.FF.FF coming from a mac address specified whic is the client mac address specified for the 68 port of the server
### Offer
Offering is a broadcast in the network layer and and a unicast in the data link meaning i have the source and destination mac address since the client just sent me and its broadcasted to notify offers to other dhcp servers on the same network im not sure of that but one time ill build a dhcp server but fuck it rn not worth it maybe create a dhcp server on docker once i learn docker 
### Request
The client doesnt have an ip address yet but it knows the server ip address and its mac address so the client responds to the dhcp that sent it the first packet it recieved so thats called unicast in the data link layer since both mac addresses are know and it broadcasts the request again to show other dhcp servers that it is requesting ip addr xxx.xxx.xxx.xxx 
### Accept
The DHCP recieves the request and saves it to its cache or table and lease time, etc. and it broadcast to the mac address it is again broadcasted in the network and unicasted in the data link giving the client its ip address and showing dhcp servers that my client has an ip addr of x. 

well my explanation is redundant and im repeating basically the same words and could be explained in just simple 4 lines so wouldnt look into it again unless ill create a docker dhcp server
## Dbus
- The Dbus is the abstraction interface provided by linux to all processes to share information between processes its how linux provides IPC to its processes
- DBUS has some things called bus names which are names assigned to processes for example the time date system process if taken by any one has a predefined bus name of org.system.timedate1 just to define a predefined interface of interacting with the service regardless of the application interacting with it or using it


### Masquerade
- didnt understand it really well couldnt understand idk why ill probably come back to it later

## OSI
- without a standard connection method you need to know the system youre talking to when sending a packet because it wouldve different for every medium and every system which isnt feasible but it doesnt make sense today because of the current standardization 
- standardization enables modularities in components, systems, etc. thats the beauty in it 

### Fucking Finally explained in a real life example
#### Sender Example (Sending a post request to and https webpage)
- Application layer ( POST request to the application server with a json packet)inside 
- Presentation Layer ( Then the JSON body or encoding is encoded and serialized into a string)
- Session Layer ( request tcp to establish a tcp connection and tls its responsible for the security and certificates and verifying sessions)
- Transport Layer (send the syn request and define source port and destination port specifying where should it go and how is it supposed to go resulting in a packet)
- Network Layer ( wrap the packet in source and destination ip address resulting in a segment)
- Data Link (turn the segment into a single frame and attach the source and destination mac address and the mask in case of a broadcast)
#### Reciever Example (Recieving the post request from the client)
- first the physical layer accepts the request
- Data link assembles back frame into a segment and decrypts the sourc ean ddest mac address
- the network layer assembles the segment into a ip packet
- the transport layer in case of syn request handles the control flow of packets handling the port assignements as well as retries, etc. for the syn request then but thats in general then sends it into the session layer to establish a connection with the client
- establishing the connection in the session layer and verifies sources and stops there in case of sync and then goes back through the same process to the client with the ack finally recieving the nexts sync then recieiving the packet and passing it up to the presentation layer
- decoding the incoming packet body and passes it to the application layer some people argue that the decoding is done by the application but yet that is what happens in the osi not the actual real world implementation (its just like things in the mirror dont appear as they seem) 
- finally the application understands the post request and the proper event is triggered in your application
#### components operating at specific layers 

- for example the switch operations stops only on the data link layer because it reroutes data inside the subnet subnet where it sees the source and destination mac address only and is what it needs to be able to reroute the connection
- As for the router it sees till the network layer which means it operates at the network layer because it needs to see the ip to be able to do its job because it reroutes the packets from a pirvate address to the public ip address
- And the firewall works till the transport layer because it needs to look till the ports becuase it has access to block requests coming from a given port, ip address, or a mac address
- The proxy works on the same layers as the firewall because it needs to read the ports and ip addresses to be able to reroute and assigns new source ip address to the same destination ip address 
- CDN, Load Balancer operate at the application layer it needs the applciation layer with the certificates and privelages of the server because they need to decrypt the message which in the cdn it needs it to cache it and for the load balancer it needs the laod so it can deliver it or distribute it on the servers

### Internet protocol

#### IP address

