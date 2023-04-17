{
  # Use the unstable nixpkgs to use the latest set of node packages
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/master";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      nodejs_setup = ''
        # export NODE_PATH=$PWD/.nix/nodejs
        # export NPM_CONFIG_PREFIX=$PWD/node_modules
        export PATH=$PWD/node_modules/.bin:$PATH
        # mkdir -p $NODE_PATH
      '';
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nodejs 
        ] ++ (with pkgs.nodePackages; [
          # pnpm
          yarn
          typescript
          typescript-language-server
          vscode-langservers-extracted # html, css, js (eslint)
        ]);
        shellHook = ''
          # ${nodejs_setup}
          # .pnpm-store
          yarn install
        '';
      };
    });
}
