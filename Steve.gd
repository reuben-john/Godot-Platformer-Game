extends KinematicBody2D

enum States {AIR, FLOOR, LADDER, WALL}
var state = States.AIR

var velocity = Vector2(0, 0)
const SPEED = 300
const RUN_SPEED = SPEED * 1.7
const GRAVITY = 35
const JUMPFORCE = -900
const FIREBALL = preload("res://Fireball.tscn")

func _physics_process(delta):
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
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
			move_and_fall()
			fire()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
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
			move_and_fall()
			fire()
	

func fire():
	if Input.is_action_just_pressed("fire"):
		var direction = 1 if not $Sprite.flip_h else -1 
		var f = FIREBALL.instance()
		f.direction = direction
		get_parent().add_child(f)
		f.position.y = position.y
		f.position.x = position.x + 25 * direction


func move_and_fall():
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://GameOver.tscn")


func bounce():
	velocity.y = JUMPFORCE * 0.7


func ouch(var enemy_posx):
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
	get_tree().change_scene("res://GameOver.tscn")
	
