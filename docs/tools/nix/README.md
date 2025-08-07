# Nix

## Getting started

References:
* [How I Start: Nix][1]
* [Lorri][2]
* [Direnv][3]
* [Niv][4]
* [NixOS - Learn][5]

### Bootstrapping a Nix project

Initialize `niv`

```
mkdir -p <project_dir>
cd <project_dir>
niv init
# ...
tree
#.
#└── nix
#    ├── sources.json
#    └── sources.nix
#
# 1 directory, 2 files
```

Initialize `lorri`, make sure `lorri daemon` already running

```
lorri init
# direnv: error <project_root>/<project_dir>/.envrc is blocked. Run `direnv allow` to approve its content
```

Review `.envrc` file, then approve

```
direnv allow
```

Customize `shell.nix` to use local source from niv

```
# shell.nix
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.hello
  ];
}
```

## TODO

* [home-manager](https://github.com/nix-community/home-manager)
* Nix on MacOS documentation

[1]: https://christine.website/blog/how-i-start-nix-2020-03-08
[2]: https://github.com/target/lorri
[3]: https://github.com/direnv/direnv
[4]: https://github.com/nmattia/niv
[5]: https://nixos.org/learn.html
