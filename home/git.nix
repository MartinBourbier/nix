{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "martin.bourbier";
    userEmail = "martin.bourbier@epita.fr";
    delta.enable = true;

    includes = [
      {
        condition = "gitdir:/home/martin/workspace/forge/";
        contents = {
          user = {
            name = "Martin Bourbier";
            email = "martin@forge.epita.fr";
            signingKey = "555B81DD70BC278778104D82050994FE5A4B2D54";
          };
          commit.gpgsign = true;
          delta.enable = true;
        };
      }
    ];
  };
}
