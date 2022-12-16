extends Spatial

export(int, 1, 100, 1) var seconds_between_moves := 1

onready var nav: Navigation = get_node("%Navigation")
onready var top_left: Position3D = get_node("%CityBound_TopLeft")
onready var bottom_right: Position3D = get_node("%CityBound_BottomRight")

var timer := 0.0
var world_centre : Vector3
var world_size : Vector3
var city_radius := 100.0

var next_ped_idx := 0

var animsets = preload("res://scenes/character/people_anims.tres")

func point_in_radius(radius):
    return Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius))

func _ready():
    world_size = top_left.global_translation - bottom_right.global_translation
    city_radius = world_size.length() * 0.6
    world_centre = top_left.global_translation.linear_interpolate(bottom_right.global_translation, 0.5)
    var idx := 0
    for ped in get_children():
        ped.nav = nav

        idx = (idx + 1) % animsets.people_anims.size()
        var loves_water = animsets.people_love_water[idx]
        var anim = animsets.people_anims[idx]
        ped.init_pedestrian(anim, loves_water)

    yield(get_tree().create_timer(0.1), "timeout")

    for ped in get_children():
        _nav_to_random_point(ped)


func _process(dt):
    timer -= dt
    if timer > 0:
        return
    timer = seconds_between_moves

    next_ped_idx += 1
    if next_ped_idx >= get_child_count():
        next_ped_idx = 0
    var ped := get_child(next_ped_idx)
    _nav_to_random_point(ped)

func _nav_to_random_point(ped):
    var point = point_in_radius(city_radius)
    var target_point = nav.get_closest_point(point + world_centre)
    ped.navigate_to_point(target_point)
