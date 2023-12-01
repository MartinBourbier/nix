{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgsMaster.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "git+https://github.com/nix-community/home-manager?ref=release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "git+https://github.com/numtide/flake-utils?ref=main";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, nixpkgsMaster, home-manager, flake-utils, nixos-hardware } @ inputs:
    let
      inherit (nixpkgs) lib;

      pkgImport = pkgs: system: withOverrides:
        import pkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = (import ./overlays);
        };

      pkgset = system: {
        pkgs = pkgImport nixpkgs system true;
        pkgsUnstable = pkgImport nixpkgsUnstable system false;
        pkgsMaster = pkgImport nixpkgsMaster system false;
      };
    in
    {
      nixosConfigurations =
        let
          nixosSystem = hostName:
            let
              system = "x86_64-linux";
            in
            lib.nixosSystem {
              inherit system;
              specialArgs = inputs;
              modules = [
                ./hosts/${hostName}
                home-manager.nixosModules.home-manager
                {
                  home-manager.useGlobalPkgs = true;
                  home-manager.useUserPackages = true;
                  home-manager.users.martin = {
                    imports = [
                      ./home
                    ];
                  };
                }
                ({
                  nixpkgs = {
                    inherit system;
                    inherit (pkgset system) pkgs;
                    overlays = (import ./overlays);
                  };
                })
              ];
            };
          hostNames = builtins.attrNames (lib.filterAttrs (n: v: v == "directory") (builtins.readDir ./hosts));
        in
        lib.genAttrs hostNames nixosSystem;
    };
}
