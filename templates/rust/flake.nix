{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";

    # Rust overlay
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };

        # Setup rust toolchain from file
        rust-toolchain = with pkgs; fenix.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-S7epLlflwt0d1GZP44u5Xosgf6dRrmr8xxC+Ml2Pq7c=";
        };


        # Settle buildInputs for mininmal builds on linux/darwin
        buildInputs = with pkgs; [

        ] ++ lib.optional stdenv.isDarwin [
          libiconv
          darwin.apple_sdk_11_0.frameworks.CoreFoundation
          darwin.apple_sdk_11_0.frameworks.Security
        ];

      in
      rec {
        packages = {
          default = (pkgs.makeRustPlatform {
            cargo = rust-toolchain;
            rustc = rust-toolchain;
          }).buildRustPackage {
            pname = "hello-rust";
            version = "0.1.0";
            src = ./.;
            inherit buildInputs;
            cargoLock.lockFile = ./Cargo.lock;
          };
        };

        devShells = {
          default = with pkgs; (mkShell.override { stdenv = stdenvNoCC; } {
            nativeBuildInputs = buildInputs ++ [
              rust-toolchain
              # wasmtime
              # wasmedge
            ];

            # shellHook = ''
            #   # cargo install --quiet --root .cargo wasm-server-runner
            #   PATH=$PATH:.cargo/bin
            # '';
          });
        };
      }
    );
}
