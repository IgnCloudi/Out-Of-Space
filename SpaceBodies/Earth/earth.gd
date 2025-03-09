extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_deposit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.InEarthRange = true
		if body.InvenOpen:
			var InvenTween = create_tween()
			body.DepositUIOpen = true
			InvenTween.parallel().tween_property(body.DepositUi, "global_position:x", 50, 1.25).set_trans(Tween.TRANS_CUBIC)
		else:
			body.TabToolTipAppear() # not made yet


func _on_deposit_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.InEarthRange = false
		if body.InvenOpen:
			var InvenTween = create_tween()
			body.DepositUIOpen = false
			InvenTween.parallel().tween_property(body.DepositUi, "global_position:x", -940, .75).set_trans(Tween.TRANS_CUBIC)
		
