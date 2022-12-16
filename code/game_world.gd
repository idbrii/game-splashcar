extends Spatial

export (PackedScene) var puddle_scene
export var max_puddles = 100

var world_centre : Vector3
var world_size : Vector3
var city_radius := 100.0

onready var nav: Navigation = get_node("%Navigation")
onready var top_left: Position3D = get_node("%CityBound_TopLeft")
onready var bottom_right: Position3D = get_node("%CityBound_BottomRight")


# Called when the node enters the scene tree for the first time.
func _ready():
    world_size = top_left.global_translation - bottom_right.global_translation
    city_radius = world_size.length() * 0.6
    world_centre = top_left.global_translation.linear_interpolate(bottom_right.global_translation, 0.5)
    randomize()

    # spawn puddles
    var num_puddles = 0

    while num_puddles < max_puddles:
        var pud = puddle_scene.instance()
        var puddle_spawn_location = point_in_radius(city_radius)
        pud.global_translation = puddle_spawn_location
        #~ print(puddle_spawn_location)
        add_child(pud)
        num_puddles += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func point_in_radius(radius):
    return Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius))
