extends KinematicBody2D
class_name EnemyTemplate

onready var texture: Sprite = get_node("Texture")
onready var floor_ray: RayCast2D = get_node("FloorRay")
onready var animation: AnimationPlayer = get_node("Animation")

var can_die: bool = false
var can_hit: bool = false
var can_attack: bool = false

# multiplicador de probabilidade de drop dos items
var drop_bonus: int = 1

var velocity: Vector2
var player_ref: Player = null

#lista dos itens que serão dropados quando o inimigo morrer
var drop_list: Dictionary

# referencia de quanto de xp cada inimigo vai dar.
export(int) var enemy_exp
export(int) var speed
export(int) var gravity_speed
export(int) var proximity_threshold
export(int) var raycast_default_position

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behavior()
	verify_position()
	texture.animate(velocity)
	velocity = move_and_slide(velocity, Vector2.UP)
func gravity(delta: float) -> void:
	velocity.y += delta * gravity_speed

func move_behavior() -> void:
	if player_ref != null:
		var distance: Vector2 = player_ref.global_position - global_position
		var direction: Vector2 = distance.normalized()
		if abs(distance.x) <= proximity_threshold:
			velocity.x = 0
			can_attack = true
		elif floor_collision() and not can_attack:
			velocity.x = direction.x * speed
		else:
			velocity.x = 0
			
		return
	
	velocity.x = 0
	
func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
	return false
		
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		
		if direction > 0:
			texture.flip_h = true
			floor_ray.position.x = abs(raycast_default_position)
		elif direction < 0:
			texture.flip_h = false
			floor_ray.position.x = raycast_default_position

#quando o inimigo morrer ele some da cena e executa o comando de drop de item.			
func kill_enemy() -> void:
	animation.play("kill")
	get_tree().call_group("player_stats", "update_exp", enemy_exp)
	spawn_item_probability()

#Multiplicador bonus para o drop (Existe um dado de 20 lados)
func spawn_item_probability() -> void:
	var random_number: int = randi() % 21
	if random_number <= 6:
		drop_bonus = 1
	if random_number >=7 and random_number <=13:
		drop_bonus = 2
	else:
		drop_bonus = 3		
	
	print("Multiplicador de drop: " +str(drop_bonus))
	for key in drop_list.keys():
		var rng: int = randi() % 100 + 1
		# Se o rng for menor que a key 1(probabilidade do item no dicionario * bonus). 
		if rng <= drop_list[key][1] * drop_bonus:
			#armazena a textura da imagem em uma variável.
			var item_texture: StreamTexture = load(drop_list[key][0])
			#armazena os dados do item em um Array (caminho, tipo, valor atributo, valor venda)
			var item_info: Array = [
				drop_list[key][0], 
				drop_list[key][2], 
				drop_list[key][3], 
				drop_list[key][4], 
				1 #quantidade de intens serão dropados
			]
			
			spawn_physic_item(key, item_texture, item_info)
			break
func spawn_physic_item(key: String, item_texture: StreamTexture, item_info: Array) -> void:
	var physic_item_scene = load("res://scenes/env/physic_item.tscn")
	var item: PhysicItem = physic_item_scene.instance()
	get_tree().root.call_deferred("add_child", item)
	item.global_position = global_position
	item.update_item_info(key, item_texture, item_info)
