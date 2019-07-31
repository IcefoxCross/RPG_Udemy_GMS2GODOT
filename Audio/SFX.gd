extends AudioStreamPlayer

"""
SFX - Sound Effects Node
An audio node recommended for audio files that will be played once for a brief moment during the game.

Functions
---
sound(file): Loads the filepath sent as argument into the node, then plays it immediatly.
"""

func sound(file):
	stream = load(file)
	play()