extends KinematicBody

class_name KinematicCar

export(float, 100,   0,    1) var gravity := -20.0
export(float, 0.001, 180,  1) var steering_max_angle := 30.0 # degrees
export(float, 0,     5,    1) var steering_exaggeration := 1.0
export(float, 0.001, 100,  1) var engine_power := 6.0
export(float, 0.001, 100,  1) var braking := 9.0
export(float, -100,  0,    1) var friction := -2.0
export(float, -100,  0,    1) var drag := -2.0
export(float, 0.001, 1000, 1) var max_speed_reverse := 3.0

export(NodePath) var nodepath_wheel_left = null
export(NodePath) var nodepath_wheel_right = null
onready var wheel_left := get_node(nodepath_wheel_left) as Spatial
onready var wheel_right := get_node(nodepath_wheel_right) as Spatial
export(NodePath) var nodepath_axle_front = null
export(NodePath) var nodepath_axle_rear = null
onready var axle_front := get_node(nodepath_axle_front) as Spatial
onready var axle_rear := get_node(nodepath_axle_rear) as Spatial
export(float) onready var wheel_base := abs(axle_front.global_translation.z - axle_rear.global_translation.z)

var velocity := Vector3.ZERO


func process_drive(dt, turn_input: float, power_input: float):
    var acceleration := Vector3.ZERO
    if is_on_floor():
        if power_input > 0:
            acceleration = -transform.basis.z * engine_power
        if power_input < 0:
            acceleration = transform.basis.z * braking

        var steer_angle := turn_input * deg2rad(steering_max_angle)
        var wheel_turn := steer_angle * steering_exaggeration
        wheel_right.rotation.y = wheel_turn
        wheel_left.rotation.y = wheel_turn

        var new_heading := calculate_heading(dt, velocity, steer_angle)

        var d = new_heading.dot(velocity.normalized())
        if d > 0:
            velocity = new_heading * velocity.length()
        elif d < 0:
            velocity = -new_heading * min(velocity.length(), max_speed_reverse)

        look_at(transform.origin + new_heading, transform.basis.y)

    if velocity.length() < 0.2 and acceleration.length() == 0:
        velocity.x = 0
        velocity.z = 0
    acceleration = apply_friction(dt, velocity, acceleration)

    acceleration.y = gravity
    velocity += acceleration * dt
    velocity = move_and_slide_with_snap(
        velocity,
        -transform.basis.y,
        Vector3.UP,
        true)


func apply_friction(dt, vel, acc):
    var friction_force = vel * friction * dt
    var drag_force = vel * vel.length() * drag * dt
    acc += drag_force + friction_force
    return acc


func calculate_heading(dt, vel, steer_angle) -> Vector3:
    var front_wheel = axle_front.global_translation
    var rear_wheel = axle_rear.global_translation

    front_wheel += vel.rotated(transform.basis.y, steer_angle) * dt
    rear_wheel += vel * dt

    return rear_wheel.direction_to(front_wheel)

