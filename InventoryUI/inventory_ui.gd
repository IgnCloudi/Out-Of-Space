extends Control

signal ItemAdded
signal ItemDropped

@onready var Grid: GridContainer = $MarginContainer/GridContainer


var EmptySlot = preload("res://InventoryUI/item_slot.tscn")

var IronSprite = preload("res://ItemSprites/IronOre.png")
var PlasmaSprite = preload("res://ItemSprites/PlasmaSmol.png")
var CrystalSprite = preload("res://ItemSprites/IceCrystals.png")

var SlotsInInven: Array = []

#Name all slots here
var IronSlot: Control
var PlasmaSlot: Control
var CrystalSlot: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSingleton.Inventory = self
	ItemAdded.connect(OnItemAdded)
	ItemDropped.connect(OnItemDropped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OnItemAdded(Item):
	if Item not in SlotsInInven:
		SlotsInInven.append(Item)
		var NewSlot = EmptySlot.instantiate()
		Grid.add_child(NewSlot)
		NewSlot.ItemName = Item
		match Item:
			"Iron":
				var CurAmt = GlobalSingleton.IronInInven
				NewSlot.get_node("Panel").get_node("TextureButton").tooltip_text = Item + "\nTakes " + str(1) + " space."
				NewSlot.get_node("Panel").get_node("TextureButton").texture_normal = IronSprite
				NewSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
				NewSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
				NewSlot.ItemCount = CurAmt
				IronSlot = NewSlot
			"Plasma":
				var CurAmt = GlobalSingleton.PlasmaInInven
				NewSlot.get_node("Panel").get_node("TextureButton").tooltip_text = Item + "\nTakes " + str(2) + " space."
				NewSlot.get_node("Panel").get_node("TextureButton").texture_normal = PlasmaSprite
				NewSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
				NewSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
				NewSlot.ItemCount = CurAmt
				PlasmaSlot = NewSlot
			"Crystal":
				var CurAmt = GlobalSingleton.CrystalInInven
				NewSlot.get_node("Panel").get_node("TextureButton").tooltip_text = Item + "\nTakes " + str(2) + " space."
				NewSlot.get_node("Panel").get_node("TextureButton").texture_normal = CrystalSprite
				NewSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
				NewSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
				NewSlot.ItemCount = CurAmt
				CrystalSlot = NewSlot
	match Item:
		"Iron":
			var CurAmt = GlobalSingleton.IronInInven
			IronSlot.ItemCount = CurAmt
			IronSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
			IronSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
		"Plasma":
			var CurAmt = GlobalSingleton.PlasmaInInven
			PlasmaSlot.ItemCount = CurAmt
			PlasmaSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
			PlasmaSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
		"Crystal":
			var CurAmt = GlobalSingleton.CrystalInInven
			CrystalSlot.ItemCount = CurAmt
			CrystalSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
			CrystalSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
func OnItemDropped(Item, ItemSlot, Amt):
	match Item:
		"Iron":
			if GlobalSingleton.IronInInven == 0:
				SlotsInInven.erase(Item)
				ItemSlot.queue_free()
				ItemSlot = null
			else:
				var CurAmt = GlobalSingleton.IronInInven
				ItemSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
				ItemSlot.get_node("InteractivePanel").get_node("DropText").text = "Drop: 0"
				ItemSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
				ItemSlot.get_node("InteractivePanel").get_node("VSlider").value = 0
		"Plasma":
			if GlobalSingleton.PlasmaInInven == 0:
				SlotsInInven.erase(Item)
				ItemSlot.queue_free()
				ItemSlot = null
			else:
				var CurAmt = GlobalSingleton.PlasmaInInven
				ItemSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
				ItemSlot.get_node("InteractivePanel").get_node("DropText").text = "Drop: 0"
				ItemSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
				ItemSlot.get_node("InteractivePanel").get_node("VSlider").value = 0
		"Crystal":
			if GlobalSingleton.CrystalInInven == 0:
				SlotsInInven.erase(Item)
				ItemSlot.queue_free()
				ItemSlot = null
			else:
				var CurAmt = GlobalSingleton.CrystalInInven
				ItemSlot.get_node("InteractivePanel").get_node("CountText").text = "In Inventory: " + str(CurAmt)
				ItemSlot.get_node("InteractivePanel").get_node("DropText").text = "Drop: 0"
				ItemSlot.get_node("InteractivePanel").get_node("VSlider").max_value = CurAmt
				ItemSlot.get_node("InteractivePanel").get_node("VSlider").value = 0
