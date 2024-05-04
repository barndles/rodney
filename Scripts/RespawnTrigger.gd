extends Node2D

@onready var area2D = $Area2D/CollisionShape2D
@onready var global = get_node("/root/Autoload")

func setRespawnLocation():
	global.respawnLocation = area2D.position
	

func _on_area_2d_area_entered(area):
	setRespawnLocation()
