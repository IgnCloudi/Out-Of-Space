extends AudioStreamPlayer

@onready var MyAudioStreamPlayer: AudioStreamPlayer = $"."
@onready var timer: Timer = $Timer

var BG1 = preload("res://BGMusic/atmosphere-soundscape-302345.mp3")
var BG2 = preload("res://BGMusic/creepy-space-signal-213834.mp3")
var BG3 = preload("res://BGMusic/mystery-music-loop-226835.mp3")
var BG4 = preload("res://BGMusic/space-travel-in-outer-space-158427.mp3")

var BGs: Array = [BG1, BG2, BG3, BG4]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SelectBG():
	var Rand = randi_range(0,3)
	MyAudioStreamPlayer.stream = BGs[Rand]
	MyAudioStreamPlayer.play()
	MyAudioStreamPlayer.volume_db = -20
	var BGTween = create_tween()
	BGTween.tween_property(MyAudioStreamPlayer,"volume_db",-10, 3).set_trans(Tween.TRANS_CUBIC)

func _on_finished() -> void:
	timer.start()


func _on_timer_timeout() -> void:
	SelectBG()
