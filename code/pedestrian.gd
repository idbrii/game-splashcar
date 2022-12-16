# Based on godot sample: 3D Navmesh Demo
# https://godotengine.org/asset-library/asset/124
extends KinematicBody

class_name Pedestrian




const SPEED = 10.0

var m = SpatialMaterial.new()

var path = []
export var show_path := true
export(Resource) var cheers # AudioSet
export(Resource) var boos # AudioSet

var nav: Navigation
onready var camera: Spatial = get_viewport().get_camera()
var loves_water := true

var is_wet := false


func init_pedestrian(anim: SpriteFrames, loves_water_: bool):
    $Sprite.set_sprite_frames(anim)
    loves_water = loves_water_


func _ready():
    m.flags_unshaded = true
    m.flags_use_point_size = true
    m.albedo_color = Color.yellow


func _physics_process(delta):
    var direction = Vector3()

    # We need to scale the movement speed by how much delta has passed,
    # otherwise the motion won't be smooth.
    var step_size = delta * SPEED

    if path.size() > 0:
        # Direction is the difference between where we are now
        # and where we want to go.
        var destination = path[0]
        direction = destination - translation

        # If the next node is closer than we intend to 'step', then
        # take a smaller step. Otherwise we would go past it and
        # potentially go through a wall or over a cliff edge!
        if step_size > direction.length():
            step_size = direction.length()
            # We should also remove this node since we're about to reach it.
            path.remove(0)

        # Move the robot towards the path node, by how far we want to travel.
        # Note: For a KinematicBody, we would instead use move_and_slide
        # so collisions work properly.
        var collision = move_and_collide(direction.normalized() * step_size)
        if collision:
            if collision.get_collider().is_in_group("waves"):
                on_splashed()
        # translation += direction.normalized() * step_size

        # Lastly let's make sure we're looking in the direction we're traveling.
        # Clamp y to 0 so the robot only looks left and right, not up/down.
        direction.y = 0
        if direction:
            # Direction is relative, so apply it to the robot's location to
            # get a point we can actually look at.
            var look_at_point = translation + direction.normalized()
            # Make the robot look at the point.
            look_at(look_at_point, Vector3.UP)

            $Billboard.update_facing(direction, $Sprite)


func navigate_to_point(target_point):
    # Set the path between the robots current location and our target.
    path = nav.get_simple_path(translation, target_point, true)

    if show_path:
        draw_path(path)


var wet_time := 0
func on_splashed():
    if is_wet:
        return
    is_wet = true
    wet_time = Time.get_ticks_msec()
    $Sprite.play("wet")
    if loves_water:
        cheers.play_random($AudioPlayer)
    else:
        boos.play_random($AudioPlayer)

func dry_out():
    is_wet = false
    $Sprite.play("idle")


#~ func _unhandled_input(event):
#~     if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
#~         var point = event.position
#~         var from = camera.project_ray_origin(point)
#~         var to = from + camera.project_ray_normal(point) * 1000
#~         var target_point = nav.get_closest_point_to_segment(from, to)
#~         navigate_to_point(target_point)


func draw_path(path_array):
    var im = get_node("%PathDrawer")
    im.set_material_override(m)
    im.clear()
    im.begin(Mesh.PRIMITIVE_POINTS, null)
    im.add_vertex(path_array[0])
    im.add_vertex(path_array[path_array.size() - 1])
    im.end()
    im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
    for x in path:
        im.add_vertex(x)
    im.end()
