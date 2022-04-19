{
  # config primarly based on divnix/devos/f88acc1 and updated to divnix/devos/079adc4
  description = "A highly structured configuration database.";

  inputs =
    {
      nixos.url = "nixpkgs/nixos-unstable";
      unstable.url = "nixpkgs/nixpkgs-unstable";
      latest.url = "nixpkgs/master";

      digga.url = "github:divnix/digga";
      digga.inputs.nixpkgs.follows = "nixos";
      digga.inputs.nixlib.follows = "nixos";
      digga.inputs.home-manager.follows = "home";
      digga.inputs.deploy.follows = "deploy";

      bud.url = "github:divnix/bud";
      bud.inputs.nixpkgs.follows = "nixos";
      bud.inputs.devshell.follows = "digga/devshell";

      darwin.url = "github:LnL7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "latest";

      home.url = "github:nix-community/home-manager";
      home.inputs.nixpkgs.follows = "nixos";

      deploy.url = "github:input-output-hk/deploy-rs";
      deploy.inputs.nixpkgs.follows = "nixos";

      # TODO: research and use it
      agenix.url = "github:ryantm/agenix";
      agenix.inputs.nixpkgs.follows = "latest";

      nvfetcher.url = "github:berberman/nvfetcher";
      nvfetcher.inputs.nixpkgs.follows = "latest";

      naersk.url = "github:nmattia/naersk";
      naersk.inputs.nixpkgs.follows = "latest";

      nixos-hardware.url = "github:nixos/nixos-hardware";

      pkgs.url = "path:./pkgs";
      pkgs.inputs.nixpkgs.follows = "nixos";

      emacs.url = "github:nix-community/emacs-overlay/31e9b8c9f4d69d47625efb2510815ec5f529b20c";
      musnix-flake.url = "github:musnix/musnix";
    };

  outputs =
    inputs@
    { self
    , pkgs
    , digga
    , bud
    , nixos
    , home
    , nixos-hardware
    , nur
    , agenix
    , nvfetcher
    , deploy
    , emacs
    , musnix-flake
    , ...
    }:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = {
        allowUnfreePredicate = pkg: builtins.elem (nixos.lib.getName pkg) [
          # Narice Unfree Packages
          "discord"
          "minecraft-launcher"
          "slack"
          "steam"
          "steam-original"
          "steam-runtime"
          "teams"
          "widevine"
          "yuzu-mainline"
          "yuzu-ea"
          "zoom"
        ];
      };

      channels = {
        nixos = {
          imports = [ (digga.lib.importOverlays ./overlays) ];
          overlays = [
            pkgs.overlay # for `srcs`
            nur.overlay
            agenix.overlay
            nvfetcher.overlay
            deploy.overlay
            emacs.overlay
            ./pkgs/default.nix
          ];
        };
        unstable = { };
        latest = { };
      };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            { lib.our = self.lib; }
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            agenix.nixosModules.age
            bud.nixosModules.bud
            musnix-flake.nixosModules.musnix
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts) ];
        hosts = {
          /* set host specific properties here */
          narice-pc = { };
          astraea = {
            modules = with nixos-hardware.nixosModules; [ dell-xps-13-9310 ];
          };
        };
        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles // {
            users = digga.lib.rakeLeaves ./users;
          };
          suites = with profiles; rec {
            base = [
              core
              users.narice
              users.root
            ];
            default = [
              base
              bluetooth
              fail2ban
              fonts
              fzf
              gnome
              graphic-tablet
              i3
              keyboard
              lightdm
              musnix
              picom
              pipewire
              printing
              qt
              steam
              touchpad
              virtualization
              xfce
              xfce-i3
              zsh
            ];
            wayland = [
              base
              bluetooth
              fail2ban
              fonts
              fzf
              graphic-tablet
              keyboard
              musnix
              pipewire
              printing
              qt
              steam
              touchpad
              virtualization
              zsh
            ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importExportableModules ./users/modules) ];
        modules = [ ];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            base = [ direnv git ];
          };
        };
        # NOTE: users can be managed differently
      };

      devshell = ./shell;

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      deploy.nodes = digga.lib.mkDeployNodes self.nixosConfigurations { };

      defaultTemplate = self.templates.bud;
      templates.bud.path = ./.;
      templates.bud.description = "bud template";
    }
    //
    {
      budModules = { devos = import ./shell/bud; };
    }
  ;
}
