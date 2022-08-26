extends Node2D


func handle_bullet_spawned(bullet : Bullet, bullet_owner, team: int, position: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.bullet_owner = bullet_owner
	bullet.team = team
	bullet.global_position = position
	bullet.set_direction(direction)
