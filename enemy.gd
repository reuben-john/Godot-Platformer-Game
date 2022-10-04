extends KinematicBody2D

var velocity = Vector2()
export var direction = -1
export var detect_cliffs = true

func _ready():
	if direction == 1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$floor_checker.enabled = detect_cliffs
	
func _physics_process(delta):
	
	if is_on_wall() or not $floor_checker.is_colliding() and detect_cliffs and is_on_floor():
		direction = direction * -1
		$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * direction
		
	velocity.y += 20
	
	velocity.x = 50 * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
