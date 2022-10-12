extends CanvasLayer

func _ready():
	$coins.text = String(PlayerVariables.coins)
	load_hearts()
	PlayerVariables.hud = self

func load_hearts():
	$HeartsFull.rect_size.x = PlayerVariables.lives * 53
	$HeartsEmpty.rect_size.x = (PlayerVariables.max_lives - PlayerVariables.lives) * 53
	$HeartsEmpty.rect_position.x = $HeartsFull.rect_position.x + $HeartsFull.rect_size.x * $HeartsFull.rect_scale.x
