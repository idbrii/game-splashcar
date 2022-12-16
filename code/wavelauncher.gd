extends Spatial

class_name WaveLauncher

# Placeholder test script to spawn waves until they spawn from puddles.

export (PackedScene) var wave_scene

var delay := 0.0

func _process(dt):
	return
	delay -= dt
	if delay > 0:
		return
	delay = 5

	var wave = wave_scene.instance()

	var car = get_parent()
	var root = car.get_parent()

	root.add_child(wave)

	wave.global_translation = global_translation
	wave.set_move_direction(global_translation - car.global_translation)
	print(global_translation - car.global_translation)

