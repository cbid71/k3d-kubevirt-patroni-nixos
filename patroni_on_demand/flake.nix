{
  inputs = {
    nixpkgs = "github:NixOS/nixpkgs/25.05"
    nixos-generators = "github:/NixOS/nixos-generators/1.8.0"
  };
  outputs = { self, nixpkgs, nixos-generators, ...}:
  let
    system = "x86_64-linux"
  in
  {
    packages.${system} = {  # example for system = x86_64-linux
      etcd = nixos-generators.nixosGenerate {
        inherit system;
        modules = [ ./images/etcd.nix ];
        format = "qcow2";
      };
      postgresql-patroni = nixos-generators.nixosGenerate {
        inherit system;
        modules = [ ./images/postgresql-patroni.nix ];
        format = "qcow2";                                  
      };
      haproxy = nixos-generators.nixosGenerate {
        inherit system;
        modules = [ ./images/haproxy.nix ];
        format = "qcow2";
      };
    };
    nixosConfigurations = {
      # description of clusters
    };
  };
}
