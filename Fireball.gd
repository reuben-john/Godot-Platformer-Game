extends KinematicBody2D

var velocity = Vector2()
var direction = 1

const SPEED = 800
const GRAVITY = 22
const BOUNCE = -300


func _ready():
	velocity.x = SPEED * direction
	
func _physics_process(delta):
	$Sprite.rotation_degrees += 25 * direction
	velocity.y += GRAVITY
	
	if is_on_wall():
		queue_free()
	if is_on_floor():
		velocity.y = BOUNCE
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	$AudioStreamPlayer2D.play()
