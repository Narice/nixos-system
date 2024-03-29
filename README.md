[![MIT License](https://img.shields.io/github/license/divnix/devos)][mit]
[![NixOS](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=NixOS&logoColor=white)](https://nixos.org)

# Things to do before installation

- create your partitions
- fork this project
- create your user or rename mine

# Things to do after installation

## XFCE

You need to deactivate the xfdestop on the first boot.
To do that, go to the xfce settings (`Settings` -> `Settings Manager`), then to `Session and Startup`.
From there, you will go to the `Current Session` tab.
On this tab you will see a list of processes.
For the `xfdestop` process, switch the `Restart Style` from `Immediately` to `Never`.
Make sure you have the `xfdesktop` selected and then tap on `Quit Program` on the bottom left.

## SSH

Don't forget to transfer your SSH keys.

## Firefox

You can transfer your firefox profile to the new machine/setup.
To do this, you can simply transfer the `~/.mozilla/firefox` folder.
If it does not work, open an issue.

## Doom Emacs

You have to install doom emacs yourself.
If you kept my user config, then the `.doom.d` folder is already present,
so you just have to do the installation (clone + doom install)

## Asking Questions!

If you have any, open an issue!
If it's not clear, it can be made better so just open an issue :smile:

---

Following is DevOS readme. it covers how devos works, what it does
and what is the installation process.

# Introduction
DevOS grants a simple way to use, deploy and manage [NixOS][nixos] systems for
personal and productive use. A sane repository structure is provided,
integrating several popular projects like [home-manager][home-manager],
[devshell][devshell], and [more](./doc/integrations).

Striving for ___nix first™___ solutions with unobstrusive implementations,
a [flake centric][flake-doc] approach is taken for useful conveniences such as
[automatic source updates](./pkgs#automatic-source-updates).

Skip the indeterminate nature of other systems, _and_ the perceived
tedium of bootstrapping Nix. It's easier than you think!

### Status: Alpha
A lot of the implementation is less than perfect, and huge
[redesigns](https://github.com/divnix/devos/issues/152) _will_ happen. There
are unstable versions (0._x_._x_) to help users keep track of changes and
progress.

## Getting Started
Check out the [guide](https://devos.divnix.com/start) to get up and running.

## In the Wild
The author maintains his own branch, so you can take inspiration, direction, or
make critical comments about the [code][please]. 😜

## Motivation
NixOS provides an amazing abstraction to manage our environment, but that new
power can sometimes bring feelings of overwhelm and confusion. Having a turing
complete system can easily lead to unlimited complexity if we do it wrong.
Instead, we should have a community consensus on how to manage a NixOS system
and its satellite projects, from which best practices can evolve.

___The future is declarative! 🎉___

## Upstream
I'd love to see this in the nix-community should anyone believe its reached a
point of maturity to be generally useful, but I'm all for waiting until
1.0[#121](https://github.com/divnix/devos/issues/121) to save the cache work,
too.

## Community Profiles
There are two branches from which to choose: [core][core] and
[community][community]. The community branch builds on core and includes
several ready-made profiles for discretionary use.

Every package and NixOS profile declared in community is uploaded to
[cachix](./integrations/cachix.md), so everything provided is available
without building anything. This is especially useful for the packages that are
[overridden](./concepts/overrides.md) from master, as without the cache,
rebuilds are quite frequent.

## Inspiration & Art
- [hlissner/dotfiles][dotfiles]
- [nix-user-chroot](https://github.com/nix-community/nix-user-chroot)
- [Nickel](https://github.com/tweag/nickel)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
- [devshell](https://github.com/numtide/devshell)

# License
DevOS is licensed under the [MIT License][mit].

[nix]: https://nixos.org/manual/nix/stable
[mit]: https://mit-license.org
[nixos]: https://nixos.org/manual/nixos/stable
[home-manager]: https://nix-community.github.io/home-manager
[flakes]: https://nixos.wiki/wiki/Flakes
[flake-doc]: https://github.com/NixOS/nix/blob/master/src/nix/flake.md
[core]: https://github.com/divnix/devos
[community]: https://github.com/divnix/devos/tree/community
[dotfiles]: https://github.com/hlissner/dotfiles
[devshell]: https://github.com/numtide/devshell
[please]: https://github.com/nrdxp/devos/tree/nrd
