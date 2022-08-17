{
  description = "Start a C project with a Cosmopolitan compilation target";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  #  wget https://justine.lol/cosmopolitan/cosmopolitan.zip
  #  unzip cosmopolitan.zip
  #  printf 'main() { printf("hello world\\n"); }\n' >hello.c
  #  gcc -g -Os -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone \
  #    -fno-omit-frame-pointer -pg -mnop-mcount -mno-tls-direct-seg-refs \
  #    -o hello.com.dbg hello.c -fuse-ld=bfd -Wl,-T,ape.lds \
  #    -include cosmopolitan.h crt.o ape-no-modify-self.o cosmopolitan.a
  #  objcopy -S -O binary hello.com.dbg hello.com

  outputs = { self, nixpkgs, utils }: 
    utils.lib.eachDefaultSystem (system:
      let 
        pkgs = import nixpkgs { inherit system; };
        buildInputs = with pkgs; [ cosmopolitan ];
      in {
        devShell = with pkgs; (mkShell.override { stdenv = pkgs.stdenv; } {
          buildInputs = [buildInputs];
          shellHook = ''
          export CPATH=${cosmopolitan}/include:$CPATH
          export LIBRARY_PATH=${cosmopolitan}/lib:$LIBRARY_PATH
          export LD_LIBRARY_PATH=${cosmopolitan}/lib:$LD_LIBRARY_PATH
          '';
        });
      }
    );
}
