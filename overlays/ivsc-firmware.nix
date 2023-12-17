final: prev: {
  ivsc-firmware = prev.ivsc-firmware.overrideAttrs (oldAttrs: {
    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/firmware/vsc
      cp --no-preserve=mode --recursive ./firmware/* $out/lib/firmware/vsc/

      runHook postInstall
    '';
  });
}
