{ cluster, lib }:
lib.concatMap (i: [
  (import ./etcd-vm.nix      { inherit cluster; index = i; })
  (import ./etcd-service.nix { inherit cluster; index = i; })
  (import ./etcd-ingress.nix { inherit cluster; index = i; })
]) (lib.range 0 (cluster.etcd_nb_nodes - 1))
