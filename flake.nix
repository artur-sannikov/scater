{
  description = "Nix Flake for scater R package";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        scater = pkgs.rPackages.buildRPackage {
          name = "scater";
          src = self;
          propagatedBuildInputs = builtins.attrValues {
            inherit (pkgs.rPackages)
              BiocGenerics
              BiocNeighbors
              BiocParallel
              BiocSingular
              DelayedArray
              Matrix
              MatrixGenerics
              RColorBrewer
              RcppML
              Rtsne
              S4Vectors
              SingleCellExperiment
              SparseArray
              SummarizedExperiment
              beachmat
              ggbeeswarm
              ggrastr
              ggrepel
              pheatmap
              rlang
              scuttle
              uwot
              viridis
              ;
          };
        };
      in
      {
        packages.default = scater;
        devShells.default = pkgs.mkShell {
          buildInputs = [ scater ];
          inputsFrom = pkgs.lib.singleton scater;
        };
      }
    );
}
