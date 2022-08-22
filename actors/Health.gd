extends Node2D

export (int) var max_health: int = 100
export (int) var health: int = max_health setget set_health

func set_health(new_health: int):
	health = clamp(new_health, 0, max_health)
