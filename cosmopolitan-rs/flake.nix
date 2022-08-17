{
  description = "Start a Rust project with a Cosmopolitan compilation target";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }: 
    utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
      in rec {
        devShell = with pkgs; (mkShell.override { stdenv = pkgs.stdenv; } {
          buildInputs = [];
        });
      }
    );
}
