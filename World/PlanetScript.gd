extends CharacterBody2D

var ItemSpeed = 5000
var Iron = preload("res://Items/iron_ore.tscn")
var Crystal = preload("res://Items/IceCrystal.tscn")

var AllItemGiversGrps: Array = ["IronGiver"]
var GrpAndItem: Dictionary = {"IronGiver": Iron}
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	look_at(to_global(Vector2.ZERO))

func ThrowItem(Bomb):
	if self.is_in_group("ItemGiver"):
		if self.is_in_group("GivesIron"):
			var ItemSpawnAmt = randi_range(1,3)
			for i in range(ItemSpawnAmt):
				await get_tree().create_timer(.1).timeout
				var IronTscn = Iron.instantiate()
				self.call_deferred("add_child",IronTscn)
				IronTscn.top_level = true
				IronTscn.global_position = Bomb.global_position
				IronTscn.velocity = (Bomb.global_position - self.global_position).normalized() * ItemSpeed * get_physics_process_delta_time()
		elif self.is_in_group("GivesCrystal"):
			var ItemSpawnAmt = randi_range(1,2)
			for i in range(ItemSpawnAmt):
				await get_tree().create_timer(.1).timeout
				var CrystalTscn = Crystal.instantiate()
				self.call_deferred("add_child",CrystalTscn)
				CrystalTscn.top_level = true
				CrystalTscn.global_position = Bomb.global_position
				CrystalTscn.velocity = (Bomb.global_position - self.global_position).normalized() * ItemSpeed * get_physics_process_delta_time()

func _on_item_thrower_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bomb") and !body.Used:
		body.Used = true
		body.linear_velocity = Vector2.ZERO
		ThrowItem(body)
