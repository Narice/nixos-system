{
  inputs = {
    #nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    #nixos-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    nixos-20-09.url = "github:NixOS/nixpkgs/nixos-20.09";

    #nixos-20-09-small.url = "github:NixOS/nixpkgs/nixos-20.09-small";

    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    #home-manager-unstable = {
    #  url = "github:nix-community/home-manager/master";
    #  inputs.nixpkgs.follows = "/nixos-unstable";
    #};

    home-manager-20-09 = {
      url = "github:nix-community/home-manager/release-20.09";
      inputs.nixpkgs.follows = "/nixos-20-09";
    };
  };

  outputs = inputs:
  let
    os = inputs.nixos-20-09;
    hm = inputs.home-manager-20-09;
    pkgs = import os {
      system = "x86_64-linux";
      config = {
        allowUnfreePredicate = pkg: builtins.elem (os.lib.getName pkg) [
          # System Unfree Packages
          #"nvidia-x11"
          #"nvidia-settings"
          #"nvidia-persistenced"
          "teamviewer"
        ];

        packageOverrides = super: {
          openrazer-daemon = super.openrazer-daemon.overrideAttrs (old: {
            version = "2.9.0";
            src = super.fetchFromGitHub {
              owner = "openrazer";
              repo = "openrazer";
              rev = "v2.9.0";
              sha256 = "1js7hq7zx5kj99brffrfaaah283ydkffmmrzsxv4mkd3nnd6rykk";
            };
          });
          picom = super.picom.overrideAttrs (old: {
            version = "ibhagwan";
            src = super.fetchFromGitHub {
              owner = "ibhagwan";
              repo = "picom";
              rev = "60eb00ce1b52aee46d343481d0530d5013ab850b";
              sha256 = "sha256-PDQnWB6Gkc/FHNq0L9VX2VBcZAE++jB8NkoLQqH9J9Q=";
            };
          });
        };
      };
    };
  in
  {
    nixosConfigurations = {
      narice-pc = os.lib.nixosSystem {

        system = "x86_64-linux";

        specialArgs = {
          inherit pkgs;
        };

        modules = [ 
          ./base.nix

          hm.nixosModules.home-manager

          ({config, pkgs, lib, ...}:{

            networking = {
              hostName = "narice-pc";
              interfaces.eno1.useDHCP = true;
            };

            system.configurationRevision =
              if inputs.self ? rev
              then inputs.self.rev
              else throw "Refusing to build from a dirty Git tree";

            nix.registry.nixpkgs.flake = os;

            home-manager = {
              users.narice = import home/narice.nix;
              users.monasbook = import home/monasbook.nix;
            };
          })
        ];
      };

      narice-hp = os.lib.nixosSystem {

        system = "x86_64-linux";

        specialArgs = {
          inherit pkgs;
        };

        modules = [ 
          ./base.nix

          hm.nixosModules.home-manager

          ({config, pkgs, lib, ...}:{

            networking = {
              hostName = "narice-hp";
              #interfaces.eno1.useDHCP = true;
              wireless.enable = true;
            };

            system.configurationRevision =
              if inputs.self ? rev
              then inputs.self.rev
              else throw "Refusing to build from a dirty Git tree";

            nix.registry.nixpkgs.flake = os;

            home-manager = {
              useGlobalPkgs = true;
              users.narice = import home/narice.nix;
            };
          })
        ];
      };
    };
  };
}
