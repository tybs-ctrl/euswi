{ config, lib, pkgs, ... }:

let
  cfg = config.services.euswi;

  euswi = pkgs.stdenv.mkDerivation {
    pname = "euswi";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "https://iit.com.ua/download/productfiles/euswi.64.tar";
      hash = "sha256-aMybVdyX+rz6JkpBvs9qmbHGeGdx/lTulQKA4BrSfNI=";
    };

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.makeWrapper

    ];

    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.pcsclite
      pkgs.gtk3
      pkgs.glib
      pkgs.cairo
      pkgs.pango
      pkgs.atk
      pkgs.gdk-pixbuf
    ];

    unpackPhase = ''
      mkdir source
      tar -xf "$src" -C source
    '';

    installPhase = ''
      mkdir -p "$out/opt/iit/eu/sw"

      cp -r source/opt/iit/eu/sw/* \
        "$out/opt/iit/eu/sw/"
      wrapProgram "$out/opt/iit/eu/sw/euscpnmh" \
        --set LD_LIBRARY_PATH "$out/opt/iit/eu/sw"

      mkdir -p \
        "$out/etc/opt/chrome/native-messaging-hosts"

      cat > "$out/etc/opt/chrome/native-messaging-hosts/ua.com.iit.eusign.nmh.json" <<EOF
      {
        "name": "ua.com.iit.eusign.nmh",
        "description": "ІІТ Користувач ЦСК-1",
        "path": "$out/opt/iit/eu/sw/euscpnmh",
        "type": "stdio",
        "allowed_origins": [
          "chrome-extension://jffafkigfgmjafhpkoibhfefeaebmccg/"
        ]
      }
      EOF

      mkdir -p \
      "$out/etc/mozilla/native-messaging-hosts"

      cat > "$out/etc/mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json" <<EOF
      {
        "name": "ua.com.iit.eusign.nmh",
        "description": "ІІТ Користувач ЦСК-1",
        "path": "$out/opt/iit/eu/sw/euscpnmh",
        "type": "stdio",
        "allowed_extensions": [
          "eusw@iit.com.ua"
        ]
      }
      EOF
    '';

    meta = {
      description = "ІІТ Користувач ЦСК-1";
      homepage = "https://iit.com.ua/";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
{
  options.services.euswi = {
    enable = lib.mkEnableOption "ІІТ Користувач ЦСК-1";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      euswi
    ];

    services.pcscd.enable = true;

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="9301", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="9308", MODE="0666"
    '';

    environment.etc."opt/chrome/native-messaging-hosts/ua.com.iit.eusign.nmh.json".source =
      "${euswi}/etc/opt/chrome/native-messaging-hosts/ua.com.iit.eusign.nmh.json";

    environment.etc."chromium/native-messaging-hosts/ua.com.iit.eusign.nmh.json".source =
      "${euswi}/etc/opt/chrome/native-messaging-hosts/ua.com.iit.eusign.nmh.json";
    
    environment.etc."mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json".source =
      "${euswi}/etc/mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json";
  };
}
