# Introduction

So you've got a binary-only program you want to run and it's not in Nix! What can you do?

Here's a bunch of options in order of ease, it's also in reverse-order of usefulness for other nix users.

## Option 1: Create a derivation that uses patchelf to patch all the individual dependencies in the binary.

**Most useful for other Nix users.**

Most of the time you should use `autoPatchelfHook` which will automatically patch any binaries in `$out`

Using `autoPatchelfHook` is simple. You just need to include `autoPatchelfHook` in `nativeBuildInputs`:

```
{ autoPatchelfHook, ... }:

{
  ...

  nativeBuildInputs = [ ... autoPatchelfHook ];

  ...
}
```

## Option 2: Create a derivation using `buildFHSUserEnv`

This is basically a custom version of `steam-run`.

Search through nixpkgs for `buildFHSUserEnv` for people using thing


## Option 3: Use `steam-run`

Steam run sets up a normal FHS chroot environment. The nix discourt for `steam-run` has a lot of examples of people having success with this

## Option 4: Use a non-Nix container solution (like docker)

This might not work for everything, but it's very quick if the app is dockerized

# Extra Hints

- If the software is not redistributable, you will probably want to use the `requireFile` builder in nixpkgs.
- See also: https://nixos.wiki/wiki/Packaging/Binaries
