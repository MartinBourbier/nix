{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";
    autocd = false;

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      local P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r ${./p10k.zsh} ]] || source ${./p10k.zsh}
    '';

    initExtra = ''
      bindkey ";5C" forward-word
      bindkey ";5D" backward-word
      eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"
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
      gdca = "git diff --cached";
      gpf = "git push --force-with-lease --force-if-includes";
      cat = "bat";
      us = "setxkbmap us";
      intl = "setxkbmap us -variant intl";
    };
  };
}
