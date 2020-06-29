extends Node

enum TYPE { DEBUG, INFO, WARNING, ERROR, NONE }

const folder_path := "user://logs/"
const FILE_NAME := "log.txt"
const EMPTY := ""
const ZERO := "0"
const DOT := "."
const COMA_SEPERATOR := ", "
const COLON := ":"
const HOUR := "hour"
const MINUTE := "minute"
const SECOND := "second"
const DAY := "day"
const MONTH := "month"
const YEAR := "year"
const LEFT_BRACKET := "["
const RIGHT_BRACKET := "]"

const CLIENT_TAG := "[CLIENT]"
const LOG_TAGS := ["[DEBUG]", "[INFO]", "[WARNING]", "[ERROR]"]
const TAG_SUFFIX := ": "

const HEADER_BORDER := "############################################################"
const LEFT_BORDER := "#                   "
const RIGHT_BORDER := "                   #"

var log_level = TYPE.DEBUG

var _log_file: File = null


func _init() -> void:
	create_file()


func _notification(what: int) -> void:
	if what == 11:
		if not _log_file == null:
			_log_file.close()


func get_time() -> String:
	var date : Dictionary = OS.get_datetime()
	return LEFT_BRACKET + (ZERO if date[HOUR] < 10 else EMPTY) + str(date[HOUR]) + COLON + \
			(ZERO if date[MINUTE] < 10 else EMPTY) + str(date[MINUTE]) + COLON + \
			(ZERO if date[SECOND] < 10 else EMPTY) + str(date[SECOND]) + RIGHT_BRACKET


func out(level: int, format_string := "", args := []) -> void:
	if log_level <= level and level >= TYPE.DEBUG and level < TYPE.NONE:
		print_and_store(get_time() + CLIENT_TAG + LOG_TAGS[level] + 
				TAG_SUFFIX + format_string.format(args, "{_}"))


func debug(format_string := EMPTY, args := []) -> void:
	out(TYPE.DEBUG, format_string, args)


func info(format_string := EMPTY, args := []) -> void:
	out(TYPE.INFO, format_string, args)


func warn(format_string := EMPTY, args := []) -> void:
	out(TYPE.WARNING, format_string, args)


func error(format_string := EMPTY, args := []) -> void:
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

		_log_file.open(folder_path.plus_file(FILE_NAME), File.WRITE_READ)

	var date = OS.get_datetime()

	store(HEADER_BORDER)
	store(LEFT_BORDER + 
			(ZERO if date[DAY] < 10 else EMPTY) + str(date[DAY]) + DOT +
			(ZERO if date[MONTH] < 10 else EMPTY) + str(date[MONTH]) + DOT +
			str(date[YEAR]) + COMA_SEPERATOR +
			(ZERO if date[HOUR] < 10 else EMPTY) + str(date[HOUR]) + COLON + 
			(ZERO if date[MINUTE] < 10 else EMPTY) + str(date[MINUTE]) + COLON +
			(ZERO if date[SECOND] < 10 else EMPTY) + str(date[SECOND]) +
			RIGHT_BORDER)
	store(HEADER_BORDER)


func store(line : String) -> void:
	if not line.empty() and not _log_file == null:
		_log_file.store_line(line)


func print_and_store(line : String) -> void:
	print(line)
	store(line)
