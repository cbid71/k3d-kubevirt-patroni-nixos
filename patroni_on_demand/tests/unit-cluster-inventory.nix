{ pkgs ? import <nixpkgs> {} }:
let
  lib = pkgs.lib;

  paris = import ../cluster_inventory/paris.nix;
  lyon  = import ../cluster_inventory/lyon.nix;

  results = lib.runTests {

    test_paris_name = {
      expr     = paris.name;
      expected = "paris";
    };

    test_paris_postgresql_nodes = {
      expr     = paris.postgresql_nb_nodes;
      expected = 5;
    };

    test_paris_etcd_odd_or_two = {
      # etcd recommend an odd number (3,5,7) or 2 for dev
      expr     = lib.elem paris.etcd_nb_nodes [ 1 2 3 5 7 ];
      expected = true;
    };

    test_paris_extraConfig_has_postgresql = {
      expr     = paris.extraConfig ? postgresql;
      expected = true;
    };

    test_lyon_name = {
      expr     = lyon.name;
      expected = "lyon";
    };

  };

in
if results == []
then builtins.trace "ALL UNIT TESTS PASSED" pkgs.emptyFile
else builtins.throw "UNIT TESTS FAILED: ${builtins.toJSON results}"
