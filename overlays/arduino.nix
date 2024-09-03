final: prev:
let
  esp32-toolchain = prev.fetchUrl {
    url = "https://github.com/espressif/arduino-esp32/releases/download/2.0.16/esp32-2.0.16.zip";
  };
in
{
  arduino = prev.arduino.overrideAttrs (finalAttrs: prevAttrs: {
    buildPhase = ''
      ${prevAttrs.buildPhase}
      file_src=${esp32-toolchain}
      file_dst="build/shared/esp32-2.0.16.zip"
      mkdir -p $(dirname $file_dst)
      cp -v $file_src $file_dst
    '';
  });
}
