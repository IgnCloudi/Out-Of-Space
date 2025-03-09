extends Control

var IronReq: int = 5
var PlasmaReq: int = 2
var CrystalReq: int  = 3

var Player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player = get_parent().get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_ship_pressed() -> void:
	if GlobalSingleton.IronInInven >= IronReq and GlobalSingleton.PlasmaInInven >= PlasmaReq and GlobalSingleton.CrystalInInven >= CrystalReq:
		GlobalSingleton.DropItem("Iron",get_parent().get_node("Inventory").IronSlot, IronReq)
		GlobalSingleton.DropItem("Plasma",get_parent().get_node("Inventory").PlasmaSlot, PlasmaReq)
		GlobalSingleton.DropItem("Crystal",get_parent().get_node("Inventory").CrystalSlot, CrystalReq)
		GlobalSingleton.emit_signal("MakeShip")
	else:
		Player.NotEnoughItems()
