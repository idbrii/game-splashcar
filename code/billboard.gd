extends Node

# Utility class to setup billboard facing.
# Make sure the Sprite has Billboard = Y-facing under Flags.
class_name Billboard


onready var camera: Spatial = get_viewport().get_camera()


func update_facing(move_direction, sprite):
    # TODO(dbriscoe): Not sure this is actually the eye's right vector.
    var eye_right := camera.global_transform.basis.x
    var dot := eye_right.dot(move_direction)
    sprite.flip_h = dot < 0

