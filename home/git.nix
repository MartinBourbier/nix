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
            # 6111444905B07655EA63D1022D7CF9F257FDB16E
            signingKey = "6111444905B07655EA63D1022D7CF9F257FDB16E";
          };
          commit.gpgsign = true;
          delta.enable = true;
        };
      }
    ];
  };
}
