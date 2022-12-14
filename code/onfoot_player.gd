extends KinematicBody


signal hit

export(float, 0.001, 5000, 1) var walk_speed := 1500
export var max_speed := Vector2(200, 1000)
export(float, 0.001, 1, 0.1) var min_walk_input := 0.2
export(float, 0.001, 5000, 1) var walk_stop_force := 1600

# Not acceleration: instantaneously added to speed.
export(float, 0.001, 1000, 1) var jump_power = 700

export(float, 0.001, 1000, 1) var gravity_floor := 20
export(float, 0.001, 1000, 1) var gravity_fly := 20
export(float, 0.001, 1000, 1) var gravity_fall := 60


var active
var current_velocity := Vector3.ZERO
var is_jumping := false
var is_falling := false


# when the node enters the scene tree for the first time.
func _ready():
    active = "idle"
    hide()


func calc_input_move():
    var direction = Vector3.ZERO
    direction += Vector3.RIGHT   * Input.get_axis("move_left", "move_right")
    direction += Vector3.FORWARD * Input.get_axis("move_backward", "move_forward")
    return direction


func calc_input_look():
    var direction = Vector3.ZERO
    direction += Vector3.RIGHT   * Input.get_axis("look_left", "look_right")
    direction += Vector3.FORWARD * Input.get_axis("look_backward", "look_forward")
    return direction


func pick_anim(velocity):
    if velocity.length_squared() > 0:
        return "run"
    return "idle"


func _process(delta):
    var direction = calc_input_look()

func _physics_process(delta):
    var direction = calc_input_move()

    var velocity = current_velocity
    if direction.length_squared() > min_walk_input * min_walk_input:
        velocity += direction * walk_speed * delta
        # TODO: 3D clamp
        #~ velocity.x = clamp(velocity.x, -max_speed.x, max_speed.x)
        #~ $AnimatedSprite.flip_h = velocity.x < 0
    else:
        # Slow player horizontal movement if they're not trying to move.
        var slowed = velocity.move_toward(Vector3.ZERO, walk_stop_force * delta)
        slowed.y = velocity.y # UP
        velocity = slowed

    # Uses last frame's physics state.
    velocity = _add_jump_velocity(velocity)

    #~ var anim = pick_anim(velocity)
    #~ if anim != active:
    #~     $AnimatedSprite.play(anim)

    #~ if is_on_floor():
    #~     $Debug/GroundState.set_frame_color(Color.brown)
    #~ else:
    #~     $Debug/GroundState.set_frame_color(Color.aqua)

    current_velocity = move_and_slide(velocity, Vector3.UP)
    #~ current_velocity = move_and_slide_with_snap(velocity, Vector3.DOWN, Vector3.UP)

    for index in get_slide_count():
        var collision := get_slide_collision(index)
        var body := collision.collider
        #~ print("Collided with: ", body.name)
        if body.is_in_group("killvolume"):
            on_enter_body(body)

func _add_jump_velocity(velocity):
    if is_on_floor():
        is_jumping = false
        is_falling = false
        if Input.is_action_just_pressed("jump"):
            $Timer/Jump.start()
            is_jumping = true
            velocity += Vector3.UP * jump_power

    var gravity := gravity_floor
    if is_jumping:
        if not Input.is_action_pressed("jump"):
            is_falling = true
        if is_falling:
            gravity = gravity_fall
        else:
            gravity = gravity_fly

    velocity += Vector3.UP * -gravity

    velocity.y = clamp(velocity.y, -max_speed.y, max_speed.y)
    return velocity

func _on_Jump_timeout():
    is_falling = true

func on_enter_body(_body):
    # Player disappears after being hit.
    hide()
    emit_signal("hit")
    # deferred since we can't change physics properties on a physics callback.
    $CollisionShape.set_deferred("disabled", true)


#~ func start(pos):
#~     position = pos
#~     show()
#~     $CollisionShape.disabled = false
