extends Resource

class_name PersonAnim

class PersonAnim extends Object:
    export var anim : SpriteFrames
    export var loves_water : bool

    func _init(anim_set = null, want_water = true):
        anim = anim_set
        loves_water = want_water
