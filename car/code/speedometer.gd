extends Spatial

export(NodePath) var nodepath_body = null
onready var body := get_node(nodepath_body) as KinematicBody

func _process(dt):
    $Text.text = "%3.0f km/h" % body.velocity.length()
