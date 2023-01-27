![godot-playfab logo](addons/godot-playfab/icon.png)

[![CI](https://github.com/structed/godot-playfab/workflows/CI/badge.svg?branch=main)](https://github.com/Structed/godot-playfab/actions/workflows/main.yml)
[![Discord](https://img.shields.io/discord/1020665079668166677?color=rgb%2888%2C%20101%2C%20242%29&label=Discord&logo=discord)](https://discord.gg/7K7q2YuNXe)

# godot-playfab
is an [Azure PlayFab](https://playfab.com) addon for the [Godot Engine](https://godotengine.org/). While it is very early, it is supposed to be two things:

1. A GDscript-native SDK to Azure PlayFab
2. A Godot Editor integration to administer your game

> **Note:**
>   If you feel like experimenting with Godot 4, you can use a [prerelease version of godot-playfab for Godot 4!](https://github.com/Structed/godot-playfab/tree/godot4)

## Motivation
I wanted to create an opinionated, "natural" Godot integration/SDK.
Anyone could use the C# SDK right now or use any SDK with GDnative. But these SDKs are only generated SDKs, with a lot of duplicated models, which are nothing more than an API wrapper. However, I wan it to feel natural to the environment of Godot.

So my plan is to not only create a GDScript-Native with more or less everything handcrafted,
but also use Godot's Signals and also provide in-editor tools to work with Godot.

# Need Help? Found a Bug? Have an idea for a feature?
Don't hesitate and [join our Discord](https://discord.gg/7K7q2YuNXe)! Everyone is welcome and we're looking forward to hearing from you!
Or create an [issue](/issues) directly in the repo. All your input is **very much appreciated**!


## Demo
![Demo](demo-scene.gif)

You can use the included Demo scene setup in `Scenes` to see how `godot-playfab` can be used.

## First-Time Setup
See [Initial Setup](./docs/user/initial-setup.md)

## Using `godot-playfab` in your Game
See [Usage](./docs/user/usage.md)

### Connecting Signals
See [Connecting Signals](./docs/user/connecting-signals.md)

## Usage Guide & Examples
See the [User Documentation](docs/user/README.md)

## Maintainer Documentation
See [Maintainer Documentation](docs/README.md).

# Thanks
Thanks to [lentsius-bark](https://github.com/lentsius-bark) for the wonderful re-design of the logo and splash screen ❤
