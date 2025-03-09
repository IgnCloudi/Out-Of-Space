extends CharacterBody2D

var Player: CharacterBody2D
var PlayerIn: bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PlayerIn and !Player.Direction:
		Player.velocity = self.velocity
func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_in_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player = body
		PlayerIn = true
		body.ShopAnim(true)

func _on_in_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.ShopAnim(false)
		await get_tree().create_timer(1).timeout
		PlayerIn = false
