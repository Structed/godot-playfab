extends Node


var _current_method: String = ""
var _dir: String = ""
var _path: String
var _test: Node
var results: Node # either server or results tree

signal results_received

func run(metadata: Dictionary) -> void:
	_dir = metadata["dir"]
	_path = metadata["path"]
	var _methods = metadata["methods"]
	
	# Default test results to -1 if there is a parse error, so the CLI or GUI will..
	# ..know that an error had occurred.
	var test_results = {
		total = -1,
		passed = -1,
		context = metadata["name"],
		methods = _methods,
		success = false,
		path = _path,
		time_taken = metadata["time"],
		dir = _dir
	}

	# If there was a parsing error, skip the test case.
	if metadata.get("parse", OK) == OK:
		# Signals leak in C# so we're just using a direct connection and GetParent Calls
		_test = load(_path).new().setup(_dir, _path, _methods)
		_test.connect("test_method_started", self, "_on_test_method_started")
		_test.connect("described", self, "_on_test_method_described")
		_test.connect("asserted", self, "_on_asserted")
		_test.connect("test_method_finished", self, "_on_test_method_finished")
		_test.connect("test_script_finished", self, "_on_test_script_finished")
		_on_test_script_started(metadata) # Needs to be after _test is loaded.
		
		# We need to wait for the object itself to emit the signal (since we..
		# ..cannot yield for C# so we defer the call to run so we have time to..
		# ..to setup our yielding rather than deal with a race condition)
		call_deferred("add_child", _test)
		test_results = yield(self, "results_received") # test_script_finished
		_test.queue_free()
		# Reset for the next case.
		_test = null
	else:
		_on_test_script_started(metadata)
		# Nothing to call_deferred here, so just yield for next idle_frame.
		yield(get_tree(), "idle_frame")
		_on_test_script_finished(test_results)
	return test_results
	
func _on_test_script_started(data: Dictionary) -> void:
	data["title"] = _test.title() if is_instance_valid(_test) else data["name"]
	if results != null:
		results.on_test_script_started(data)

# Results broker doesn't make any sense
func _on_test_script_finished(data: Dictionary) -> void:
	if results != null:
		results.on_test_script_finished(data)
	emit_signal("results_received", data)
	
func _on_test_method_started(method) -> void:
	var x = {"dir" : _dir, "path": _path, "method": method}
	#emit_signal("method_started", x) # What about "described" methods?
	if results != null:
		results.on_test_method_started(x)
	_current_method = method

func _on_test_method_finished() -> void:
	var method = _test._case._methods.back()
	var count = method["total"]
	var passed = method["passed"]
	var success = count > 0 and count == passed
	var x = {"dir": _dir, "path": _path, "method": _current_method, "success": success, "total": count, "passed": passed}
	if results != null:
		results.on_test_method_finished(x)
	
func _on_asserted(assertion) -> void:
	var x = {"dir" : _dir, "path": _path, "method": _current_method, "assertion": assertion}
	if results != null:
		results.on_asserted(x) #emit_signal("asserted", x)
	
func _on_test_method_described(desc: String) -> void:
	var x = {"dir": _dir, "path": _path, "method": _current_method, "description": desc}
	if results != null:
		results.on_test_method_described(x)
