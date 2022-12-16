extends Node

export var mute := false

func _ready():
    # Can't use autostart since it triggers after this point.
    if mute:
        $Music.stop()
        print("Muting music.")
    else:
        $Music.play()
