{ pkgs, ... }:
{
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
