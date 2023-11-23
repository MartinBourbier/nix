{ config, pkgs, ... }:
{
  home.username = "martin";
  home.homeDirectory = "/home/martin";
  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zsh
    zsh-powerlevel10k
    git
    htop
    meslo-lgs-nf
    xsel
    nixpkgs-fmt
    discord
    (jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
      src = fetchTarball {
        url = "https://download.jetbrains.com/idea/ideaIU-2023.2.5.tar.gz";
        sha256 = "13lj46vpvz342lncx147zfyh4ijgk86cwgvd51925kv6mr8bgnqh";
      };

      version = "2023.2.5";
    }))
  ];

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      local P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';

    plugins = with pkgs; [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ./p10k.zsh; # Some directory containing your p10k.zsh file
      }
    ];
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 10;
          y = 10;
        };
        decorations = "full";
        opacity = 1.0;
        startup_mode = "Windowed";
        title = "Alacritty";
        dynamic_title = true;
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };
      font = {
        normal = {
          family = "MesloLGS NF";
          style = "regular";
        };
        glyph_offset = {
          x = 0;
          y = 0;
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "martin.bourbier";
    userEmail = "martin.bourbier@epita.fr";
    signing = {
      key = "555B81DD70BC278778104D82050994FE5A4B2D54";
      signByDefault = true;
    };
  };
}
