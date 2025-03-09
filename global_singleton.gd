extends Node

signal MakeShip

var InvenCurMax: int = 5
var InvenCurOccupied: int = 0

var IronTakes: int = 1
var PlasmaTakes: int = 2
var CrystalTakes: int = 2

@export var IronInInven: int
@export var PlasmaInInven: int
@export var CrystalInInven: int 

@export var Inventory: Control
var ScoreButton: Button
var Score = 0

var PlayerInvenBar: TextureProgressBar
var PlayerCanvas: CanvasLayer

var HealthBar: ProgressBar
var PlayerHealth: float = 100


func HealthUpdated(value):
	if value <= 0:
		print("DIE")



func _ready() -> void:
	await get_tree().create_timer(3).timeout
	PlayerCanvas.get_parent().Speed += 1000
	pass

func AddItem(Item, Amt:int = 1):
	match Item:
		"Iron":
			IronInInven += Amt
			InvenCurOccupied += Amt # not multiplying cuz it only takes 1 space
		"Plasma":
			PlasmaInInven += Amt
			InvenCurOccupied += Amt*2
		"Crystal":
			CrystalInInven += Amt
			InvenCurOccupied += Amt*2
	#InvenCurOccupied += HeliumInInven * HeliumTakes
	UpdateMainBar()
	Inventory.emit_signal("ItemAdded",Item)

func DropItem(Item, ItemSlot, Amt):
	match Item:
		"Iron":
			IronInInven -= Amt
			InvenCurOccupied -= Amt # not multiplying cuz it only takes 1 space
		"Plasma":
			PlasmaInInven -= Amt
			InvenCurOccupied -= Amt*2
		"Crystal":
			CrystalInInven -= Amt
			InvenCurOccupied -= Amt*2
	UpdateMainBar()
	Inventory.emit_signal("ItemDropped",Item, ItemSlot, Amt)

func UpdateMainBar():
	var ValTween = create_tween()
	ValTween.tween_property(PlayerInvenBar,"value",InvenCurOccupied,.5).set_trans(Tween.TRANS_CUBIC)
	ValTween.parallel().tween_property(PlayerInvenBar,"max_value",InvenCurMax,.5).set_trans(Tween.TRANS_CUBIC)
	PlayerCanvas.get_node("InventoryBarText").text = str(InvenCurOccupied) + "\n" + str(InvenCurMax)

func UpdateScore():
	Score+=500
	ScoreButton.text = "Score: " + str(Score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#print("\n\nItemsInInven: ", InvenCurOccupied,"\nIronInInven: ", IronInInven)
