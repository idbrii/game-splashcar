extends KinematicBody

class_name KineCar

export(float, -100,  0,    1) var gravity := -20.0
export(float, 0,     100,  1) var wheel_base := 70.0
export(float, 0.001, 180,  1) var steering_angle := 15
export(float, 0,     1000, 1) var engine_power := 800.0
export(float, -10,   0,    0.01) var friction := -0.9
export(float, -10,   0,    0.01) var drag := -0.001
export(float, -1000, 0,    1) var braking := -450.0
export(float, 0.001, 1000, 1) var max_speed_reverse := 250.0
export(float, 0.001, 1000, 1) var slip_speed := 400.0
export(float, 0.001, 10,   1) var traction_fast := 0.1
export(float, 0.001, 10,   1) var traction_slow := 0.7

var acceleration = Vector3.ZERO
var velocity = Vector3.ZERO
var steer_direction


func _physics_process(dt):
    acceleration = Vector3.ZERO
    get_input()
    apply_friction()
    calculate_steering(dt)
    velocity += acceleration * dt
    velocity = move_and_slide(velocity)


func apply_friction():
    if velocity.length() < 0.2:
        velocity = Vector3.ZERO
    var friction_force = velocity * friction
    var drag_force = velocity * velocity.length() * drag
    acceleration += drag_force + friction_force


func get_input():
    var turn = Input.get_axis("move_right", "move_left")
    steer_direction = turn * deg2rad(steering_angle)
    if Input.is_action_pressed("accelerate"):
        acceleration = -transform.basis.z * engine_power
    if Input.is_action_pressed("brake"):
        acceleration = -transform.basis.z * braking


func calculate_steering(dt):
    var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
    var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
    rear_wheel += velocity * dt
    front_wheel += velocity.rotated(transform.basis.y, steer_direction) * dt
    var new_heading = (front_wheel - rear_wheel).normalized()
    var traction = traction_slow
    if velocity.length() > slip_speed:
        traction = traction_fast
    var d = new_heading.dot(velocity.normalized())
    if d > 0:
        velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
    if d < 0:
        velocity = -new_heading * min(velocity.length(), max_speed_reverse)
    look_at(transform.origin + new_heading, transform.basis.y)










