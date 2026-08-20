extends Node
###################### VARIABLES ######################

###################### FUNCTIONS ######################
func set_timer(time: float):
	await get_tree().create_timer(time).timeout;
