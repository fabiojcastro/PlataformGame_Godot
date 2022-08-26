extends Area2D
class_name DetectionArea

export(NodePath) onready var enemy = get_node(enemy) as KinematicBody2D


func _ready():
	pass # Replace with function body.

func on_body_entered(body: Player) -> void:
	enemy.player_ref = body
	



func on_body_exited(body):
	pass # Replace with function body.
