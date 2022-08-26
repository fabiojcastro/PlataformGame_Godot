extends Node2D

class_name Level

onready var player: KinematicBody2D = get_node("Player")

func _ready():
	player.get_node("Texture").connect("game_over", self, "on_game_over")
	
func on_game_over() -> void:
	get_tree().reload_current_scene()

