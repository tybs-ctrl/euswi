{
  description = "ІІТ Користувач ЦСК-1 for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    {
      nixosModules.default = import ./euswi.nix;
    };
}
