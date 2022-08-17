{ pkgs }:
with pkgs;
# https://github.com/NixOS/nixpkgs/blob/master/doc/builders/images/dockertools.section.md
# Some Options:
#   - buildImage (single-layer image)
#   - buildLayeredImage (multi-layer image for fast diffs)
#   - streamLayeredImage (save diskspace until loaded into image registry)
dockerTools.buildLayeredImage {
  name = "hello-oci-container";
  tag = "latest";
  contents = with pkgs; [
    hello
  ];
  config = {
    Entrypoint = [ "/bin/hello" ];
    Env = ["TEST=TRUE"];
    WorkingDir = "/data";
    Volumes = {
      "/data" = { };
    };
    ExposedPorts = {
      "80/tcp" = { };
    };
  };
}