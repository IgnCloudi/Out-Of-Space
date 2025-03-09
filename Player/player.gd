extends CharacterBody2D

signal InOrbit
signal BombExploded
signal BombReloadReady

@onready var Player: CharacterBody2D = $"."
@onready var MainEngineParticles: GPUParticles2D = $MainEngineParticles
@onready var Bombs: Node2D = $Bombs
@onready var BombsInCooldown: Node = $BombsInCooldown
@onready var LeftBombSpawnLoc: Marker2D = $LeftBombSpawnLoc
@onready var RightBombSpawnLoc: Marker2D = $RightBombSpawnLoc
@onready var Inventory: Control = $CanvasLayer/Panel/Inventory
@onready var DepositUi: Control = $CanvasLayer/Panel/DepositUI
@onready var NotEnoughItemsText: Button = $CanvasLayer/NotEnoughItems
@onready var PressTab: Button = $CanvasLayer/PressTab
@onready var TransitionalNZoomCam: Camera2D = $TransitionalNZoomCam
@onready var PlayerCam: Camera2D = $Camera2D
@onready var You: Sprite2D = $You
@onready var UpgradesUI: Control = $CanvasLayer/UpgradesUI
@onready var JetNoise: AudioStreamPlayer = $JetNoise
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var InvenOpen: bool = false
@export var InEarthRange:  bool = false
var DepositUIOpen: bool = false
var InShop: bool = false

var TabToolTipVis: bool = false

var Speed = 10000
var Direction

var ZoomedOut: bool = false

@export var PlayerInOrbit: bool = false
var PathFollow: PathFollow2D

func _ready() -> void:
	animation_player.play("Trans")
	GlobalSingleton.PlayerInvenBar = $CanvasLayer/BagProgressBar
	GlobalSingleton.PlayerCanvas = $CanvasLayer
	GlobalSingleton.UpdateMainBar()
	InOrbit.connect(OnEnteredOrbit)
	BombExploded.connect(SetBombCoolDown)
	BombReloadReady.connect(ReloadBomb)
	velocity = Vector2(100,0)
	var tween = create_tween()
	tween.tween_property(self,"velocity",Vector2.ZERO,2).set_trans(Tween.TRANS_CUBIC)

func _process(delta: float) -> void:
	
	if !InShop and !InvenOpen and Input.is_action_just_released("LeftGrenade") and Bombs.get_child_count() > 0:
		Bombs.get_child(0).Throw(LeftBombSpawnLoc)
	elif !InShop and !InvenOpen and Input.is_action_just_released("RightGrenade") and Bombs.get_child_count() > 0:
		Bombs.get_child(0).Throw(RightBombSpawnLoc)
	elif Input.is_action_just_released("Tab") and !InShop:
		if !InvenOpen:
			if TabToolTipVis:
				TabToolTipAppear(false)
			var InvenTween = create_tween()
			InvenTween.tween_property(Inventory, "global_position", Vector2(-50,0), 1).set_trans(Tween.TRANS_CUBIC)
			if InEarthRange:
				DepositUIOpen = true
				InvenTween.parallel().tween_property(DepositUi, "global_position:x", 50, 1.25).set_trans(Tween.TRANS_CUBIC)
		elif InvenOpen:
			var InvenTween = create_tween()
			InvenTween.tween_property(Inventory, "global_position", Vector2(-940,0), 1).set_trans(Tween.TRANS_CUBIC)
			if InEarthRange:
				DepositUIOpen = false
				InvenTween.parallel().tween_property(DepositUi, "global_position:x", -940, .75).set_trans(Tween.TRANS_CUBIC)
		InvenOpen = !InvenOpen
	elif Input.is_action_just_released("Zoom"):
		Zoom()
		
	if Direction:
		var DirAngle = (Player.global_position+Direction - Player.global_position).angle()
		Player.global_rotation = lerp_angle(Player.global_rotation, DirAngle, get_process_delta_time()*2)

func Zoom():
	if !ZoomedOut:
		ZoomedOut = true
		TransitionalNZoomCam.global_position = PlayerCam.global_position
		TransitionalNZoomCam.make_current()
		var ZoomTween = create_tween()
		ZoomTween.tween_property(TransitionalNZoomCam,"global_position", Vector2.ZERO,1).set_trans(Tween.TRANS_CUBIC)
		ZoomTween.parallel().tween_property(TransitionalNZoomCam,"zoom",Vector2(.1,.1),1).set_trans(Tween.TRANS_CUBIC)
		ZoomTween.parallel().tween_property(You,"scale",Vector2(5,5),1).set_trans(Tween.TRANS_CUBIC)
	else:
		ZoomedOut = false
		var ZoomTween = create_tween()
		ZoomTween.connect("finished",ZoomedBackIn)
		ZoomTween.tween_property(TransitionalNZoomCam,"global_position", PlayerCam.global_position,1).set_trans(Tween.TRANS_CUBIC)
		ZoomTween.parallel().tween_property(TransitionalNZoomCam,"zoom",PlayerCam.zoom,1).set_trans(Tween.TRANS_CUBIC)
		ZoomTween.parallel().tween_property(You,"scale",Vector2.ZERO,.5).set_trans(Tween.TRANS_CUBIC)

func ZoomedBackIn():
	PlayerCam.make_current()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	Direction = Input.get_vector("ui_left", "ui_right","ui_up","ui_down") #the vector is pre normalized
	if !PlayerInOrbit and Direction:
		MainEngineParticles.emitting = true
		velocity = lerp(velocity, Direction*Speed*delta, delta*2)
	else:
		MainEngineParticles.emitting = false
		velocity = lerp(velocity, Vector2.ZERO, delta*2)
	
	if PlayerInOrbit:
		PathFollow.progress_ratio += delta / PathFollow.get_parent().curve.get_baked_length() * 75 
		#PathFollow.progress_ratio+=delta/100
		Player.velocity = PathFollow.global_position-Player.global_position 
		if Direction:
			Player.velocity = Direction*Speed*delta
	move_and_slide()

func OnEnteredOrbit(ThePathFollow2D):
	PathFollow = ThePathFollow2D
	var Path = PathFollow.get_parent()
	PathFollow.progress = Path.curve.get_closest_offset(Path.to_local(Player.global_position))
	PlayerInOrbit = true

func ReloadBomb(Bomb):
	Bomb.reparent(Bombs)
	Bomb.top_level = false
	Bomb.global_position = Bombs.global_position
	#Bomb.scale = Vector2.ZERO

func _on_item_pickup_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Item"):
		var ItemBody = area.get_parent()
		ItemBody.emit_signal("GoToPlayer",Player)

func _on_item_pickup_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("Item"):
		var ItemBody = area.get_parent()
		ItemBody.InRangeToFollow = false

func SetBombCoolDown(Bomb):
	Bomb.reparent(BombsInCooldown)

func NotEnoughItems(Text):
	NotEnoughItemsText.text = Text
	var tween = create_tween()
	tween.tween_property(NotEnoughItemsText,"scale", Vector2(1,1), 1).set_trans(Tween.TRANS_ELASTIC)
	NotEnoughItemsText.get_child(0).start()

func _on_timer_to_remove_timeout() -> void:
	var tween = create_tween()
	tween.connect("finished",NotEnoughItemsGone)
	tween.tween_property(NotEnoughItemsText,"modulate:a", 0, 1).set_trans(Tween.TRANS_CUBIC)

func NotEnoughItemsGone():
	NotEnoughItemsText.scale = Vector2.ZERO
	NotEnoughItemsText.modulate.a = 1
	

func TabToolTipAppear(MakeVisible):
	var TabTween = create_tween()
	if MakeVisible:
		TabTween.tween_property(PressTab,"scale",Vector2(.1,.1),1).set_trans(Tween.TRANS_ELASTIC)
		TabToolTipVis = true
	else:
		TabTween.tween_property(PressTab,"scale",Vector2(0,0),1).set_trans(Tween.TRANS_ELASTIC)
		TabToolTipVis = false

func ShopAnim(BringIn):
	if BringIn:
		if InvenOpen:
			var InvenTween = create_tween()
			InvenTween.tween_property(Inventory, "global_position", Vector2(-940,0), 1).set_trans(Tween.TRANS_CUBIC)
			if InEarthRange:
				DepositUIOpen = false
				InvenTween.parallel().tween_property(DepositUi, "global_position:x", -940, .75).set_trans(Tween.TRANS_CUBIC)
			InvenOpen = false
		InShop = true
		var UpgradeAnimTween = create_tween()
		UpgradeAnimTween.tween_property(UpgradesUI,"global_position:y",320,1).set_trans(Tween.TRANS_ELASTIC)
	else:
		InShop = false
		var UpgradeAnimTween = create_tween()
		UpgradeAnimTween.tween_property(UpgradesUI,"global_position:y",1008,1).set_trans(Tween.TRANS_CUBIC)
