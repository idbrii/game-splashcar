extends KinematicBody

export(float, 0.1, 100, 1) var move_speed := 5.0
export(float, 0.1, 100, 1) var duration := 5.0

var move_direction := Vector3.ZERO

func set_move_direction(direction):
    move_direction = direction.normalized()
    $DeathTimer.start(duration)

func _physics_process(_dt):
    var move_velocity := move_direction * move_speed
    var linear_velocity := move_and_slide(move_velocity)
    var progress = $DeathTimer.time_left / duration
    # Should we scale them out?
    #~ scale = Vector3.ONE * sin(progress * TAU/2)


func _on_DeathTimer_timeout():
    queue_free()


