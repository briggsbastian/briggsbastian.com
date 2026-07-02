{
  description = "briggsbastian.com — portfolio & thought garden";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # the static site as a derivation; cloud1's nginx serves this store path
        packages.default = pkgs.buildNpmPackage {
          pname = "briggsbastian-com";
          version = "2026.07.02";
          src = self;
          npmDepsHash = "sha256-AX95wUSDRzCCfcdbbUFoJD7R1ggcNpRZYyQbCBSDZq4=";

          nodejs = pkgs.nodejs_22;

          env.ASTRO_TELEMETRY_DISABLED = "1";

          buildPhase = ''
            runHook preBuild
            export HOME=$TMPDIR
            npm run build
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            cp -r dist $out
            runHook postInstall
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs_22
          ];

          shellHook = ''
            echo "briggsbastian.com dev shell — node $(node --version)"
          '';
        };
      });
}
