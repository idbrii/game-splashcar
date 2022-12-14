extends Node

export(NodePath) var nodepath_body = null
onready var body := get_node(nodepath_body) as KinematicCar

export var pub_turn := 0.0
export var pub_power := 0.0

func _physics_process(dt):
    var turn := Input.get_axis("move_right", "move_left")
    var power := Input.get_axis("brake", "accelerate")

    #~ $Debug_text.set_text("Hello")

    body.process_drive(dt, turn, power)
    pub_power = power
    pub_turn = turn
