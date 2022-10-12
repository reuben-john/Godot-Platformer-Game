extends Button


func _ready():
	pass



func _on_MainMenuButton_pressed():
	PlayerVariables.reset_game()
	get_tree().change_scene("res://TitleMenu.tscn")
