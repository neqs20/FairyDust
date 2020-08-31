## Logger
## @desc:
##     Logger class keeps file opened throughout the whole runtime
extends Node

enum TYPE { DEBUG, INFO, WARNING, ERROR, NONE }

const TAGS := ["[DEBUG]", "[INFO]", "[WARNING]", "[ERROR]"]

const HEADER_BORDER := "############################################################"
const LEFT_BORDER := "#                   "
const RIGHT_BORDER := "                   #"
const folder_path := "user://logs/"
const FILE_NAME := "stdout.log"

var log_level : int = TYPE.DEBUG

var _log_file: File = null


func _init() -> void:
	load_file()
	delete_recursive(list_files(folder_path))

func _exit_tree() -> void:
	if not _log_file == null:
		_log_file.close()


## Returns time in [HH:MM:SS] format
func get_time() -> String:
	var time : Dictionary = OS.get_time()
	return "[%02d:%02d:%02d]" % [time["hour"], time["minute"], time["second"]]


##  Returns date and time in DD.MM.YYYY, HH:MM:SS format
func get_datetime() -> String:
	var datetime : Dictionary = OS.get_datetime()
	return "%02d.%02d.%04d, %02d:%02d:%02d" % [datetime["day"], datetime["month"], 
			datetime["year"], datetime["hour"], datetime["minute"], datetime["second"]]


## Prints and stores [param format_string] formatted with [param args]
## with specified [param level]
func out(level: int, format_string := "", args := []) -> void:
	if log_level <= level and level >= TYPE.DEBUG and level < TYPE.NONE:
		print_and_store(get_time() + "[CLIENT]" + TAGS[level] + ": "+ format_string.format(args, "{_}"))


## Logs debug level message
func debug(format_string: String, args := []) -> void:
	out(TYPE.DEBUG, format_string, args)


## Logs info level message
func info(format_string: String, args := []) -> void:
	out(TYPE.INFO, format_string, args)


## Logs warning level message
func warn(format_string: String, args := []) -> void:
	out(TYPE.WARNING, format_string, args)


## Logs error level message
func error(format_string: String, args := []) -> void:
	out(TYPE.ERROR, format_string, args)


## Creates or opens a file
func load_file() -> void:
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


## Stores [param line] in a file if it's open
func store(line : String) -> void:
	if not line.empty() and not _log_file == null:
		_log_file.store_line(line)


## Prints and stores [param line]. Printing isn't available on release export
func print_and_store(line : String) -> void:
	print(line)
	store(line)


func list_files(path: String) -> Array:
	var ret := []

	var dir := Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin(true, true)

		var file := dir.get_next()

		while not file.empty():
			if not dir.current_is_dir() and file.get_basename().match("????-??-??"):
				ret.append(file)

			file = dir.get_next()

		dir.list_dir_end()

	return ret


func delete_recursive(files: Array) -> void:
	if files.size() > 10:
		var file = files.min()
		files.erase(file)
		
		delete_recursive(files)

