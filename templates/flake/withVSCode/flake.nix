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
          # Dependencies we need in our shell AND our 'nix build' env
        ];

        # https://nixos.wiki/wiki/VSCodium
        vsCodeSettings = (builtins.fromJSON (builtins.readFile ".vscode/settings.json"));
        vsCodeWithExtensions = with pkgs; vscode-with-extensions.override {
          vscode = vscodium; # options: 'vscode' | 'vscodium'
          vscodeExtensions = with vscode-extensions; [
            jnoortheen.nix-ide
            arrterian.nix-env-selector
            asvetliakov.vscode-neovim
          ] ++ vscode-utils.extensionsFromVscodeMarketplace [
            # Add any extensions directly from Official Microsoft Marketplace
            {
              name = "gitlens";
              publisher = "eamodio";
              version = "latest";
              sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
            }
          ];
        };
      in
      rec {
        packages = {
          default = with pkgs.stdenvNoCC; mkDerivation {
            name = "hello-nix";
            inherit buildInputs;
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
            nativeBuildInputs = buildInputs ++ [
              # Tools we need in our shell
              vsCodeWithExtensions
              neovim
            ];
          });
        };
      }
    );
}
