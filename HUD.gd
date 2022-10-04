extends CanvasLayer

var coins = 0

func _ready():
	$coins.text = String(PlayerVariables.coins)


func _physics_process(delta):
	$coins.text = String(PlayerVariables.coins)
	if PlayerVariables.coins == 3:
		PlayerVariables.reset_coins()
		get_tree().change_scene("res://Level1.tscn") 
		
