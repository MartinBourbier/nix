{ config, pkgs, lib, ... }:

{
  imports = [
    ./sound.nix
  ];

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc.options = "--delete-older-than 10d";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Paris";

  users.users.martin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$ngilX9AlW9fg2kaR8rDlb/$i8laymiLD2lRPwO2is6pRwlCpGC/NO0V7cZZ8A/.cz0";
  };

  programs.zsh.enable = true;

  services.gvfs.enable = true;
  services.openssh.enable = true;
  services.printing.enable = true;
  services.xserver = {
    enable = true;
    windowManager.i3.enable = true;
    libinput.enable = true;
    xkb.options = "caps:swapescape";
  };

  environment.systemPackages = with pkgs; [
    arandr
    evince
    file
    linux-manual
    man-pages
    man-pages-posix
    (wrapFirefox firefox-unwrapped {
      extraPolicies = {
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
        FirefoxHome = {
          Search = false;
          TopSites = false;
          Highlights = false;
          Pocket = false;
          Snippets = false;
        };
        Homepage = {
          StartPage = "none";
        };
        NewTabPage = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OverrideFirstRunPage = "";
        PasswordManagerEnabled = false;
        Bookmarks = [
          {
            Title = "Google";
            URL = "https://google.com";
            Favicon = "https://google.com/favicon.ico";
            Placement = "toolbar";
          }
        ];
      };
    })
    zoxide
  ];

  documentation = {
    enable = true;
    man.enable = true;
    dev.enable = true;
  };

  # Allows ccls to work with system headers without compile db
  environment.variables = {
    CPATH = lib.mkForce (builtins.concatStringsSep ":" [
      (lib.makeSearchPathOutput "dev" "include" [ pkgs.stdenv.cc.cc.lib ])
    ]);
  };
}
