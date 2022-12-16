extends Resource

class_name PeopleAnims

export(Array, SpriteFrames) var people_anims
export(Array, bool) var people_love_water

func _init(anim_set = null, want_water = null):
    people_anims = anim_set
    people_love_water = want_water

