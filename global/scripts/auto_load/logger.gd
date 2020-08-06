extends Node

enum TYPE { DEBUG, INFO, WARNING, ERROR, NONE }

const folder_path := "user://logs/"
const FILE_NAME := "stdout.log"

const TAGS := ["[DEBUG]", "[INFO]", "[WARNING]", "[ERROR]"]

const HEADER_BORDER := "############################################################"
const LEFT_BORDER := "#                   "
const RIGHT_BORDER := "                   #"

var log_level : int = TYPE.DEBUG

var _log_file: File = null


func _init() -> void:
	create_file()


func _exit_tree() -> void:
	if not _log_file == null:
		_log_file.close()


func get_time() -> String:
	var time : Dictionary = OS.get_time()
	return "[%s:%s:%s]" % [str(time["hour"]).pad_zeros(2), str(time["minute"]).pad_zeros(2), 
			str(time["second"]).pad_zeros(2)]


func get_datetime() -> String:
	var datetime : Dictionary = OS.get_datetime()
	return "%s.%s.%s, %s:%s:%s" % [str(datetime["day"]).pad_zeros(2), str(datetime["month"]).pad_zeros(2), 
			str(datetime["year"]), str(datetime["hour"]).pad_zeros(2), str(datetime["minute"]).pad_zeros(2), 
			str(datetime["second"]).pad_zeros(2)]

func out(level: int, format_string := "", args := []) -> void:
	if log_level <= level and level >= TYPE.DEBUG and level < TYPE.NONE:
		print_and_store(get_time() + "[CLIENT]" + TAGS[level] + ": "+ format_string.format(args, "{_}"))


func debug(format_string: String, args := []) -> void:
	out(TYPE.DEBUG, format_string, args)


func info(format_string: String, args := []) -> void:
	out(TYPE.INFO, format_string, args)


func warn(format_string: String, args := []) -> void:
	out(TYPE.WARNING, format_string, args)


func error(format_string: String, args := []) -> void:
	out(TYPE.ERROR, format_string, args)


func create_file() -> void:
	if not _log_file == null:
		return
	
	_log_file = File.new()
	
	var full_path : String = folder_path.plus_file(FILE_NAME)
	if _log_file.file_exists(full_path):
		match _log_file.open(full_path, File.READ_WRITE):
			ERR_INVALID_PARAMETER, ERR_FILE_CANT_OPEN:
				_log_file = null
				return

		_log_file.seek_end()
	else:
		var dir = Directory.new()

		if not dir.dir_exists(folder_path):
			dir.make_dir(folder_path)

		var error = _log_file.open(folder_path.plus_file(FILE_NAME), File.WRITE_READ)
		if not error == OK:
			_log_file == null
			return

	store(HEADER_BORDER)
	store(LEFT_BORDER + get_datetime() + RIGHT_BORDER)
	store(HEADER_BORDER)


func store(line : String) -> void:
	if not line.empty() and not _log_file == null:
		_log_file.store_line(line)


func print_and_store(line : String) -> void:
	print(line)
	store(line)
