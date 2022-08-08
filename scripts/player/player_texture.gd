extends Sprite
class_name PlayerTexture

#Linha para integrar o nó Animation Player, isso é necessário pois o Animation Player é filho e não pai, impedindo usar a função get_node direto.
export(NodePath) onready var animation = get_node(animation) as AnimationPlayer

#esta função foi criada no script do Player no pai.
func animate(direction: Vector2) -> void:
	verify_position(direction)
	horizontal_behavior(direction)
	
#condição para fazer o personagem virar o sprite para a esquerda ou direita. 
func verify_position(direction: Vector2) -> void:
	if direction.x > 0:
		flip_h = false
	elif direction.x < 0:
		flip_h = true

#Texture é irmão de textura
func horizontal_behavior(direction: Vector2) -> void:
	if direction.x != 0:
		#play run
		animation.play("run")
	else:
		#idle run
		animation.play("idle")
