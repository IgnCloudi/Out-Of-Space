extends Control

@onready var Space: Button = $Space
@onready var Speed: Button = $Speed
@onready var FullHealth: Button = $FullHealth
@onready var NegativeSound: AudioStreamPlayer = $NegativeSound


var IronReq: int = 5
var PlasmaReq: int = 2
var CrystalReq: int  = 3

var Player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_parent().get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_full_health_pressed() -> void:
	if GlobalSingleton.IronInInven >= IronReq:
		if GlobalSingleton.HealthBar.value < 100:
			GlobalSingleton.DropItem("Iron",get_parent().get_node("Panel").get_node("Inventory").IronSlot, IronReq)
			GlobalSingleton.HealthBar.value = GlobalSingleton.HealthBar.max_value
		else:
			NegativeSound.play()
			Player.NotEnoughItems("Already Full Health")
	else:
		NegativeSound.play()
		Player.NotEnoughItems("Not Enough Items..")

func _on_speed_pressed() -> void:
	if GlobalSingleton.PlasmaInInven >= PlasmaReq:
		if Player.Speed < 15000:
			GlobalSingleton.DropItem("Plasma",get_parent().get_node("Panel").get_node("Inventory").PlasmaSlot, PlasmaReq)
			Player.Speed += 1000
		else:
			NegativeSound.play()
			Player.NotEnoughItems("Max Speed Reached")
	else:
		NegativeSound.play()
		Player.NotEnoughItems("Not Enough Items..")

func _on_speed_2_pressed() -> void:
	if GlobalSingleton.CrystalInInven >= CrystalReq:
		if GlobalSingleton.InvenCurMax < 50:
			GlobalSingleton.DropItem("Crystal",get_parent().get_node("Panel").get_node("Inventory").CrystalSlot, CrystalReq)
			GlobalSingleton.InvenCurMax += 5
			GlobalSingleton.UpdateMainBar()
		else:
			NegativeSound.play()
			Player.NotEnoughItems("Max Space Reached")
	else:
		NegativeSound.play()
		Player.NotEnoughItems("Not Enough Items..")
