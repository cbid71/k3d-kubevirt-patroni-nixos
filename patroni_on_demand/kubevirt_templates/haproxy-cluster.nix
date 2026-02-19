{ cluster, lib }:
lib.concatMap (i: [
  (import ./haproxy-vm.nix      { inherit cluster; index = i; })
  (import ./haproxy-service.nix { inherit cluster; index = i; })
  (import ./haproxy-ingress.nix { inherit cluster; index = i; })
]) (lib.range 0 (cluster.haproxy_nb_nodes - 1))
