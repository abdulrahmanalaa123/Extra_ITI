# 9-2-2025

## Kubernetes High level overview
- [mySummary of the k8s architecture overview no need to rewrite it](https://github.com/abdulrahmanalaa123/ITI-sessions/blob/master/itiLog.md#kubern8es-architecture)
### CRI
- 
### containerd vs docker
- docker itself is now not supported by kubernetes its built upon containerd so intsalling dokcer will install containerd by default os you can run kubernetes after installing docker 


#### CLI tools
- `crictl` --> the k8s cli for managiang container runtime  environments used for debugging and checking logs and attaching a shell for example ot a current running container for all container interfaces defining a minimal interface
- `ctr`  --> used for interacting with containerd specifically and minimal in its nature its better to use nerdctl
- `nerdctl` --> the same cli interface for managing containerd runtime and using it is the same ocmmand structure as the docker cli
- `docker` --> the docker cli for interacting with initiated docker containers and is only used with docker
