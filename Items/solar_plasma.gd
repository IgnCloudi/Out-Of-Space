extends CharacterBody2D

var Deviation: float = 1.05
@onready var DespawnTimer: Timer = $DespawnTimer

signal GoToPlayer

var GettingPicked: bool = false
var Player: CharacterBody2D

var Speed = 10000

var ItemName: String = "Plasma"
var SpaceTaken: int = 2

var InRangeToFollow: bool = false
var InRangeToBePicked: bool = false # Refers to when the item has reached the player and then being in range


func _ready() -> void:
	$PlasmaSmol.texture_filter
	GoToPlayer.connect(WellJustGoToPlayer)

func _process(delta: float) -> void:
	if InRangeToFollow and  GlobalSingleton.InvenCurMax - GlobalSingleton.InvenCurOccupied >= SpaceTaken:
		self.velocity = (Player.global_position - self.global_position).normalized() * delta * 5000
		
	if InRangeToBePicked and GlobalSingleton.InvenCurMax - GlobalSingleton.InvenCurOccupied >= SpaceTaken:
		GlobalSingleton.AddItem(ItemName)
		self.queue_free()

func WellJustGoToPlayer(PlayerNod):
	Player = PlayerNod
	InRangeToFollow = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if GettingPicked:
		velocity = (Player.global_position - self.global_position).normalized() * Speed * delta
	move_and_slide()

func SpeedDone():
	GettingPicked = true

func Spawned(SpawnPos):
	scale = Vector2.ZERO
	top_level = true
	global_position = SpawnPos.global_position
	var OffsetX = randf_range(SpawnPos.global_position.x*-Deviation, SpawnPos.global_position.x*Deviation)
	var OffsetY = randf_range(SpawnPos.global_position.y*-Deviation, SpawnPos.global_position.y*Deviation) 
	velocity = (SpawnPos.global_position + Vector2(OffsetX,OffsetY)).normalized() * 500
	var VelTween = create_tween()
	VelTween.connect("finished",OnPlasmaStopped)
	VelTween.tween_property(self,"velocity",Vector2.ZERO,4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	VelTween.parallel().tween_property(self,"scale",Vector2.ONE,1).set_trans(Tween.TRANS_ELASTIC)

func OnPlasmaStopped():
	DespawnTimer.start()

func _on_despawn_timer_timeout() -> void:
	var DeSpawnTween = create_tween()
	DeSpawnTween.connect("finished",OnDeSpawnTweenOver)
	DeSpawnTween.tween_property(self,"modulate",Color(0,0,0,0),2).set_trans(Tween.TRANS_CUBIC)

func OnDeSpawnTweenOver():
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		InRangeToBePicked = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		velocity = Vector2.ZERO
		InRangeToBePicked = false
