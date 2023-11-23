final: prev: {
  jetbrains = prev.jetbrains // {
    idea-ultimate = prev.jetbrains.idea-ultimate.overrideAttrs (oldAttrs: {
      src = fetchTarball {
        url = "https://download.jetbrains.com/idea/ideaIU-2023.2.5.tar.gz";
        sha256 = "13lj46vpvz342lncx147zfyh4ijgk86cwgvd51925kv6mr8bgnqh";
      };

      version = "2023.2.5";
    });
  };
}

