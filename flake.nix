{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          # ホスト側(/usr)のlibvipsをsharpが拾ってソースビルドに走るのを防ぐ
          SHARP_IGNORE_GLOBAL_LIBVIPS = "1";
          packages = with pkgs; [
            nodejs
            pnpm
            go
            postgresql
            sqlc
            air
          ];
        };
      }
    );
}
