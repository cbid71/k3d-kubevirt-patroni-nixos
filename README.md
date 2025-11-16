# k3d-kubevirt-patroni-nixos

## Install docker

https://docs.docker.com/engine/install/debian/

Then

```
sudo usermod -aG docker myuser
newgrp docker				# to refresh without login

docker ps -a
```

## Install K3D

```
# first k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# second kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo mv kubectl /usr/local/bin/kubectl
chmod u+x /usr/local/bin/kubectl
```

Then

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

## Install virtctl

To manipulate vms

```
export VERSION=$(curl https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt)
wget https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-linux-amd64

sudo mv virtctl-v1.6.3-linux-amd64 /usr/local/bin/virtctl
chmod u+x /usr/local/bin/virtctl
```

## Try to deploy a VM

```
kubectl apply -f ./test/test-vm.yaml
virtctl console testvm
```

Reminder :
to relaunch this lab
systemctl start docker
k3s cluster list
k3s cluster start mycluster
