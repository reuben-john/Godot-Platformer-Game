extends Node

var coins = 0
var target_coins = 3
var max_lives = 3
var lives = max_lives
var hud


func add_coins(amount):
	coins += amount


func remove_coins(amount):
	coins -= amount


func lose_life():
	lives -= 1
	hud.load_hearts()
	if lives <= 0:
		get_tree().change_scene("res://GameOver.tscn")


func reset_game():
	lives = max_lives
	coins = 0
