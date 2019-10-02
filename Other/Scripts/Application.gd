extends Node

func quit():
	print("Application: quiting")
	Config.save()
	sleep(1) #As the config file grows this should too
	get_tree().quit()

func sleep(seconds : float):
	print("Application: sleeping")
	yield(get_tree().create_timer(seconds), "timeout")
	