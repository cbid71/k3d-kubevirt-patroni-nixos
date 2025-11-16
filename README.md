# k3d-kubevirt-patroni-nixos

## Install dependencies - Option 1 standard Linux (Debian-Like)

### Install docker

https://docs.docker.com/engine/install/debian/

Then

```
sudo usermod -aG docker myuser
newgrp docker				# to refresh without login

docker ps -a
```

### Install K3D

```
# first k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# second kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl
chmod u+x /usr/local/bin/kubectl
```

### Install virtctl

To manipulate vms

```
export VERSION=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64

sudo mv virtctl-v1.6.3-linux-amd64 /usr/local/bin/virtctl
chmod u+x /usr/local/bin/virtctl
```

### Install nix

https://nixos.org/download/


### Reminder :
to relaunch this lab

systemctl start docker
k3s cluster list
k3s cluster start mycluster


## Install dependencies - Option 2 NixOS ( RECOMMENDED )

Import the `dependencies_nixos/custom.nix` in `configuration.nix`
then 
`nixos-rebuild switch`

It will :
- install docker ecosystem
- create a user "user" that will have all dependencies
- install virtctl command line tool
- install k3d to create clusters

## instanciate k3s cluster

```
k3d cluster create mycluster
```

Then

```
kubectl get pods
```

Reminder :
- to start k3d :
    k3d cluster list
    k3d start cluster <my cluster>
- to stop k3d :
    k3d cluster list
    k3d cluster stop <my cluster>

## Install kubevirt

```
kubectl create namespace kubevirt
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/v1.6.3/kubevirt-cr.yaml
kubectl apply -f https://github.com/kubevirt/kubevirt/releases/download/v1.6.3/kubevirt-operator.yaml
```

## Try to deploy a VM

```
kubectl apply -f ./test/test-vm.yaml
virtctl console testvm
```

## Generate an etcd image for kubevirt

TODO

## Generate a postgresql+patroni image for kubevirt

TODO

## Generate a haproxy image for kubevirt

TODO

## Generate yaml manifest to deploy clusters

TODO

[comment]<>(could be great if we could have the possibility to have MANY clusters defined and just play a command to generate one cluster or all yaml files)

