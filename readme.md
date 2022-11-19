# Worldkit

A sandbox for making 3D games.

# Car

Using demo project from:
https://kidscancode.org/godot_recipes/3d/kinematic_car/car_base/

And assets from:
https://kenney.nl/assets/car-kit

# Template

Uses [crystal-bit/godot-game-template](https://github.com/crystal-bit/godot-game-template/) v2022.04.0.

## Features

- **Continuous Integration**:
  - Automatic desktop build (Linux, Windows, OSX, HTML5)
  - Automatic HTML5 deploy to Github pages
  - Automatic HTML5 deploy to itch.io
  - Automatic Android builds
- **Scenes loading** with graphic transitions (fade-in/out)
  - Send parameters to the new scene
  - Input prevention during scene changes
  - You can still play individual scenes for quick development
  - Singlethread & Multithread
- **Game pause** handling
- `.gitignore`
- Follows official GDScript guidelines (tested with [gdlint](https://github.com/Scony/godot-gdscript-toolkit#gdscript-toolkit))
- Compatible with other Godot addons

# How to

## Change scene

```gd
Game.change_scene("res://scenes/gameplay/gameplay.tscn")
```

![change_scene](https://user-images.githubusercontent.com/6860637/162567110-026c1979-6237-4255-bb2a-97815fc4b0c4.gif)

## Change scene and show progress bar

```gd
Game.change_scene("res://scenes/gameplay/gameplay.tscn", {
  "show_progress_bar": true
})
```

![progress](https://user-images.githubusercontent.com/6860637/162567097-81b5c54e-1ee5-42b9-a583-60764ecff069.gif)

## Change scene and pass parameters

```gd
# you can pass whatever value you like: int, float, dictionary, ...
var params = {
  "level": 4,
  "skin": 'dark'
}
Game.change_scene("res://scenes/gameplay/gameplay.tscn", params)
```

```gd
# gameplay.gd

func pre_start(params):
   print(params.level) # 4
   print(params.skin) # 'dark'
   # setup your scene here
```

To learn more about all the features, read the [wiki](https://github.com/crystal-bit/godot-game-template/wiki/2.-Features). 

## Center a Node2D into the viewport

```gd
$Sprite.position = Game.size / 2
```

Read the [wiki](https://github.com/crystal-bit/godot-game-template/wiki/) to learn more.
