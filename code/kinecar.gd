extends KinematicBody

class_name KineCar

export(float, -100,  0,    1) var gravity := -20.0
export(float, 0,     100,  1) var wheel_base := 70.0
export(float, 0.001, 180,  1) var steering_angle := 15.0
export(float, 0,     1000, 1) var engine_power := 800.0
export(float, -10,   0,    0.01) var friction := -0.9
export(float, -10,   0,    0.01) var drag := -0.001
export(float, -1000, 0,    1) var braking := -450.0
export(float, 0.001, 1000, 1) var max_speed_reverse := 250.0
export(float, 0.001, 1000, 1) var slip_speed := 400.0
export(float, 0.001, 10,   1) var traction_fast := 0.1
export(float, 0.001, 10,   1) var traction_slow := 0.7

export(Resource) var tire_screeches # AudioSet
export(float, -1000, 1000, 1) var accelerate_volume := 0.7
export(float, -1000, 1000, 1) var idle_volume := 0.7


var acceleration = Vector3.ZERO
var velocity = Vector3.ZERO
var steer_direction
var is_accelerating := false
var engine_volume := 0.0
var is_hard_turn := false


func _physics_process(dt):
    acceleration = Vector3.ZERO
    get_input()
    apply_friction()
    calculate_steering(dt)
    velocity += acceleration * dt
    velocity = move_and_slide(velocity)

    var target_volume := idle_volume
    if velocity.length_squared() > 0.1 and is_accelerating:
        target_volume = accelerate_volume
    engine_volume = lerp(engine_volume, target_volume, 0.05)
    $Audio_Engine.set_unit_db(engine_volume)


func apply_friction():
    if velocity.length() < 0.2:
        velocity = Vector3.ZERO
    var friction_force = velocity * friction
    var drag_force = velocity * velocity.length() * drag
    acceleration += drag_force + friction_force


func get_input():
    is_accelerating = false
    var turn = Input.get_axis("move_right", "move_left")
    steer_direction = turn * deg2rad(steering_angle)
    is_hard_turn = abs(turn) > 0.8
    if Input.is_action_pressed("accelerate"):
        acceleration = -transform.basis.z * engine_power
        is_accelerating = true
    if Input.is_action_pressed("brake"):
        acceleration = -transform.basis.z * braking


func calculate_steering(dt):
    # Ref: http://engineeringdotnet.blogspot.com/2010/04/simple-2d-car-physics-in-games.html
    var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
    var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
    rear_wheel += velocity * dt
    front_wheel += velocity.rotated(transform.basis.y, steer_direction) * dt
    var new_heading = (front_wheel - rear_wheel).normalized()
    var traction = traction_slow
    var can_slip = velocity.length() > slip_speed
    if can_slip:
        traction = traction_fast
    var d = new_heading.dot(velocity.normalized())
    if d > 0:
        velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
    if d < 0:
        velocity = -new_heading * min(velocity.length(), max_speed_reverse)
    look_at(transform.origin + new_heading, transform.basis.y)

    if not $Audio_Tires.is_playing() and is_hard_turn and can_slip:
        #~ print("Play screech")
        tire_screeches.play_random($Audio_Tires)


func _calculate_max_speed() -> float:
    # https://github.com/kidscancode/godot_recipes/issues/22#issuecomment-1027965700
    if drag >= 0 and friction >= 0:
        return -1.0
    elif drag >= 0 and friction < 0:
        return engine_power / friction
    elif drag < 0 and friction >= 0:
        return sqrt(engine_power / drag)

    var discriminant: float = (friction * friction) - (4 * drag * engine_power)
    return (-friction - sqrt(discriminant)) / (2 * drag) if discriminant >= 0 else -1.0









