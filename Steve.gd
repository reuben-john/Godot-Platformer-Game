extends KinematicBody2D

enum States {AIR, FLOOR, LADDER, WALL}
var state = States.AIR

var velocity = Vector2(0, 0)
var direction = 1
var last_jump_direction = 1
var on_ladder := false
const SPEED = 300
const RUN_SPEED = SPEED * 1.7
const GRAVITY = 35
const JUMPFORCE = -900
const FIREBALL = preload("res://Fireball.tscn")

func _physics_process(delta):
	match state:
		States.AIR:
			if is_on_floor() and velocity.y == 0:
				last_jump_direction = 0
				state = States.FLOOR
				continue
			elif is_near_wall():
				state = States.WALL
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			$Sprite.play("air")
			if Input.is_action_pressed("right"):
				velocity.x = lerp(velocity.x, SPEED, 0.1) if velocity.x <  SPEED else lerp(velocity.x, SPEED, 0.03)
				$Sprite.flip_h = false;
			elif Input.is_action_pressed("left"):
				velocity.x = lerp(velocity.x, -SPEED, 0.1) if velocity.x > -SPEED else lerp(velocity.x, -SPEED, 0.03)
				$Sprite.flip_h = true;
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			set_direction()
			move_and_fall(false)
			fire()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			if Input.is_action_pressed("right"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.9)
					velocity.x = lerp(velocity.x, RUN_SPEED, 0.1)
				else:
					velocity.x = lerp(velocity.x, SPEED, 0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.play("walk")
				$Sprite.flip_h = false;
			elif Input.is_action_pressed("left"):
				if Input.is_action_pressed("run"):
					$Sprite.set_speed_scale(1.9)
					velocity.x = lerp(velocity.x, -RUN_SPEED, 0.1)
				else:
					velocity.x = lerp(velocity.x, -SPEED, 0.1)
					$Sprite.set_speed_scale(1.0)
				$Sprite.play("walk")
				$Sprite.flip_h = true;
			else:
				$Sprite.play("idle")
				velocity.x = lerp(velocity.x, 0, 0.2)
				
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMPFORCE
				$SoundJump.play()
				state = States.AIR
			set_direction()
			move_and_fall(false)
			fire()
		States.WALL:
			if is_on_floor():
				last_jump_direction = 0
				state = States.FLOOR
				continue
			elif ! is_near_wall():
				state = States.AIR
				continue
			elif should_climb_ladder():
				state = States.LADDER
				continue
			$Sprite.play("wall")
			
			if direction != last_jump_direction and Input.is_action_pressed("jump") and (
				(Input.is_action_pressed("left") and direction == 1) or 
				(Input.is_action_pressed("right") and direction == -1)):
				last_jump_direction = direction
				velocity.x = 450 * -direction
				velocity.y = JUMPFORCE * 0.8
				$SoundJump.play()
			move_and_fall(true)
		States.LADDER:
			if not on_ladder:
				state = States.AIR
				continue
			elif is_on_floor() and Input.is_action_pressed("down") and velocity.y == 0:
				state = States.FLOOR
				Input.action_release("down")
				Input.action_release("up")
				continue
			elif Input.is_action_just_pressed("jump"):
				States.AIR				
				Input.action_release("down")
				Input.action_release("up")
				velocity.y = JUMPFORCE * 0.7
				continue
			if Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				$Sprite.play("climb")
			else:
				$Sprite.stop()
			
			if Input.is_action_pressed("up"):
				velocity.y = -SPEED
			elif Input.is_action_pressed("down"):
				velocity.y = SPEED
			else:
				velocity.y = lerp(velocity.y, 0, 0.3)
			
			velocity = move_and_slide(velocity, Vector2.UP)
				
func should_climb_ladder() -> bool:
	return on_ladder and ( Input.is_action_pressed("up") or Input.is_action_pressed("down") )


func set_direction():
	direction = 1 if not $Sprite.flip_h else -1
	$WallChecker.rotation_degrees = 90 * -direction


func is_near_wall():
	return $WallChecker.is_colliding() and not $WallChecker.get_collider().is_in_group("one_way")
	

func fire():
	if Input.is_action_just_pressed("fire") and not is_near_wall():
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 35 * direction


func move_and_fall(slow_fall: bool):
	velocity.y = velocity.y + GRAVITY
	if slow_fall:
		velocity.y = clamp(velocity.y, JUMPFORCE, 200)
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Fallzone_body_entered(body):
	PlayerVariables.lose_life()
	if PlayerVariables.lives >= 1:
		get_tree().reload_current_scene()


func bounce():
	velocity.y = JUMPFORCE * 0.7


func ouch(var enemy_posx):
	PlayerVariables.lose_life()
	set_modulate(Color(1, 0.3, 0.3, 0.3))
	velocity.y = JUMPFORCE * 0.5
	
	if position.x < enemy_posx:
		velocity.x = -800
	elif position.x > enemy_posx:
		velocity.x = 800
	
	Input.action_release("left")
	Input.action_release("right")
	
	$Timer.start()


func _on_Timer_timeout():
	set_modulate(Color(1, 1, 1, 1))
	
	


func _on_LadderChecker_body_entered(body):
	on_ladder = true


func _on_LadderChecker_body_exited(body):
	on_ladder = false
