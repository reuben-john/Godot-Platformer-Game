extends KinematicBody2D

enum States {AIR, FLOOR, LADDER, WALL}
var state = States.AIR

var velocity = Vector2(0, 0)
const SPEED = 380
const GRAVITY = 35
const JUMPFORCE = -900

func _physics_process(delta):
	
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			$Sprite.play("air")
			if Input.is_action_pressed("right"):
				velocity.x = SPEED
				$Sprite.flip_h = false;
			elif Input.is_action_pressed("left"):
				velocity.x = -SPEED
				$Sprite.flip_h = true;
			else:
				velocity.x = lerp(velocity.x, 0, 0.2)
			move_and_fall()
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
				continue
			if Input.is_action_pressed("right"):
				velocity.x = SPEED
				$Sprite.play("walk")
				$Sprite.flip_h = false;
			elif Input.is_action_pressed("left"):
				velocity.x = -SPEED
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
	
