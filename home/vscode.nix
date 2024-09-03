{ pkgs, vscode-marketplace, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      bradlc.vscode-tailwindcss
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      hashicorp.terraform
      ms-azuretools.vscode-docker
      mskelton.npm-outdated
      mskelton.one-dark-theme
      oderwat.indent-rainbow
      vscodevim.vim
    ] ++ (with vscode-marketplace; [
      bmd.stm32-for-vscode
      dsznajder.es7-react-js-snippets
      ecmel.vscode-html-css
      mohd-akram.vscode-html-format
      ms-vscode.cpptools
      ms-vscode.vscode-typescript-next
      react-utilities.react-utilities
      platformio.platformio-ide
    ]);
  };
}
