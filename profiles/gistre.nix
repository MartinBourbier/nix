{ config, pkgs, ... }:

let
  esp32-toolchain = pkgs.fetchzip {
    url = "https://github.com/espressif/arduino-esp32/releases/download/2.0.16/esp32-2.0.16.zip";
    sha256 = "sha256-ybG2tDeAmUWMg7X8fISvIQXwiOO6K0ZkSqc7cvAwyHo=";
  };
  arduino-core-esp32 = pkgs.arduino-core.overrideAttrs (oldAttrs: rec {
    pname = "arduino-core-esp32";

    buildInputs = [
      (pkgs.python3.withPackages (pyPkgs: with pyPkgs; [
        pyserial
      ]))
    ];
    installPhase = ''
      ${builtins.trace (builtins.attrNames oldAttrs)}
      touch $out/here
    '';
  });

  aarch64-none-elf = pkgs.stdenv.mkDerivation rec {
    pname = "gcc-aarch64-none-elf";
    version = "12.3.rel1";

    suffix = {
      x86_64-linux = "x86_64";
    }.${pkgs.stdenv.hostPlatform.system} or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}");

    src = pkgs.fetchurl {
      url = "https://developer.arm.com/-/media/Files/downloads/gnu/${version}/binrel/arm-gnu-toolchain-${version}-${suffix}-aarch64-none-elf.tar.xz";
      sha256 = {
        x86_64-linux = "sha256-OCyMeGKF5BW8D/TfRj4QH3bW9pqJSwPxMjaBR8N/C6c=";
      }.${pkgs.stdenv.hostPlatform.system} or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}");
    };

    dontConfigure = true;
    dontBuild = true;
    dontPatchELF = true;
    dontStrip = true;

    installPhase = ''
      mkdir -p $out
      cp -r * $out
    '';

    preFixup = ''
      find $out -executable -type f | while read f; do
        patchelf "$f" > /dev/null 2>&1 || continue
        patchelf --set-interpreter $(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker) "$f" || true
        patchelf --set-rpath ${pkgs.lib.makeLibraryPath [ "$out" pkgs.stdenv.cc.cc pkgs.ncurses5 pkgs.python3 pkgs.expat ]} "$f" || true
      done
    '';

    meta = with pkgs.lib; {
      description = "Pre-built GNU toolchain from ARM Cortex-A processors";
      homepage = "https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a";
      platforms = [ "x86_64-linux" ];
    };
  };

  stm32cube = pkgs.stdenv.mkDerivation {
    pname = "stm32cube-ide";
    version = "0.0.1";

    src = ./st-stm32cubeide_1.15.0_20695_20240315_1429_amd64.sh;

    autoPatchelfIgnoreMissingDeps = [
      "libavcodec.so.54"
      "libavcodec.so.56"
      "libavcodec.so.57"
      "libavcodec.so.58"
      "libavformat.so.54"
      "libavformat.so.56"
      "libavformat.so.57"
      "libavformat.so.58"
      "libavcodec-ffmpeg.so.56"
      "libavformat-ffmpeg.so.56"
    ];

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      qt6.wrapQtAppsHook
      makeWrapper
      wrapGAppsHook

      cairo
      dbus
      libglvnd
      libGL
      fontconfig
      freetype
      libgcc
      glib
      gtk3
      gtk2-x11
      pcsclite
      pango
      ncurses5
      qt6.qtbase
      qt6.qtwayland
      alsa-lib
      libxkbcommon
      xorg.libX11
      xorg.libXcursor
      xorg.xcbutil
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXtst
      libz
      xercesc

      stm32cubemx
    ];

    unpackPhase = ''
      $src --noexec --target extract
    '';

    installPhase = let libPath = pkgs.lib.makeLibraryPath [ pkgs.gtk3 pkgs.gtk4 pkgs.glib pkgs.cairo ]; in ''
      mkdir -p $out/bin
      tar xvf extract/st-stm32cubeide*.tar.gz -C $out
      wrapProgram "$out/stm32cubeide" \
          --prefix LD_LIBRARY_PATH : ${libPath}
      ln -s "$out/stm32cubeide" "$out/bin/stm32cubeide"
    '';
  };

  platformio-patch-pkgs = import
    (builtins.fetchTarball {
      name = "pinned-nixpkgs-platformio";
      url = "https://github.com/NixOS/nixpkgs/archive/3592b10a67b518700002f1577e301d73905704fe.tar.gz";
      sha256 = "135sxn5xxw4dl8hli4k6c9rwpllwghwh0pnhvn4bh988rzybzc6z";
    })
    { system = "x86_64-linux"; };

  platformio-python = platformio-patch-pkgs.python3.withPackages (ps: with ps; [ platformio ]);

  platformio-fhs = pkgs.buildFHSEnv {
    name = "platformio-fhs";

    targetPkgs = pk: (with pk; [
      platformio-core
      platformio-python
      openocd
    ]);

    runScript = "env LD_LIBRARY_PATH=bash";
  };
in
{
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.martin.extraGroups = [ "dialout" "libvirtd" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="09fb", ATTRS{idProduct}=="6001", GROUP="dialout", MODE="0666", SYMLINK+="usbblaster"
    SUBSYSTEMS=="usb", ATTRS{idProduct}=="7523", ATTRS{idVendor}=="1a86", SYMLINK+="espcam", GROUP="dialout"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", GROUP="dialout"
  '';

  services.udev.packages = [
    pkgs.platformio-core
    pkgs.openocd
  ];

  environment.systemPackages = with pkgs; [
    (rstudioWrapper.override { packages = with rPackages; [ corrplot FactoMineR MASS ]; })
    heptagon
    kicad
    quartus-prime-lite

    arduino

    # STM32 dev
    stm32cubemx
    putty
    gcc-arm-embedded
    gnumake
    openocd
    screen

    urjtag

    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        ms-vscode.cpptools
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "platformio-ide";
          publisher = "platformio";
          version = "3.3.3";
          sha256 = "sha256-pcWKBqtpU7DVpiT7UF6Zi+YUKknyjtXFEf5nL9+xuSo=";
        }
      ];
    })
    (platformio-patch-pkgs.python3.withPackages (ps: with ps; [ platformio ]))
    avrdude

    stlink

    # platformio-fhs
  ] ++ [
    # arduino-core-esp32
    aarch64-none-elf
    stm32cube

    # platformio-fhs
    # pkgs.platformio-core
  ];
}
