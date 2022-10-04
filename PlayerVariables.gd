extends Node

var coins = 0

func add_coins(amount):
	coins += amount

func reset_coins():
	coins = 0

func remove_coins(amount):
	coins -= amount
