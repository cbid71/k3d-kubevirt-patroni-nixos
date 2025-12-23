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
#      postgresql-patroni = nixos-generators.nixosGenerate {
#        inherit system pkgs;
#        modules = [ ./images/postgresql-patroni.nix ];
#        format = "qcow2";                                  
#      };
#      haproxy = nixos-generators.nixosGenerate {
#        inherit system pkgs;
#        modules = [ ./images/haproxy.nix ];
#        format = "qcow2";
#      };
    };
    nixosConfigurations = {
      # description of clusters
    };
  };
}
