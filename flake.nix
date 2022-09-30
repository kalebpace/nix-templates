{
  description = "A bowl of frosted flakes";

  outputs = { self, nixpkgs }: {
    templates = {
      cosmopolitan-c = {
        path = ./cosmopolitan-c;
      };

      cosmopolitan-rs = {
        path = ./cosmopolitan-rs;
      };

      minimal = {
        path = ./minimal;
      };

      pestl = {
        path = ./pestl;
      };

      vscode-integration = {
        path = ./vscode-integration;
      };
    };
  };
}
