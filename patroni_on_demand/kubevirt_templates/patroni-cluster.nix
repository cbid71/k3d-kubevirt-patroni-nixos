{ cluster, lib }:
lib.concatMap (i: [
  (import ./patroni-vm.nix      { inherit cluster; index = i; })
  (import ./patroni-service.nix { inherit cluster; index = i; })
  (import ./patroni-ingress.nix { inherit cluster; index = i; })
]) (lib.range 0 (cluster.postgresql_nb_nodes - 1))
