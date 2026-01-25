# A tester le flake.nix en exemple, pour la partie génération des yamls basée sur un inventaire
# est peut-etre un peu compliqué 
# NOTE : il est marqué "production-cluster", aucune prod n'utilise cette config c'est un exemple

let
  # Inventaire des clusters avec leurs services et leurs nombres de nœuds
  clusters = [
    {
      name = "production-cluster";
      haproxy_nb_nodes = 3;
      postgresql_nb_nodes = 5;
      etcd_nb_nodes = 2;
      # extraConfig spécifique à chaque service dans ce cluster
      extraConfig = {
        haproxy = {
          networking.hostName = "prod-haproxy";
          services.haproxy.enable = true;
          services.haproxy.frontend = {
            mode = "http";
            bind = "0.0.0.0:80";
          };
        };
        postgresql = {
          networking.hostName = "prod-postgresql";
          services.postgresql.enable = true;
          services.postgresql.version = "13";
        };
        etcd = {
          networking.hostName = "prod-etcd";
          services.etcd.enable = true;
          services.etcd.listenPeerURLs = "http://0.0.0.0:2380";
        };
      };
    }
    {
      name = "dev-cluster-1";
      haproxy_nb_nodes = 1;
      postgresql_nb_nodes = 1;
      etcd_nb_nodes = 1;
      extraConfig = {
        haproxy = {
          networking.hostName = "dev-haproxy";
          services.haproxy.enable = true;
          services.haproxy.frontend = {
            mode = "http";
            bind = "0.0.0.0:8080";
          };
        };
        postgresql = {
          networking.hostName = "dev-postgresql";
          services.postgresql.enable = true;
          services.postgresql.version = "13";
        };
        etcd = {
          networking.hostName = "dev-etcd";
          services.etcd.enable = true;
          services.etcd.listenPeerURLs = "http://0.0.0.0:2380";
        };
      };
    }
  ];

  # Fonction pour générer la configuration pour chaque service dans un cluster
  generateClusterServiceConfig = cluster: service: n: nixos-generators.nixosGenerate {
    inherit system pkgs;
    format = "qcow";
    modules = [
      ./images/${service}.nix  # Charge le module spécifique à chaque service
    ];
    extraConfig = cluster.extraConfig.${service};  # Applique le extraConfig spécifique au service
  };

  # Générer des configurations pour chaque service et chaque cluster
  generateClusterConfigs = cluster: {
    haproxy = generateClusterServiceConfig cluster "haproxy" cluster.haproxy_nb_nodes;
    postgresql = generateClusterServiceConfig cluster "postgresql" cluster.postgresql_nb_nodes;
    etcd = generateClusterServiceConfig cluster "etcd" cluster.etcd_nb_nodes;
  };

in
{
  # On associe chaque cluster avec ses configurations
  nixosConfigurations = builtins.listToAttrs (map (cluster: {
    name = cluster.name;
    value = generateClusterConfigs cluster;
  }) clusters);
}

