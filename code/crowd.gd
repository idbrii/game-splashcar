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


func point_in_radius(radius):
    return Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius))

func _ready():
    world_size = top_left.global_translation - bottom_right.global_translation
    city_radius = world_size.length() * 0.6
    world_centre = top_left.global_translation.linear_interpolate(bottom_right.global_translation, 0.5)
    var nav: Navigation = get_node("%Navigation") as Navigation
    for c in get_children():
        c.nav = nav


func _process(dt):
    timer -= dt
    if timer > 0:
        return
    timer = seconds_between_moves

    var point = point_in_radius(city_radius)
    var target_point = nav.get_closest_point_to_segment(Vector3(0,100,0), point + world_centre)
    next_ped_idx += 1
    if next_ped_idx >= get_child_count():
        next_ped_idx = 0
    var c := get_child(next_ped_idx)
    c.navigate_to_point(target_point)
