{
name = "lyon";
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
