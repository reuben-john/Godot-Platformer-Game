extends Label


func _ready():
	set_text("Collect " + str(PlayerVariables.target_coins) + "            to win")
