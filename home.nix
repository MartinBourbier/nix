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

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      nvim-lspconfig
      gruvbox
    ];
    withNodeJs = true;
    extraConfig = ''
      colorscheme gruvbox

      set cc=120
      set scrolloff=5

      set mouse-=a
      set number relativenumber
      set list listchars=tab:.\ ,trail:.,extends:>,precedes:<,nbsp:_
      set autoindent expandtab tabstop=4 softtabstop=4 shiftwidth=4
      set backspace=start,eol,indent
      set hlsearch incsearch
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      local P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r ${./p10k.zsh} ]] || source ${./p10k.zsh}
    '';

    plugins = with pkgs; [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
    ];

    shellAliases = {
      gp = "git push";
      gl = "git pull";
      gpf = "git push --force-with-lease --force-if-includes";
      vim = "nvim";
    };
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
    delta.enable = true;
  };
}
