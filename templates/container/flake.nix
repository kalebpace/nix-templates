{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, nixos-generators }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        container = import ./containerfile.nix { inherit pkgs; };
      in
      rec {
        packages = {
          default = container;

          x86_64-linux = {
            nixosPodmanLimaImage = nixos-generators.nixosGenerate {
              inherit system;
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                ./limaVM/configuration.nix
              ];
              format = "raw-efi";
            };
          };
        };

        devShells = {
          default = with pkgs; (mkShell.override { stdenv = stdenvNoCC; } {
            nativeBuildInputs = [
              podman
              lima-bin
            ];
          });
        };
      }
    );
}
