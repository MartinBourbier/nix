{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    autoconf
    autoconf-archive
    automake
    autoreconfHook
    clang-tools
    gcc
    gdb
    gnumake
    libtool
    slack
    universal-ctags
    valgrind
  ];
}
