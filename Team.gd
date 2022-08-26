extends Node2D


enum TeamName {
	PLAYER_TEAM,
	ENEMY_TEAM
}


export (TeamName) var team : int = TeamName.PLAYER_TEAM
