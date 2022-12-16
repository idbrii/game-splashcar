extends Spatial

export(NodePath) var nodepath_body = null
onready var body := get_node(nodepath_body) as KinematicBody

func _process(_dt):
    $Text.text = "%3.0f km/h" % body.velocity.length()
