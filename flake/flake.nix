{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages = {
          default = with pkgs.stdenvNoCC; mkDerivation {
            name = "hello-nix";
            src = ./.;
            phases = [ "unpackPhase" "buildPhase" "installPhase" ];
            installPhase = ''
              mkdir -p $out/
              cp -r ./ $out/
            '';
          };
        };

        devShells = {
          default = with pkgs; (mkShell.override { stdenv = stdenvNoCC; } {
              # https://nixos.wiki/wiki/Development_environment_with_nix-shell
              nativeBuildInputs = [ 
                # Tools we need in our shell
              ];

              buildInputs = [
                # Dependencies we need in our shell AND our 'nix build' env
              ];
            });
        };
      }
    );
}
