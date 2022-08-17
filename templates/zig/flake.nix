{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        buildInputs = with pkgs; [
          zig
          zls
        ];
      in
      rec {
        packages = {
          default = with pkgs.stdenvNoCC; mkDerivation {
          name = "hello-zig";
          src = ./.;
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          inherit buildInputs;
          buildPhase = ''
            mkdir -p $out
            zig build
          '';
          installPhase = ''
            cp -r ./zig-out/bin/**/* $out/
          '';
          };
        };

        devShells = {
          default = with pkgs; (mkShell.override { stdenv = stdenvNoCC; } {
              nativeBuildInputs = buildInputs ++ [ ];
            });
        };
      }
    );
}