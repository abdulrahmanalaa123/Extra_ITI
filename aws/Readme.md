# 15-12-2024

## AWS Cloud

### IAM
- Groups contians users that include users which give permissions and they are not mutually exclusive just like the linux users
- Best practice is to assign privilege to users using the least privelage principle 

#### IAM Identities

##### IAM Users
- Root user has access to everything but its the main owner of the account which is used for recovery of anything and lost permissions or keys from the users created by IAM
- Admin users have access to all resources on aws with no restrictions
- users are created for a single person or application
- aws identifies the user by its `name` which is shown in the console and the `ARN(amazon Resource name)` which is used to uniquely identify the account across AWS and used when defining the specific user as a Principal in a policy and the `user id` which is shown only when the user created through the CLI not through the IAM console dashboard
- Users can access their account using several methods:
	1. `Console password` in which the user signs in into an interactive session using the web console
	2. using an `access key` although its frowned upon to have long-term access keys and its preferred to limit them and delete them frequently
	3. `SSH keys` which could be used to access the aws resources using ssh using `codecommit`

##### IAM user groups
- a group is an identity assigned to a collection of IAM users 
- the main things about groups is that they cant be assigned other groups and can only be assigned users and cant be assigned in Identity based policies and can be attached Resource based policies only

##### IAM roles
- All i know is that they are used to give access without assigning a user and letting anyone who wants to connect use that specific role and can be used by using `AWS COGNITO`.

#### IAM request

##### Authentication
- any request sent from the aws cli,interface is passed on to IAM in the form of an authentication request
- the authentication request is matched to a principal `an entity(a user or role)`
- 
##### Authorization
- then any authorization request is sent by IAM to check the principal's 

#### Policies
- Policies are limits or restrictions 
- `Version` policy lang version
- `id` identifier for the policy
- `Statement` one or more individual statements (list of objects or statements)
	- `id` statement identifier
	- `Effect` either allow or deny which acts as either blacklisting or white listing
	- `Principal` The user or account or group this statement is applied to 
 	- `Actions` the list of actions that apply the effect on for example if i add IAM:getUsers with effect deny it will deny the said user fro macessing IAM
	- `Resource`the aws resource or resources on which these actions are applied to for example you can specify the resource name maybe specifically a bucket inside of s3 and not the entirety of the service
	- `Condition` the condition in which this policy is applied conditions are usually equal, lessthan, greaterthan applied for keys and values of the IAM request 
- Resources are specified as maybe machines, processes, buckets, etc. 

##### Identity Based Policies
- identity based policies are policies specified to a user and cant be assigned to groups and the user(s) assigned are specified by the principal field containing their ARNs

##### Resource Based Policies
- Resource Based policies are policies that are attached to policies which doesnt specify the principal its assigned to and can be attached to users,groups,roles and its Identity agnostic (you follow it and its not assigned to you only)

# 22-2-2025

## AWS Networking

### CIDR BLOCK

- to first understand the CIDR (Classless interdomain routing) you need to first understand what are classes
- classes are the defining factors for your ip address segmenting into three main classes `A,B,C`
- `A` is the network class with 8 prefixed bits reserved for the network 192.0.0.1 where 192 is the network address and the rest is reserved for the hosts which isnt 
- `B` is the network class with 16 prefixed bits are reserved for the network wifor example 192.168.0.1 where 192.168 is the network identifier in class B
- `C` is the network class with 24 prefixed bits and so on and so forth
- each level of classes reduce the reserved bit space for the hosts where for `A` you have 2^24 hosts available to be attached and `B` is 2^16 and for `C` its 2^8 left for the hosts

- The limitations of the class based interdomain routing is inefficient partitioning of network hosts and the inability to segment the network according to the needs for example to occupy even one host above 256 you need to use the `B` class which gives a plethora of unsused ip addresses

- and segmenting your ip addresses for example you need two subnets both in the same network with 192.168.1.0 and 192.168.0.0 you need either a network with `B` class and a ton of unused ips or just you couldnt simply combine them with the CIDR you can assign a network with /23 network subnetting creating a supernet with 2 subnets one with the ip address of 192.168.1.0. and 192.168.0.0

- A CIDR block is basically a supernet which is a network given a certain network prefix segmentation to create subnets sharing the same network address 

- An example of a CIDR block is 10.10.0.0/16 which means you can assign 255 subnets with each containing 255 hosts `10.10.1.0/24 10.10.2.0/24 10.10.3.0/24 ...`

### VPC 
- A VPC is a virtual network used for configuring the network configuration of your services which resides inside just like configuring your own local network

- default VPCs are created by default for your account configured with a default subnet for each availability zone in your region which is used for private ip addresses of your instances 

- default VPCs are also assigned an internet gateway that enables public addressing and access to the instances created inside any subnet inside the VPC default subnets are automatically attached to the Internet gateway giving them both a public and a private ip address

- Default internet gateways are also assigned a default routing table created with the creation of the default VPC you can either create a different route table object and assign it to the Internet gateway or you can attach a specific routing table for your created subnet 

- public ip addresses of instances is assigned randomly and would change on instance stopping and starting to assign a static IP address you can configure an elastic IP address to be attached to the preffered instance for static ip addresses

- you can assign multiple instances to the same public ip address and configuring the rules using a NAT Device which is assigned a public ip statically using an elastic IP address and connected to the internet gateway with the public connectivity type and attached to a specific subnet

-  **public ip addresses are attached to instances or NAT devices the internet gateway only enables such routing and isnt assigned an ip of its own**

- [Helpful for understanding how to initially Configure your non-default VPC](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-getting-started.html#plan-internet-connectivity)

- VPCS are region based and account based which means creating a VPC isnt local to an IAM user and doesnt span multiple regions

- VPC CIDR block must follow certain rules to enable assigning IP address you may assign the cidrBlock following the RFC 1918 for private IP addresses ranges

- 10.0.0.0/8 which means from 10.1.0.0 till 10.255.255.255
- 172.16.0.0/12 which means from 172.16.1.0 till 172.31.255.255
- although 172.17.0.0/16 is available as a CIDR range as well as 172.16.0.0/12 they are used by internal AWS services which may result in conflicts
- 192.168.0.0/16  which means 192.168.1.0 till 192.168.255.255

- [rules for Inter-VPC communication with requested CIDR BLOCKS](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-cidr-blocks.html#add-cidr-block-restrictions)

- Assigning public ip addresses to the VPC CIDR block will disable using that assigned ip or translating it from inside the EC2 which would conflict inside the instance and the route table will preceed all routing and would route it to the private network instead of the actual ip address
- [discussing the CIDR ip outside of the RFC range](https://stackoverflow.com/questions/62326558/how-can-aws-use-public-ipv4-address-range-for-a-vpc-and-assign-them-as-private-i)

- To visualize the vpc connection flow you can view the resource map in the yourvpc tab by clicking the wanted vpc 

- default route tables assigned to the vpc will add the vpc to any newly created subnet 

#### Network Border Group
#### Local Zone
#### Wavelength Zone

### Elastic Ip Addresses

- Elastic Ip address is used to reserve a static ip which can be assigned to your instance or your load Balancer or you can assign a NAT rule for your subnet to map the public ip address for your instances inside the subnet

- Accounts have a limit of 5 Elastic Ip addresses unless used IP addresses are temporarily and constantly changing when assigned dynamically and can add dns rules unless used with an elastic IP address 

- Resources which can be assigned an elastic IP address are NAT, EC2 instance, Network Load Balancer, Network Interfaces

- you can use the elastic IP address to enable a static assignment of your AWS resources and can be used to reassign the ip address to a backup instance in case of failing of one instance 

- The elastic Ip address is assigned to a network border group which holds all the Local Zones and wavelength zones as well as availability zones 

- you can track the costs of elastic IP assignment using tags assigned to the assigned IP

### Network interfaces
- You can use network interfaces alognside Elastic ip addresses to persist network state and configurations of an instance and reattach or reassign it to another instance as some form of failover
- Netwokrk Interfaces are called Elastic network interfaces given a MAC address and a private ip address and a public ip address for each private ip address 

### Subnets

- **each subnet created must reside in a single availability zone**

- A subnet is considered public when being attached a direct route to the internet gateway allowing each network interface created isnide the subnet to be assigned a public ip by turning on the auto-assign IP setting

- The private subnet isnt given direct route to an internet gateway

- Each subnet is assigned a routing table specifying the rules for inbound and  outbound traffic 

- To protect your resources inside your subnet you should create a public subnet to access your private subnets using it as a jump host to disable direct access which is called a `bastion host` or a `jump host`

- You can log traffic using VPC flow log

### Routing Tables

- Routing tables are used for routing options of outbound requests and managing where each request coming out with a certain IP address where it should go just passing through the router is considered an outbound request it doesnt necessarily mean it was generated by a device inside the network

- Routing tables are specified with a destination and a target where the destination is the target ip you're going for and then next hop specifying where should it goes next from example the 192.168.0.0/24 means will mean local network request will be attached a rule 192.168.0.0/24 destination will have a local target so when you talk to any ip prefixed with 192.168.0 will be routed locally

- Route tables have priority listing first its done using the longest matching prefix where it matches the longest network prefix sharing the same prefix as the outcoming ip 10.10.2.15/32 has higher priority over 10.10.2.0/24

- Thats why when specifying the rules for accessing the internet for example you use 0.0.0.0/0 which means any ipv4 address that doesnt match any of the previous rules just route it to the internet gateway 

- Static routes such as (igw,nat gateway, network interface, instance ID, gateway VPC enpoint, gateway load balancer endpoint) these give examples of targets that you can use instead of simply local and the igw 

- in default VPCs you have a default subnet which is attached to any subnet wihtout no attached routing table while in custom VPCs a default route table is created and contains only the local route destination of 0.0.0.0/0 and a target of local 

- To change the main routing table its recommended to first test a local route table on a specified subnet then test traffic and finally replace the main route table wiht the subnet's routing table 

- You can create a prefix list for routing several routes to a specific endpoint, interface (using its id), or a gateway 

- for example a prefix list `10.0.0.0/16 10.0.2.0/16 will be mapped to a prefix list id of pl-123abc123abc123ab` 

- [available targets in AWS are under the static route targets](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Route_Tables.html)

- route propagation is mainly used when attaching a virtual private gateway to not need to manually add or remove VPN routes

#### Static Routing

- Static routing is specifying strict routing rules which is primarily used in non-changing network architectures which is used with aws netowrk subnets routing tables 

#### Dynamic Routing

- dynamic routing on the other hand is used in everchanging network architectureit uses several protocols and algorithms to determine the optimal next hop for example the RIP (Routing information protocol) the router sends its routing talble to adjacent routers and get back their tables and determine the most cost efficient next hop these are called (DISTANCE VECTOR PROTOCOLS) in genral


#### Gateway Route tables

- gateway route tables are associated with virtual private gateway or an internet gateway there are only 3 allowed targets that can be added when adding a gateway route table (local, gateway, network interface (middlebox network appliance))

- when having or needing both three targets there are rules for the destination IPS that can be used first any route that leaves the subnet through an interface must be routed back to the subnet 

- you can have a destination of the connected subnet when using a middlebox network appliance the connecting two subnets with a security m iddlebox appliance the route table in subnet A can have the subnet CIDR of B with the target of the network interface of the appliance and the same for B and you can have the VPC CIDR with the local target (you cant use prefix lists when creating a gateway route table to counter that you can route all traffic to the gateway endpoint and from the enpoint configure it for your desired routing options or pass it through the middlebox)

- [the rules for creating a gateway endpoint with a middle box appliance appliance are very complicated you can check the docs when creating your own routing table](https://docs.aws.amazon.com/vpc/latest/userguide/gateway-route-tables.html#gateway-route-table-routes)

- [and with attaching a middlebox appliance](https://docs.aws.amazon.com/vpc/latest/userguide/route-table-options.html#appliance-considerations)

### Internet gateways

- there are two methods to publicly access your services method either using an elastic ip which is reserved out of the public pool of ipv4 addresses associated to your avaiability zone or for a controlled location using local zones which resides inside hte availability zone or dynamically assigning a public ip address which can be reassigned several times for each instance


