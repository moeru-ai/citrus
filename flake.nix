{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # config.cudaSupport = true;
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        venvDir = ".venv";

        env = {
          LD_LIBRARY_PATH = lib.makeLibraryPath (
            with pkgs;
            [
              stdenv.cc.cc.lib
              # libz # pandas (numpy)
            ]
          );
        };

        postShellHook = "uv sync";

        packages = with pkgs.python313Packages; [
          # uv
          venvShellHook
        ];
      };
    };
}
