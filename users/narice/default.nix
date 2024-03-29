{ usrSuites, pkgs, ... }:
{
  home-manager.users.narice = { lib, config, ... }: {
    imports = usrSuites.all;

    home.stateVersion = "22.11";

    home.packages = with pkgs; [
      ark
      audacity
      bat
      brightnessctl
      chessx
      # cura
      # (discord.override { nss = nss; })
      distrho
      docker-compose
      libsForQt5.dolphin
      deadd-notification-center
      drawio
      exa
      exfat
      fd
      feh
      ffmpeg
      flameshot
      freerdp
      fzf
      ghostscript
      git
      git-crypt
      gnome.zenity
      gnome3.gnome-calculator
      gnome3.seahorse
      gparted
      gtklock
      hardinfo
      htop
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.fr-any
      imagemagick
      isync
      jq
      openscad
      keepassxc
      killall
      languagetool
      libtool
      lm_sensors
      lxappearance
      mpv
      mu
      neofetch
      neovim
      networkmanagerapplet
      nix-du
      nix-index
      nix-prefetch
      nix-prefetch-github
      nmap
      ntfs3g
      openssl
      pandoc
      pass
      pavucontrol
      pciutils
      peek
      playerctl
      procs
      psensor
      radeon-profile
      ranger
      ripgrep
      ripgrep-all
      rnix-lsp
      (rofi-wayland.override { plugins = with pkgs; [ rofi-calc rofi-emoji ]; })
      slurp
      stremio
      swappy
      sway-contrib.grimshot
      swaynotificationcenter
      tealdeer
      thunderbird
      tokei
      tree
      unar
      unzip
      virt-manager
      w3m
      wev
      wget
      wine
      wl-clipboard
      wpaperd
      wofi
      x2goclient
      xclip
      xdotool
      xorg.xev
      xorg.xwininfo
      xournalpp
      youtube-dl
      #yuzu-ea
      zathura
      zip
      zoom-us
    ];

    programs = {
      emacs = {
        enable = true;
        package = pkgs.emacs29-pgtk;
        extraPackages = (epkgs: with epkgs; [ vterm pdf-tools ]);
      };

      alacritty.enable = true;
      qutebrowser = {
        enable = true;
        package = pkgs.qutebrowser-qt6.override { enableWideVine = true; };
        loadAutoconfig = true;
        settings = {
          content.javascript.clipboard = "access";
        };
        aliases = {
          mpv = "spawn --userscript view_in_mpv";
          pw = "spawn --userscript qute-keepassxc --key Narice";
        };
        keyBindings = {
          insert = {
            "<Ctrl+Alt+p>" = "pw";
          };
          normal = {
            "pw" = "pw";
          };
        };
        extraConfig = ''
          import catppuccin

          catppuccin.setup(c, 'mocha')
        '';
      };
      firefox.enable = true;
      waybar = {
        enable = true;
        package = pkgs.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      };
    };

    services = {
      kdeconnect = {
        enable = true;
        indicator = true;
      };

      emacs = {
        enable = true;
        client.enable = true;
      };

      # syncthing = {
      #   enable = true;
      #   tray = {
      #     enable = true;
      #   };
      # };
    };

    xdg.configFile =
      let
        conf = ./dotfiles/xdg;
      in
      {
        "alacritty".source = "${conf}/alacritty";
        "i3".source = "${conf}/i3";
        "sway".source = "${conf}/sway";
        "swaync".source = "${conf}/swaync";
        "hypr".source = "${conf}/hypr";
        "zathura".source = "${conf}/zathura";
        "qutebrowser/catppuccin".source = "${conf}/qutebrowser/catppuccin";
        # "nvim".source = "${conf}/nvim";
        "rofi".source = "${conf}/rofi";
        "waybar".source = "${conf}/waybar";
        "wpaperd".source = "${conf}/wpaperd";
        "deadd".source = "${conf}/deadd";
        "background".source = "${conf}/background";
        "gtklock".source = "${conf}/gtklock";
        "xfce4" = {
          source = config.lib.file.mkOutOfStoreSymlink "${conf}/xfce4";
          recursive = true;
        };
        # This fixed dolphin not following the background set by the gtk theme
        # for sweet theme: 22,25,37
        # for materia: 24,24,24
        "kdeglobals".text = ''
          [Colors:View]
          BackgroundNormal=24,24,24
        '';
      };

    home.file =
      let
        home = ./dotfiles/home;
        doom = ./dotfiles/doom;
        bin = ./dotfiles/bin;
        apps = ./dotfiles/apps;
      in
      {
        ".face".source = "${home}/.face";
        ".gitconfig".source = "${home}/.gitconfig";
        ".p10k.zsh".source = "${home}/.p10k.zsh";
        # ".vimrc".source = "${home}/.vimrc";
        ".zshrc".source = "${home}/.zshrc";
        ".zshenv".source = "${home}/.zshenv";
        ".xprofile".source = "${home}/.xprofile";
        ".doom.d" = {
          source = config.lib.file.mkOutOfStoreSymlink "${doom}";
          recursive = true;
        };
        ".local/bin" = {
          source = "${bin}";
          recursive = true;
        };
        ".local/share/applications" = {
          source = "${apps}";
          recursive = true;
        };
        ".xournalpp" = {
          source = "${home}/xournalpp";
          recursive = true;
        };
      };

    gtk = {
      enable = true;
      font = {
        package = pkgs.ubuntu_font_family;
        name = "Ubuntu";
        size = 14;
      };
      cursorTheme = {
        package = pkgs.qogir-icon-theme;
        name = "Qogir";
        size = 24;
      };
      # FIXME: not applied correctly on xfce
      iconTheme = {
        #package = pkgs.candy-icon-theme;
        #name = "candy-icons";
        package = pkgs.papirus-icon-theme;
        name = "Papirus";
      };
      theme = {
        package = pkgs.materia-theme;
        name = "Materia-dark-compact";
        # package = pkgs.adapta-gtk-theme;
        # name = "Adapta-Nokto-Eta";
        #package = pkgs.sweet; # TODO: add murrine engine to gtk | opened issue on it
        #name = "Sweet-Dark";
        #package = pkgs.plata-theme;
        #name = "Plata-Noir-Compact";
        # package = pkgs.canta-theme;
        # name = "Canta-dark-compact";
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style.name = "gtk2";
    };

    home.sessionVariables = {
      TERMINAL = "alacritty";
      EDITOR = "emacsclient -cn";
      VISUAL = "emacsclient -cn";
      NIX_BUILD_SHELL = "${pkgs.zsh}/bin/zsh";
      PATH = "$PATH:$HOME/.emacs.d/bin:$HOME/.local/bin";
    };

    # xsession = {
    #   enable = false;
    #   windowManager.command = ''
    #     ${pkgs.i3-gaps}/bin/i3 &
    #     waitPID=$!


    #     # Start the desktop manager.
    #     ${pkgs.bash}/bin/bash ${pkgs.xfce.xfce4-session}/etc/xdg/xfce4/xinitrc &
    #     waitPID=$!


    #     ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all


    #     test -n "$waitPID" && wait "$waitPID"

    #     /run/current-system/systemd/bin/systemctl --user stop graphical-session.target

    #     exit 0
    #   '';
    #   # FIXME: pointerCursor config not taken into account
    #   pointerCursor = {
    #     package = pkgs.qogir-icon-theme;
    #     name = "Qogir";
    #   };
    # };

    xresources.extraConfig = (builtins.readFile ./dotfiles/home/mocha.Xresources) + ''

      URxvt.font: xft:Hack Nerd Font:size=12
      URxvt.depth: 32

      XTerm*faceName: Hack Nerd Font
      XTerm*faceSize: 12

      Xft.dpi: 96
      Xft.antialias: true
      Xft.hinting: true
      Xft.rgba: rgb
      Xft.autohint: false
      Xft.hintstyle: hintslight
      Xft.lcdfilter: lcddefault
    '';

    # TODO: firefox config?
    # TODO: discord config?
    # TODO: mellowdream config?
    # TODO: keepass config? probably unsafe
    # TODO: change lock mechanism to light-lock
  };

  users.users.narice = {
    uid = 1000;
    description = "Narice";
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "libvirtd" "docker" "audio" "networkmanager" "video" "dialout" "input" ];
    hashedPassword =
      "$6$Gdi6PgGv5c/NLe$Xcp9rJ8MZZetBiuhoy2C0LU8KhHXj3PwLVUjlsKx9/GPaveAXH53gOHBNu8Fp0DQqqR1xpr1tg7yZEF7X7crA0";
  };
}
