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

    # This function will create yaml for each cluster
    generateClusterYaml = cluster: let          
    # reminder : since I'm learning, "cluster" here is a parameter
    # if several variables are needed 
    # generateClusterYaml = cluster: other_variable: let
    # and the call would be
    # paris = generateClusterYaml (import ./clusters/paris.nix) "my_other_variable"; 
      resources = lib.concatMap (i: {
        # haproxy
        haproxyVm = import ./kubevirt_templates/haproxy-vm.nix { clusterName = cluster.name; index = i; };
        haproxyService = import ./kubevirt_templates/haproxy-service.nix { clusterName = cluster.name; index = i; };
        haproxyIngress = import ./kubevirt_templates/haproxy-ingress.nix { clusterName = cluster.name; index = i; };
  
        # etcd
        etcdVm = import ./kubevirt_templates/etcd-vm.nix { clusterName = cluster.name; index = i; };
        etcdService = import ./kubevirt_templates/etcd-service.nix { clusterName = cluster.name; index = i; };
        etcdIngress = import ./kubevirt_templates/etcd-ingress.nix { clusterName = cluster.name; index = i; };
  
        # patroni
        patroniVm = import ./kubevirt_templates/patroni-vm.nix { clusterName = cluster.name; index = i; };
        patroniService = import ./kubevirt_templates/patroni-service.nix { clusterName = cluster.name; index = i; };
        patroniIngress = import ./kubevirt_templates/patroni-ingress.nix { clusterName = cluster.name; index = i; };
      }) cluster;
    in pkgs.writeTextFile {
      # by passing it here, all will be written in the same file, one by cluster, good enough for us
      # we should probably move this function to each kubevirt template file if one file per kind/object... but we do not want it
      name = "${cluster.name}.yml";
      text = builtins.toString (lib.mapAttrs (_: r: toString r) resources);
    };

  in
  {
    packages.${system} = {  # example for system = x86_64-linux
      etcd = nixos-generators.nixosGenerate {
        inherit system pkgs;
        format = "qcow";
        modules = [ 
           ./images/etcd.nix
        ];
      };
      postgresql-patroni = nixos-generators.nixosGenerate {
        inherit system pkgs;
        format = "qcow";
        modules = [
          ./images/postgresql-patroni.nix
        ];
      };
      haproxy = nixos-generators.nixosGenerate {
        inherit system pkgs;
        format = "qcow";
        modules = [ ./images/haproxy.nix ];
      };
    };
    # nixosConfigurations = contains yaml of all clusters
    nixosConfigurations = {
      paris = generateClusterYaml (import ./clusters/paris.nix);
      lyon = generateClusterYaml (import ./clusters/lyon.nix);
    };
  };
}
