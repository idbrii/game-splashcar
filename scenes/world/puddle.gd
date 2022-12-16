extends Spatial

export (PackedScene) var wave_scene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body.is_in_group("player") == false:
		return
	
	var parent = get_parent()
	for n in 4:
		var wave = wave_scene.instance()
		parent.add_child(wave)
		wave.global_translation = body.global_translation
		var angle = Vector3(1, 0, 0).rotated(Vector3(0, 1, 0).normalized(), PI/2 * n)
		# print(angle, " ||||| ", wave.global_translation)
		wave.set_move_direction(angle)

	$RespawnTimer.start()
	hide()



func _on_RespawnTimer_timeout():
	show()
