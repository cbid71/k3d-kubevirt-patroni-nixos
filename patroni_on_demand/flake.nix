{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    nixos-generators.url = "github:/nix-community/nixos-generators/1.8.0";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, nixos-generators, ...}:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    lib = nixpkgs.lib;

    clusters = [
      (import ./cluster_inventory/paris.nix)
      (import ./cluster_inventory/lyon.nix)
    ];

    renameImage = name: image: pkgs.runCommand name {} ''
      mkdir -p $out
      cp ${image}/*.qcow2 $out/${name}.qcow2
    '';

    generateClusterYaml = cluster: let
      resources = [
        (import ./kubevirt_templates/haproxy-vm.nix      { clusterName = cluster.name; })
        (import ./kubevirt_templates/haproxy-service.nix { clusterName = cluster.name; })
        (import ./kubevirt_templates/haproxy-ingress.nix { clusterName = cluster.name; })

        (import ./kubevirt_templates/etcd-vm.nix         { clusterName = cluster.name; })
        (import ./kubevirt_templates/etcd-service.nix    { clusterName = cluster.name; })
        (import ./kubevirt_templates/etcd-ingress.nix    { clusterName = cluster.name; })

        (import ./kubevirt_templates/patroni-vm.nix      { clusterName = cluster.name; })
        (import ./kubevirt_templates/patroni-service.nix { clusterName = cluster.name; })
        (import ./kubevirt_templates/patroni-ingress.nix { clusterName = cluster.name; })
      ];
    in pkgs.writeTextFile {
      name = "${cluster.name}.yaml";
      text = lib.concatStringsSep "\n---\n" (map toString resources);
    };

  in
  {
    packages.${system} = {
      etcd = nixos-generators.nixosGenerate {
        inherit system pkgs;
        format = "qcow";
        modules = [ ./images/etcd.nix ];
      };
      postgresql-patroni = nixos-generators.nixosGenerate {
        inherit system pkgs;
        format = "qcow";
        modules = [ ./images/postgresql-patroni.nix ];
      };
      haproxy = nixos-generators.nixosGenerate {
        inherit system pkgs;
        format = "qcow";
        modules = [ ./images/haproxy.nix ];
      };

      all-yaml = pkgs.symlinkJoin {
        name = "all-clusters";
        paths = map generateClusterYaml clusters;
      };

    } // (lib.listToAttrs (map (cluster: {
      name = "${cluster.name}-cluster";
      value = generateClusterYaml cluster;
    }) clusters));
  };
}
