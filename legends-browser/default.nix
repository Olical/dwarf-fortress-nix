{ lib, buildEnv, writeShellScriptBin, fetchurl, jre }:

let
  name = "legends-browser-${version}";
  version = "1.19.2";

  jar = fetchurl {
    url = "https://github.com/robertjanetzko/LegendsBrowser/releases/download/${version}/legendsbrowser-${version}.jar";
    sha256 = "1pxp79ik9vyn0scd3znkg97gm4b2ljxd06jhvl57sihsghignjwf";
  };

  script = writeShellScriptBin "legends-browser" ''
    set -eu
    BASE="$HOME/.local/share/df_linux/legends-browser/"
    mkdir -p "$BASE"
    cd "$BASE"
    if [[ ! -e legendsbrowser.properties ]]; then
      echo 'Creating initial configuration for legends-browser'
      echo "last=$(cd ..; pwd)" > legendsbrowser.properties
    fi
    ${jre}/bin/java -jar ${jar}
  '';
in

buildEnv {
  inherit name;
  paths = [ script ];

  meta = with lib; {
    description = "A multi-platform, open source, java-based legends viewer for dwarf fortress";
    maintainers = with maintainers; [ Baughn ];
    license = licenses.mit;
    platforms = platforms.all;
    homepage = "https://github.com/robertjanetzko/LegendsBrowser";
  };
}
