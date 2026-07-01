# Toast Party

Have fun with this marvelous plugin for generating small toast notifications.

Toast Party is a versatile plugin for Godot that allows you to easily create toast-style notifications in your games and applications. Add an extra layer of interactivity and visual feedback to your Godot projects with ease. Bring your messages to life with Toast Party!

Plugin created by Francisco Pereira Alvarado ([gammafp](https://twitter.com/gammafp)).

Please follow me on my social networks to follow my jobs: [LINKTREE](https://linktr.ee/gammafp)

![Main Screen](/no-copy-imgs/example.gif)

## Installation:

1. Clone this repository into addons folder.
2. Enabled ToastParty, go to: Project > Project Settings > Plugins

![Drag Racing](/no-copy-imgs/toast-party-install.png)

## Use:

ToastParty is an autoload singleton and is used as follows:

```python
> ToastParty.show({
    "text": "🥑Some Text🥑",           # Text (emojis can be used)
    "bgcolor": Color(0, 0, 0, 0.7),     # Background Color
    "color": Color(1, 1, 1, 1),         # Text Color
    "gravity": "top",                   # top or bottom
    "direction": "right",               # left or center or right
    "text_size": 18,                    # [optional] Text (font) size // experimental (warning!)
    "use_font": true                    # [optional] Use custom ToastParty font // experimental (warning!)
})
```

## Thanks to 
@davcri

## License

Copyright (c) 2024 Francisco Pereira Alvarado (gammafp)

Unless otherwise specified, files in this repository are licensed under the MIT license. See [LICENSE](LICENSE) for more information.
