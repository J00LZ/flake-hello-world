{
  description = "A flake for building Hello World";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages = {
          hello =
            # Notice the reference to nixpkgs here.
            with import nixpkgs { system = "${system}"; };
            stdenv.mkDerivation {
              name = "hello";
              src = self;
              buildPhase = "gcc -o hello ./hello.c";
              installPhase = "mkdir -p $out/bin; install -t $out/bin hello";
            };
          default = self.packages.${system}.hello;
        };
      });
}
