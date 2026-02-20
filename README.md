# k3d-kubevirt-patroni-nixos

## Disclaimer

This whole project is for NixOS example and experiment, and not meant to be fully functional

We currently know those missing points :

- VM images (directory `patroni_on_demand/images` need to be more developped
- make a whole functional patroni/etc/haproxy configuration
- more developed yaml could be a good idea :
    * management of Qemu images in the VM yaml using PVC + datavolumes + qcow images versionned in a S3 storage
    * dynamic configuration of kubevirt VM instanciated, by using configmaps and volumes
    * we should avoid using `cloud-init` known to be unstable with complex configuration

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
```
systemctl start docker
k3d cluster list
k3d cluster start mycluster
```

## Install dependencies - Option 2 NixOS ( RECOMMENDED )

Import the `dependencies_nixos/custom.nix` in `configuration.nix`

then enable experimental feature

In `/etc/configuration.nix`

```
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '
```

then
 
`nixos-rebuild switch`

It will :
- install docker ecosystem
- create a user `user` that will have all dependencies
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
  ```
    k3d cluster list
    k3d cluster start <my cluster>
  ```
- to stop k3d :
  ```
    k3d cluster list
    k3d cluster stop <my cluster>
  ```
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

## About images

Images are based on `nixos-generators` as it's currently the most valued project to create VM images.

## Generate an etcd image for kubevirt

```
cd patroni_on_demand
nix build .#packages.x86_64-linux.etcd
```

## Generate a postgresql+patroni image for kubevirt

```
cd patroni_on_demand
nix build .#packages.x86_64-linux.postgresql-patroni
```

## Generate a haproxy image for kubevirt

```
cd patroni_on_demand
nix build .#packages.x86_64-linux.haproxy
```

## Generate yaml manifest to deploy clusters

```
# Generate ONE cluster yaml
nix build .#paris-cluster
nix build .#lyon-cluster

# Generate ALL clusters yaml
nix build .#all-clusters
```

## Test framework

Test inventories format :

```
cd patroni_on_demand/
nix-build tests/unit-cluster-inventory.nix
# OR by the flake.nix section
nix build .#checks.unit-cluster-inventory -L
```

Test generate postgresql (not fully functional, only for example, the image should be a little more developped)

```
cd patroni_on_demand/
nix-build tests/test-postgresql-patroni.nix
# OR by the flake.nix section
nix build .#checks.integration-postgresql
```

## Bonus

Build all images in one command :

```
nix build .#packages.x86_64-linux.etcd \
          .#packages.x86_64-linux.haproxy \
          .#packages.x86_64-linux.postgresql-patroni
```
