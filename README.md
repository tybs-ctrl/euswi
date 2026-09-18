NixOS flake-модуль для встановлення та налаштування бібліотеки «ІІТ Користувач ЦСК-1».
Працює з Google Chrome, Chromium, Firefox.

Для встановлення редагуємо flake:

```nix
{
  inputs = {
    euswi.url = "github:tybs-ctrl/euswi";
  };

  outputs = { self, nixpkgs, euswi, ... }:
  {
    nixosConfigurations.my-pc = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./configuration.nix
      euswi.nixosModules.default
      {
        services.euswi.enable = true;
      }
      ];
    };
  };
}

```

Для роботи з Firefox треба окремо скопіювати/злінкувати Native Messaging Manifest, що знаходиться за шляхом /etc/mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json, до шляху ~/.mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json.

Зробити це однією командою:
```bash
mkdir -p ~/.mozilla/native-messaging-hosts && ln -sf /etc/mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json ~/.mozilla/native-messaging-hosts/ua.com.iit.eusign.nmh.json
```
