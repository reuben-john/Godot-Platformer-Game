extends Area2D



func _on_coin_body_entered(body):
	$AnimationPlayer.play("bounce")
	PlayerVariables.add_coins(1)
	set_collision_mask_bit(0, 0)

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
