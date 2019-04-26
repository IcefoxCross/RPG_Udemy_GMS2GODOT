extends AudioStreamPlayer

func sound(file):
	stream = load(file)
	play()