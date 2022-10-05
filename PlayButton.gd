extends Button


func _on_PlayButton_pressed():
	PlayerVariables.reset_coins()
	get_tree().change_scene("res://Level1.tscn")
