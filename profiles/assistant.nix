{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    autoconf
    autoconf-archive
    automake
    autoreconfHook
    clang-tools
    cmake
    gcc
    gdb
    gnum4
    gnumake
    libtool
    libyamlcpp
    slack
    universal-ctags
    valgrind
  ];
  environment.variables = {
    ACLOCAL_PATH = "${pkgs.autoconf-archive}/share/aclocal:${pkgs.autoconf}/share/aclocal:${pkgs.automake}/share/aclocal:${pkgs.libtool}/share/aclocal";
  };
}
