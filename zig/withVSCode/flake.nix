{
  description = "A minimal zig template which wraps vscode environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        vscodeWithExtensions = vscode-with-extensions.override {
          vscode = vscodium;
          vscodeExtensions = with vscode-extensions; [
            jnoortheen.nix-ide
            asvetliakov.vscode-neovim
          ] ++ vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-zig";
              publisher = "ziglang";
              version = "latest";
              sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            }
          ];
        };
        
        buildInputs = with pkgs; [
          zig
          zls
        ];
      in
      rec {
        packages.default = with pkgs; stdenv.mkDerivation {
          name = "hello-zig";
          src = ./.;
          phases = [ "unpackPhase" "buildPhase" "installPhase" ];
          inherit buildInputs;
          buildPhase = ''
            mkdir -p $out
            zig build
          '';
          installPhase = ''
            cp -r ./zig-out/bin/ziggy $out/
          '';
        };

        devShell = with pkgs; (mkShell.override { stdenv = pkgs.stdenvNoCC; } {
          nativeBuildInputs = buildInputs ++ [
            vscodeWithExtensions
            # wasmedge
            # wasmtime
          ];
        });
      }
    );
}
