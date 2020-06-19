extends Node

enum TYPE { DEBUG = 0, INFO = 1, WARNING = 2, ERROR = 3, NONE = 4 }

const folder_path : String = "user://logs/"
const FILE_NAME : String = "log.txt"

const EMPTY : String = ""
const ZERO : String = "0"
const DOT : String = "."
const COMA_SEPERATOR : String = ", "
const COLON : String = ":"
const HOUR : String = "hour"
const MINUTE : String = "minute"
const SECOND : String = "second"
const DAY : String = "day"
const MONTH : String = "month"
const YEAR : String = "year"
const LEFT_BRACKET : String = "["
const RIGHT_BRACKET : String = "]"

const CLIENT_TAG : String = "[CLIENT]"
const LOG_TAGS : Array = [ "[DEBUG]", "[INFO]", "[WARNING]", "[ERROR]" ]
const TAG_SUFFIX : String = ": "

const HEADER_BORDER : String = "############################################################"
const LEFT_BORDER : String = "#                   "
const RIGHT_BORDER : String = "                   #"

var log_level = TYPE.DEBUG
var log_file

func _init() -> void:
	create_file()

func _notification(what : int) -> void:
	if what == 11:
		if not log_file == null:
			log_file.close()

func get_time() -> String:
	var date : Dictionary = OS.get_datetime()
	return LEFT_BRACKET + (ZERO if date[HOUR] < 10 else EMPTY) + str(date[HOUR]) + COLON + \
			(ZERO if date[MINUTE] < 10 else EMPTY) + str(date[MINUTE]) + COLON + \
			(ZERO if date[SECOND] < 10 else EMPTY) + str(date[SECOND]) + RIGHT_BRACKET

func out(level : int, format_string : String = "", args := []) -> void:
	if log_level <= level and level >= TYPE.DEBUG and level < TYPE.NONE:
		print_and_store(get_time() + CLIENT_TAG + LOG_TAGS[level] + TAG_SUFFIX + format_string.format(args, "{_}"))

func debug(format_string : String = EMPTY, args := []) -> void:
	out(TYPE.DEBUG, format_string, args)

func info(format_string : String = EMPTY, args := []) -> void:
	out(TYPE.INFO, format_string, args)

func warn(format_string : String = EMPTY, args := []) -> void:
	out(TYPE.WARNING, format_string, args)

func error(format_string : String = EMPTY, args := []) -> void:
	out(TYPE.ERROR, format_string, args)

func create_file() -> void:
	if log_file == null:
		log_file = File.new()
		if log_file.file_exists(folder_path.plus_file(FILE_NAME)):
			log_file.open(folder_path.plus_file(FILE_NAME), File.READ_WRITE)
			log_file.seek_end()
		else:
			var dir = Directory.new()
			if not dir.dir_exists(folder_path):
				dir.make_dir(folder_path)
			log_file.open(folder_path.plus_file(FILE_NAME), File.WRITE_READ)
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
	if not line.empty() and not log_file == null:
		log_file.store_line(line)

func print_and_store(line : String) -> void:
	print(line)
	store(line)

