extends Resource

class_name AudioSet

export(Array, AudioStream) var sounds = null

func _init(sounds_ = null):
    sounds = sounds_


func choose() -> AudioStream:
    var idx: int = randi() % sounds.size()
    return sounds[idx]


func play_random(speaker):
    var pick := choose()
    speaker.set_stream(pick)
    speaker.play()
