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


