extends Area2D

signal update_coin_text


func _on_coin_body_entered(body):
	$AnimationPlayer.play("bounce")
	PlayerVariables.add_coins(1)
	set_collision_mask_bit(0, 0)
	get_parent().find_node("HUD").find_node("coins").set_text(str(PlayerVariables.coins))
	$SoundCoinCollect.play()
	
	if PlayerVariables.coins == 3:
		PlayerVariables.reset_coins()
		get_tree().change_scene("res://YouWin.tscn") 
		
func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
