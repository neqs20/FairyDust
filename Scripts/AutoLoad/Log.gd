extends Node

enum TYPE { DEBUG, INFO, WARNING, ERROR, NONE }

const date_regex = "^log(\\d{4})(-)((0)[1-9]|(1)[0-2])(-)((0)[1-9]|[1-2][0-9]|(3)[0-1])(\\.txt)$" 
const folder_path = "user://logs/"
const MAX_LOG_FILES = 10

var log_level = TYPE.DEBUG
var d_regex = RegEx.new()

var current_log_path
var log_file
var logger_thread

var output = []


func _init() -> void:
	create_file()
	logger_thread = Thread.new()

	d_regex.compile(date_regex)

func _ready() -> void:
	match logger_thread.start(self, "load_log_files"):
		OK:
			info("A worker thread has started for Server Logger")
		ERR_CANT_CREATE:
			error("Cannnot create thread")

func _notification(what) -> void:
	if what == 11:
		log_file.close()

func get_time() -> String:
	var date = OS.get_datetime()
	return "[" + str(date["hour"]) + ":" + str(date["minute"]) + ":" + str(date["second"]) + "]"

func printout(message : String) -> void:
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
		printout(line)

func debug(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][DEBUG]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.DEBUG:
		printout(line)

func warn(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][WARNING]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.WARNING:
		printout(line)

func error(format_string := "", args := []) -> void:
	var line = get_time() + " [CLIENT][ERROR]: " + format_string.format(args, "{_}")
	if log_level <= TYPE.ERROR:
		printout(line)

func create_file() -> void:
	if log_file == null:
		log_file  = File.new()

		var date = OS.get_datetime()
		var day = str(date["day"]) if date["day"] >= 10 else "0" + str(date["day"])
		var month = str(date["month"]) if date["month"] >= 10 else "0" + str(date["month"])

		current_log_path  = folder_path + "log" + str(date["year"]) + "-" + month + "-" + day + ".txt"

		if log_file.file_exists(current_log_path):
			log_file.open(current_log_path, File.READ_WRITE)
			log_file.seek_end()
		else:
			var dir = Directory.new()
			if not dir.dir_exists(folder_path):
				dir.make_dir(folder_path)

			log_file.open(current_log_path, File.WRITE_READ)

func store(line : String) -> void:
	if not line.empty() and not log_file == null:
		log_file.store_line(line)

func load_log_files(_data) -> void:
	var dir = Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin(true, true)

	var log_files_list = []
	var file
	while true:
		file = dir.get_next()
		if file == "":
			break # continue
		if d_regex.search(file):
			log_files_list.append(file)
	if log_files_list.size() > MAX_LOG_FILES:
		log_files_list.sort()
		delete_old_log_files(log_files_list)

func delete_old_log_files(list : Array) -> void:
	var to_delete = list.slice(MAX_LOG_FILES, list.size() - 1)

	var dir = Directory.new()

	for file in to_delete:
		match dir.open(folder_path):
			_:
				error("Could not open folder '{0}'", [ folder_path ])
		match dir.remove(file):
			OK:
				info("Successfully deleted file '{0}'", [ folder_path + file ])
			FAILED:
				error("Could not delete file '{0}'. It either doesn't exist or access is denied", [ folder_path + file ])
			_:
				error("Unexpected error occured while deleting oldest log file '{0}'", [ folder_path + file ])
		to_delete.pop_front()

func _exit_tree() -> void:
	logger_thread.wait_to_finish()
