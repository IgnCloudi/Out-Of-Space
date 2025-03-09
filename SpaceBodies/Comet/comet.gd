extends GPUParticles2D

var MaxPoints = 50
@onready var TrailLine: Line2D = $"../TrailLine"
@onready var Comet: Sprite2D = $"../Comet"
@onready var TrailPointTimer: Timer =$"../TrailPointTimer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var RotTween = create_tween()
	RotTween.connect("finished", OnRotTweenOver)
	RotTween.tween_property(Comet, "global_rotation", 360, 120).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

func OnRotTweenOver():
	Comet.global_rotation = 0
	var RotTween = create_tween()
	RotTween.tween_property(Comet, "global_rotation", 360, 120).set_trans(Tween.TRANS_CUBIC)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_trail_point_timer_timeout() -> void:
	if TrailLine.get_point_count() < MaxPoints:
		var LocalPos = TrailLine.to_local(global_position)
		TrailLine.add_point(LocalPos)
	else:
		#TrailPointTimer.wait_time = 1
		TrailLine.remove_point(0)
