tool
extends Node
class_name PlacementUtil

# Utility script to help with placement.

# Can't run EditorScript when external text editor is enabled
# https://github.com/godotengine/godot/issues/39842
# Instead, we use a checkbox with a setter to trigger our actions.


# Align Children of Parent to Grid

export var alignChildren := false setget do_alignchildren
export var spacing := Vector3(1, 0, 1)
export var max_x := 50.0
export var variance := Vector3(0.1, 0, 0.1)
export var variance2 := 1.0

func do_alignchildren(__ = null):
    print("Aligning children of ", get_parent())

    var targets = _get_target_children()
    var start := targets[0].global_translation as Vector3
    var pos := Vector3.ZERO
    for item in targets:
        var offset = randf() * variance
        item.global_translation = start + pos + offset
        pos += Vector3.RIGHT * spacing.x
        if pos.x > max_x:
            pos += spacing
            pos.x = 0







func _get_target_children():
    var targets := get_parent().get_children()
    targets.erase(self)
    return targets

