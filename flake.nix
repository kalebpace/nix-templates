{
  outputs = { self }: {
    templates = {
      container = {
        path = ./container;
      };

      flake = {
        path = ./flake;
        withVSCode = {
          path = ./flake/withVSCode;
        };
      };
      
      rust = {
        path = ./rust;
        withVSCode = {
          path = ./rust/withVSCode;
        };
      };

      zig = {
        path = ./zig;
        withVSCode = {
          path = ./zig/withVSCode;
        };
      };
    };
  };
}
