extends CharacterBody2D

@onready var StationPath: Path2D = $StationPath
@onready var PathFollow: PathFollow2D = $StationPath/PathFollow2D
@onready var SpaceStation: CharacterBody2D = $SpaceStation

var EscortShipPreload = preload("res://SpaceBodies/Earth/escort_ship.tscn")
var Speed: int = 500


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSingleton.connect("MakeShip",MakeShip)


func _process(delta: float) -> void:
	SpaceStation.velocity = (PathFollow.global_position-SpaceStation.global_position) 
	PathFollow.progress_ratio += delta/500


func MakeShip():
	#Rocket Making Sound
	await get_tree().create_timer(1).timeout
	var EscortShip = EscortShipPreload.instantiate()
	add_child(EscortShip)
	EscortShip.top_level = true
	EscortShip.global_position = global_position
	EscortShip.velocity = EscortShip.global_position.normalized() * Speed


func _on_deposit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.InEarthRange = true
		if body.InvenOpen:
			var InvenTween = create_tween()
			body.DepositUIOpen = true
			InvenTween.parallel().tween_property(body.DepositUi, "global_position:x", 50, 1.25).set_trans(Tween.TRANS_CUBIC)
		else:
			body.TabToolTipAppear(true) # not made yet


func _on_deposit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and !body.InShop:
		body.InEarthRange = false
		if body.InvenOpen:
			var InvenTween = create_tween()
			body.DepositUIOpen = false
			InvenTween.parallel().tween_property(body.DepositUi, "global_position:x", -940, .75).set_trans(Tween.TRANS_CUBIC)
		elif body.TabToolTipVis:
			body.TabToolTipAppear(false)
