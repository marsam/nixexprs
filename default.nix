{ system ? builtins.currentSystem }:
let
  pkgs = import <nixpkgs> { inherit system; };

  callPackage = pkgs.lib.callPackageWith (pkgs // self);

  self = rec {
    chunkcwm = callPackage ./pkgs/chunkcwm {
      inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa;
    };

    downgur = callPackage ./pkgs/downgur {
      inherit (pkgs.python3Packages) buildPythonPackage requests;
    };

    emacs-libpq = callPackage ./pkgs/emacs-libpq { };

    es = callPackage ./pkgs/es-shell { };

    kremlin = callPackage ./pkgs/kremlin { };
    opam = callPackage ./pkgs/opam { };

    home-manager = callPackage ./pkgs/home-manager { };

    shadowsocks-libev = callPackage ./pkgs/shadowsocks-libev { };
    shadowsocks-rust = callPackage ./pkgs/shadowsocks-rust { };
  };
in self
