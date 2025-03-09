extends RigidBody2D

var RotFull: int = 360

var SpawnCoolDownOver: bool = false
var Thrown: bool = false
var BombActive: bool = false
var Exploded: bool = false

var BombsLove#: CharacterBody2D
var BombFoundLove: bool = false

var Used: bool = false #Tells if the bomb has been succeded in giving items
#the planet uses this to make sure 1 bomb gives only 1 item

var PlayerVelWhenThrown: Vector2

@onready var ExplosionParticles: GPUParticles2D = $Sprite/ExplosionParticles
@onready var BombActiveParticle: GPUParticles2D = $Sprite/BombActiveParticle
@onready var SpawnActivationCoolDown: Timer = $SpawnActivationCoolDown
@onready var Sprite: Node2D = $Sprite
@onready var AfterExplosionCoolDown: Timer = $AfterExplosionCoolDown
@onready var AutoExplosionTimer: Timer = $AutoExplosionTimer
@onready var ExplosionTriggerRange: Area2D = $ExplosionTriggerRange
@onready var ExplosionRing: Sprite2D = $ExplosionRing

@onready var Player: CharacterBody2D = $"../.."

var Speed: int  = 100

func _ready() -> void:
	self.set_collision_layer_value(3,false)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if BombFoundLove and Thrown:
		linear_velocity += (BombsLove.global_position - self.global_position).normalized() * Speed * delta

func Throw(Loc): #Loc is the marker on the lef or the right side of the ship
	if !Thrown:
		PlayerVelWhenThrown = Player.velocity
		apply_central_force(PlayerVelWhenThrown * 50)
		for Img in Sprite.get_children():
			if Img is not GPUParticles2D:
				Img.visible = true
		AutoExplosionTimer.start()
		self.set_collision_layer_value(3,true) #Only when thrown will the item thrower will be able to detect the bombs
		ExplosionTriggerRange.set_collision_mask_value(1,true) 
		# the explosion trigger range also looks for the bombs love, 
		# now it will only look in layer 1 when thrown
		SpawnActivationCoolDown.start()
		top_level = true
		global_position = Loc.global_position
		Thrown = true
		var RotTween = create_tween()
		RotTween.tween_property(self,"angular_velocity",2,5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
		RotTween.parallel().tween_property(Sprite,"scale",Vector2(6,6),1).set_trans(Tween.TRANS_ELASTIC)



func _on_explosion_trigger_range_body_entered(body: Node2D) -> void:
	if Thrown and body != self:
		Explode()

func _on_spawn_cool_down_timeout() -> void:
	if Thrown and !Exploded:
		ExplosionTriggerRange.set_collision_mask_value(1,true)
		ExplosionTriggerRange.set_collision_mask_value(2,true)
		ExplosionTriggerRange.set_collision_mask_value(3,true)
		SpawnCoolDownOver = true
		BombActiveParticle.emitting = true
		BombActive = true

func Explode():
	var ExplosionRingTween = create_tween()
	ExplosionRingTween.connect("finished",OnExplosionRingEnded)
	ExplosionRingTween.tween_property(ExplosionRing,"scale",Vector2(1,1),2.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	ExplosionRingTween.parallel().tween_property(ExplosionRing,"modulate",Color(0,0,0,0),3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	#Reparenting of bomb happen in the Player Script
	for Img in Sprite.get_children():
		if Img is not GPUParticles2D:
			Img.visible = false
	#Thrown = false
	ExplosionParticles.emitting = true
	BombActiveParticle.emitting = false
	ExplosionTriggerRange.set_collision_mask_value(1,false)
	ExplosionTriggerRange.set_collision_mask_value(2,false)
	ExplosionTriggerRange.set_collision_mask_value(3,false)
	await get_tree().create_timer(.1).timeout
	self.set_collision_layer_value(3,false)
	AfterExplosionCoolDown.start()
	BombFoundLove = false
	BombsLove = null
	Player.emit_signal("BombExploded", self)



func _on_explosion_trigger_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("GravityInfluencer"):
		BombFoundLove = true
		BombsLove = area.get_parent()

func _on_explosion_trigger_range_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_after_explosion_cool_down_timeout() -> void:
	Player.emit_signal("BombReloadReady",self)


func _on_auto_explosion_timer_timeout() -> void:
	if Thrown:
		Explode()


func OnExplosionRingEnded() -> void:
	print('?D?D?')
	Thrown = false
	Sprite.scale = Vector2.ZERO
	ExplosionRing.scale = Vector2.ZERO
	ExplosionRing.modulate = Color(1,1,1,1)
	Exploded = false
	SpawnCoolDownOver = false
	BombActive = false
	#BombFoundLove = false
	Used = false
