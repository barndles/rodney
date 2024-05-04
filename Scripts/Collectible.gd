extends Node2D


func collect():
	get_parent().queue_free() 

func _on_collidable_area_entered(area):
	collect()
