extends Spatial

export(int, 1, 1000, 1) var city_radius := 100
export(int, 1, 100, 1) var seconds_between_moves := 5

onready var nav: Navigation = get_node("%Navigation")

var timer := 0.0

func point_in_radius(radius):
    return Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius))

func _ready():
    var nav: Navigation = get_node("%Navigation") as Navigation
    for c in get_children():
        c.nav = nav


func _process(dt):
    timer -= dt
    if timer > 0:
        return
    timer = seconds_between_moves

    var point = point_in_radius(city_radius)
    var target_point = nav.get_closest_point_to_segment(Vector3(0,100,0), point)
    for c in get_children():
        c.navigate_to_point(target_point)
