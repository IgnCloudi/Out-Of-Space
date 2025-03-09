extends Control

@onready var DropText: Button = $InteractivePanel/DropText
@onready var Vslider: VSlider = $InteractivePanel/VSlider


var ItemName: String 
var ItemCount: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_v_slider_value_changed(value: float) -> void:
	DropText.text = "Drop: " + str(Vslider.value)


func _on_drop_text_pressed() -> void:
	GlobalSingleton.DropItem(ItemName, self, Vslider.value)
