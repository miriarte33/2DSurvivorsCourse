extends CharacterBody2D

const MAX_SPEED = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	
	# velocity is a property of CharacterBody2D. F1 opens up the documentation in-engine
	# this will send us at 200 pixels/second in the direction pressed
	velocity = direction * MAX_SPEED
	move_and_slide()
	

func get_movement_vector():
	# get_action_stength always returns 0 or 1 with a keyboard input, it was either pressed or it wasn't
	# if move_right is not pressed, and move_left is pressed, then x movement is -1
	# if move_right is pressed, and move_left is not pressed, then x movement is 1
	# if both or neither are pressed, then x movement is 0
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# repeat for y_movement
	# down direction in y is positive, up is negative. So move_down should go first.
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# return the input state of x and y
	return Vector2(x_movement, y_movement)
