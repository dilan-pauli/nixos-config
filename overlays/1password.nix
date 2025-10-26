final: prev: {
  # Override 1Password GUI to use the latest version
  _1password-gui = prev._1password-gui.overrideAttrs (finalAttrs: previousAttrs: {
    version = "8.11.14";
    src = prev.fetchurl {
      url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-${finalAttrs.version}.x64.tar.gz";
      hash = "sha256-LdGw2AVDiQXwGAz9abEeoCosQUdr5q978OMo+kXATIc=";
    };
  });

  # Override 1Password CLI to use the latest version
  _1password-cli = prev._1password-cli.overrideAttrs (finalAttrs: previousAttrs: {
    version = "2.32.0";
    src = prev.fetchurl {
      url = "https://cache.agilebits.com/dist/1P/op2/pkg/v${finalAttrs.version}/op_linux_amd64_v${finalAttrs.version}.zip";
      hash = "sha256-aOMUGxGtOLpQBPtA1xNxtxDAu/lHM/DfkYB2gzb5AJc=";
    };
    nativeBuildInputs = (previousAttrs.nativeBuildInputs or []) ++ [ prev.unzip ];
    sourceRoot = ".";
  });
}
