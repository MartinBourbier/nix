{ pkgs, ... }:
{
  programs.delta.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Martin Bourbier";
        email = "mbourbier28@gmail.com";
      };
    };
  };
}
