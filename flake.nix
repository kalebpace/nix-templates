{
  outputs =
    { }:
    {
      templates = {
        container = {
          path = ./templates/container;
        };

        flake = {
          path = ./templates/flake;
          withVSCode = {
            path = ./templates/flake/withVSCode;
          };
        };

        rust = {
          path = ./templates/rust;
          withVSCode = {
            path = ./templates/rust/withVSCode;
          };
        };

        zig = {
          path = ./templates/zig;
          withVSCode = {
            path = ./templates/zig/withVSCode;
          };
        };
      };
    };
}
