extends Node2D

var SolarPlasma = preload("res://Items/SolarPlasma.tscn")

@onready var SunBackTexture: TextureRect = $TextureRect
@onready var SunFrontTexture: TextureRect = $TextureRect2
@onready var AreaAround: TextureRect = $AreaAround

@onready var SolarFlareTopLeft: GPUParticles2D = $SolarFlareTopLeft
@onready var SolarFlareTopRight: GPUParticles2D = $SolarFlareTopRight
@onready var SolarFlareBottomLeft: GPUParticles2D = $SolarFlareBottomLeft
@onready var SolarFlareBottomRight: GPUParticles2D = $SolarFlareBottomRight

@onready var SolarFlareCoolDownTimer: Timer = $SolarFlareCooldown
@onready var SolarFlareDuration: Timer = $SolarFlareDuration


@export var TargetScale: Vector2 = Vector2(3.25,3.25)


var Selected: int

var SolarParticles: Array
var SolarFlareEmitting: bool = false

var Dmg: bool = false

func _process(delta: float) -> void:
	if Dmg:
		GlobalSingleton.HealthBar.value -= .2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SolarFlareCoolDownTimer.start()
	SolarParticles = [SolarFlareBottomLeft, SolarFlareBottomRight, SolarFlareTopLeft, SolarFlareTopRight]
	var RotTween = create_tween()
	RotTween.connect("finished",OnRotFinished)
	RotTween.tween_property(SunBackTexture, 'rotation_degrees', 360, 60)
	RotTween.parallel().tween_property(SunFrontTexture, 'rotation_degrees', -360, 60)
	RotTween.parallel().tween_property(AreaAround, 'rotation_degrees', 360, 60)

func OnRotFinished():
	SunBackTexture.rotation_degrees = 0
	SunFrontTexture.rotation_degrees = 0
	AreaAround.rotation_degrees = 0
	var RotTween = create_tween()
	RotTween.connect("finished",OnRotFinished)
	RotTween.tween_property(SunBackTexture, 'rotation_degrees', 360, 60)
	RotTween.parallel().tween_property(SunFrontTexture, 'rotation_degrees', -360, 60)
	RotTween.parallel().tween_property(AreaAround, 'rotation_degrees', 360, 60)
	

func EmitSolarFlare(SolarParticle):
	SolarParticle.get_child(0).set_monitoring(true)
	
	SpawnPlasmaItem(SolarParticle)
	SolarParticle.emitting = true
	SolarFlareDuration.start()

func SpawnPlasmaItem(SolarParticle):
	var SolarItemSpawnAmt: int = randi_range(1,3)
	var AnotherSpawnCoolDown = randf_range(.5,1.5)
	for i in range(SolarItemSpawnAmt):
		await get_tree().create_timer(AnotherSpawnCoolDown).timeout
		var SolarItem = SolarPlasma.instantiate()
		self.add_child(SolarItem)
		SolarItem.Spawned(SolarParticle)
func _on_solar_flare_cooldown_timeout() -> void:
	if !SolarFlareEmitting:
		Selected = randi_range(0,3)
		EmitSolarFlare(SolarParticles[Selected])
		SolarFlareEmitting = true

func _on_solar_flare_duration_timeout() -> void:
	SolarParticles[Selected].get_child(0).set_monitoring(false)
	Dmg = false
	SolarFlareEmitting = false
	SolarParticles[Selected].emitting = false
	SolarFlareCoolDownTimer.start()

func _on_top_left_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = true

func _on_top_right_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = true

func _on_bottom_left_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = true

func _on_bottom_right_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = true


func _on_top_left_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = false


func _on_top_right_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = false

func _on_bottom_left_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = false


func _on_bottom_right_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Dmg = false
