extends RigidBody2D

@onready var Star = $AnimatedSprite2D
@onready var Audio = $"../AudioStreamPlayer2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Star.play("idle")
	contact_monitor = true
	max_contacts_reported = 5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for body in get_colliding_bodies():
		if body.name == "Player":
			Star.stop()
			Audio.play()
			get_tree().quit()
	
func _on_body_entered(body: Node) -> void:
	Star.stop()
	Audio.play()
	get_tree().quit()
