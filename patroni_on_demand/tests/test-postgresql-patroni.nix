{ pkgs ? import <nixpkgs> {} }:
pkgs.testers.runNixOSTest {
  name = "postgresql-patroni-boot";

  nodes.pg1 = { ... }: {
    imports = [ ../images/postgresql-patroni.nix ];
    # We force DHCP on the test VM ( the VM QEMU needs it )
    networking.useDHCP = pkgs.lib.mkForce true;
    virtualisation.memorySize = 1024;
  };

  testScript = ''
    pg1.start()
    pg1.wait_for_unit("multi-user.target")
    pg1.wait_for_unit("postgresql.service")

    # check if PostgreSQL is working
    pg1.succeed("sudo -u postgres psql -c 'SELECT version();'")

    # check the port 5432 is listening
    pg1.succeed("ss -tlnp | grep 5432")
  '';
}
