{ config, pkgs, ... }:

{
  services.pcscd.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gtk2";
  };

  environment.shellInit = ''
    if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    fi
  '';
}
