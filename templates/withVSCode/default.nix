{ pkgs }:
{
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
}