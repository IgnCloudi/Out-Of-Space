extends Node2D

#@onready var Orbits: Node2D = $Planet1
@onready var Player: CharacterBody2D = $Player

var Orbits: Node2D

var PlayerPathFollow: PathFollow2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Orbits = $Orbits
	for Path in Orbits.get_children():
		var PackedArr = Path.curve.get_baked_points()
		Path.get_node("Line2D").points = PackedArr


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for Path in Orbits.get_children():
		if Path.name == "Path2D3":
			Path.get_node("PathFollow2D").progress_ratio += delta/250
		else:
			Path.get_node("PathFollow2D").progress_ratio += delta/1000


func _on_timer_timeout() -> void:
	if !Player.PlayerInOrbit:
		for Path in Orbits.get_children():
			if !Player.PlayerInOrbit and Path.to_local(Player.global_position).distance_to(Path.curve.get_closest_point(Path.to_local(Player.global_position))) < 50:
				Player.emit_signal("InOrbit",Path.get_node("PlayerPathFollow"))
				PlayerPathFollow = Path.get_node("PlayerPathFollow")
	elif PlayerPathFollow.get_parent().to_local(Player.global_position).distance_to(PlayerPathFollow.get_parent().curve.get_closest_point(PlayerPathFollow.get_parent().to_local(Player.global_position))) > 25:
		Player.PlayerInOrbit = false
