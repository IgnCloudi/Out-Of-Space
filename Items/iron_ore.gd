extends CharacterBody2D
signal GoToPlayer

var GettingPicked: bool = false
var Player: CharacterBody2D

var Speed = 10000

var ItemName: String = "Iron"
var SpaceTaken: int = 1

var InRangeToFollow: bool = false
var InRangeToBePicked: bool = false # Refers to when the item has reached the player and then being in range


func _ready() -> void:
	GoToPlayer.connect(WellJustGoToPlayer)

func _process(delta: float) -> void:
	if InRangeToFollow and  GlobalSingleton.InvenCurMax - GlobalSingleton.InvenCurOccupied >= SpaceTaken:
		self.velocity = (Player.global_position - self.global_position).normalized() * delta * 5000
		
	if InRangeToBePicked and GlobalSingleton.InvenCurMax - GlobalSingleton.InvenCurOccupied >= SpaceTaken:
		GlobalSingleton.AddItem(ItemName)
		self.queue_free()

func _physics_process(delta: float) -> void:
	if GettingPicked:
		velocity = (Player.global_position - self.global_position).normalized() * Speed * delta
	move_and_slide()


func WellJustGoToPlayer(PlayerNod):
	Player = PlayerNod
	InRangeToFollow = true
	#var SpeedUpTween = create_tween()
	#SpeedUpTween.connect("finished",SpeedDone)
	#var TarVel = (Player.global_position - self.global_position).normalized() * Speed * get_physics_process_delta_time()
	#SpeedUpTween.tween_property(self,"velocity",TarVel , 1).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)

func SpeedDone():
	GettingPicked = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InRangeToBePicked = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		velocity = Vector2.ZERO
		InRangeToBePicked = false
