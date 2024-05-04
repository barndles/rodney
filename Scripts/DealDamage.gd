extends Node2D


func dealDamage(area):
	print(area)
	
func _on_collidable_area_entered(area):
	dealDamage(area)
