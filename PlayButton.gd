extends Button


func _on_PlayButton_pressed():
	PlayerVariables.reset_game()
	get_tree().change_scene("res://Level1.tscn")
