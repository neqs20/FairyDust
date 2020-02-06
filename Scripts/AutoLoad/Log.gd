extends Node

const date_regex = "^log(\\d{4})(-)((0)[1-9]|(1)[0-2])(-)((0)[1-9]|[1-2][0-9]|(3)[0-1])(\\.txt)$" 
const path = "user://logs/"
const MAX_LOG_FILES = 10

var log_level = TYPE.DEBUG

var d_regex = RegEx.new()

var current_log_path
var current_log_file
var log_files_list = []
var logger_thread := Thread.new()

enum TYPE { DEBUG, INFO, WARNING, ERROR, NONE }

var output = []

func _init():
	create_file()
	d_regex.compile(date_regex)



func _ready():
	var error = logger_thread.start(self, "load_log_files")
	match error:
		ERR_CANT_CREATE:
			error("Cannnot create thread")
		OK:
			info("A worker thread has started for Server Logger")


func _notification(what):
	if what == 11:
		current_log_file.close()
		


func get_time() -> String:
	var date = OS.get_datetime()
	return "[" + str(date["hour"]) + ":" + str(date["minute"]) + ":" + str(date["second"]) + "]"


func print_raw(message : String):
	output.append(message)
	store(message)


func out(level : int, format_string : String, args := []) -> void:
	match level:
		TYPE.INFO:
			info(format_string, args)
		TYPE.WARNING:
			warn(format_string, args)
		TYPE.DEBUG:
			debug(format_string, args)
		TYPE.ERROR, _:
			error(format_string, args)



func info(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][INFO]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.INFO:
		output.append(line)
		store(line)


func debug(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][DEBUG]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.DEBUG:
		output.append(line)
		store(line)


func warn(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][WARNING]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.WARNING:
		output.append(line)
		store(line)


func error(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][ERROR]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.ERROR:
		output.append(line)
		store(line)

func create_file():
	if current_log_file == null:
		var date = OS.get_datetime()
		var day = str(date["day"]) if date["day"] >= 10 else "0" + str(date["day"])
		var month = str(date["month"]) if date["month"] >= 10 else "0" + str(date["month"])
		var year = str(date["year"])
		current_log_path  = path + "log" + year + "-" + month + "-" + day + ".txt"
		current_log_file  = File.new()
		if current_log_file.file_exists(current_log_path):
			current_log_file.open(current_log_path, File.READ_WRITE)
			current_log_file.seek_end()
			print("Opening file ", current_log_path)
		else:
			current_log_file.open(current_log_path, File.WRITE_READ)
			print("Server log file does not exist. Creating...")



func store(line) -> void:
	if not line.empty():
		current_log_file.store_line(line)


func load_log_files(_data) -> void:
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)

	while true:
		var file = dir.get_next()
		if file == "":
			break
		if d_regex.search(file):
			log_files_list.append(file)
	if log_files_list.size() > MAX_LOG_FILES:
		log_files_list.sort()
		delete_old_log_files()
	logger_thread.wait_to_finish()


func delete_old_log_files() -> void:
	for _i in range(log_files_list.size() - MAX_LOG_FILES):
		remove_file(log_files_list[0])
		log_files_list.pop_front()
	


func remove_file(name := "") -> void:
	if name != "":
		var dir = Directory.new()
		dir.open(path)
		var error = dir.remove(name) 
		match error:
			OK:
				info("Successfully deleted file '{0}'", [path + name])
			FAILED:
				error("Could not delete file '{0}'. It either doesn't exist or access is denied", [path + name])
			_:
				error("Unexpected error occured while deleting oldest log file '{0}'", [path + name])
