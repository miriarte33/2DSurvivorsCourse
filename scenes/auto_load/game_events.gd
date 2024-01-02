extends Node

# Singleton for global game events and signals.
# Setup to Autoload in the project settings to make sure the game always loads this

signal experience_vial_collected(number: float)


# Method to emit the experience_vial_collected signal
# Listeners to that signal will be able to do something with it
func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)
