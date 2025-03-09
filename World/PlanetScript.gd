extends CharacterBody2D

var ItemSpeed = 5000
var Iron = preload("res://Items/iron_ore.tscn")

var AllItemGiversGrps: Array = ["IronGiver"]
var GrpAndItem: Dictionary = {"IronGiver": Iron}

func _process(delta: float) -> void:
	look_at(to_global(Vector2.ZERO))

func ThrowItem(Bomb):
	if self.is_in_group("ItemGiver"):
		var ItemSpawnAmt = randi_range(1,3)
		for i in range(ItemSpawnAmt):
			var IronTscn = Iron.instantiate()
			self.call_deferred("add_child",IronTscn)
			IronTscn.top_level = true
			IronTscn.global_position = Bomb.global_position
			IronTscn.velocity = (Bomb.global_position - self.global_position).normalized() * ItemSpeed * get_physics_process_delta_time()


func _on_item_thrower_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bomb") and !body.Used:
		body.Used = true
		body.linear_velocity = Vector2.ZERO
		ThrowItem(body)
