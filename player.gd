extends CharacterBody2D

@onready var Star = $"../StarObj/AnimatedSprite2D"
@onready var Audio = $"../AudioStreamPlayer2D"

const SPEED = 400.0
const JUMP_VELOCITY = -500.0
var is_game_over : bool = false
var starting_position : Vector2

func _ready():
	#Save the initial location so when WE inevitably die we can be reset
	starting_position = global_position

func reset_position():
	#reset the player back to the start
	global_position = starting_position
	#reset velocity so the player doesnt go literally everywhere
	velocity = Vector2.ZERO
	
func _physics_process(delta: float) -> void:
	
	#if players position is too low, we'll reset them
	if global_position.y > 1000:
		reset_position()
		print_debug("resetting")

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider and collider.name == "StarObj" and not is_game_over:
			is_game_over = true
			velocity = Vector2.ZERO
			set_physics_process(false)
			Star.stop()
			Audio.play()
			await get_tree().create_timer(5.5).timeout
			get_tree().quit()
	move_and_slide()
	
	
