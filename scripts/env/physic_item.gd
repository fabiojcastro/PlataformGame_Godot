extends RigidBody2D
class_name PhysicItem

onready var sprite: Sprite = get_node("Texture")
# constante que irá receber a animacao de drop
const COLLECT_EFFECT: PackedScene = preload("res://scenes/general_effects/collect_item.tscn")
var player_ref: KinematicBody2D = null

var item_name: String
var item_texture: StreamTexture
var item_info_list: Array

# Executando a função randomica da Godot
func _ready() -> void:
	randomize()
	apply_random_impulse()

#Aplicação de física no item que será lançado no drop.	
func apply_random_impulse() -> void:
	apply_impulse(
		Vector2.ZERO, 
		Vector2(
		rand_range(-60, 60), 
		-90
		)
	)
	
	#A linha depois da função, especifica que essa função so será executada quando self (ela mesmo) estiver "ready",
	#so vai executar quando tudo acima estiver pronto, afim de evitar possíveis bugs. "co rotina"
func update_item_info(key: String, texture: StreamTexture, item_info: Array) -> void:
	yield(self,"ready")
	
	item_name = key
	item_texture = texture
	item_info_list = item_info
	
	sprite.texture = texture

func on_screen_exited():
	queue_free()

func on_body_entered(body: Player):
	player_ref = body

func on_body_exited(_body: Player):
	player_ref = null

func _process(_delta: float) -> void:
	if player_ref != null and Input.is_action_just_pressed("interact"):
		#emitir sinal para spawnar item
		spawn_effect()
		queue_free()
		
func spawn_effect() -> void:
	var collect_effect: EffectTemplate = COLLECT_EFFECT.instance()
	get_tree().root.call_deferred("add_child", collect_effect)
	collect_effect.global_position = global_position
	collect_effect.play_effect()
