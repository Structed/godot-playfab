class_name GdUnitTestSuiteReport
extends GdUnitReportSummary

var _time_stamp :int


func _init(p_resource_path :String, p_name :String):
	_resource_path = p_resource_path
	_name = p_name
	_time_stamp = Time.get_unix_time_from_system() as int


func create_record(report_link :String) -> String:
	return GdUnitHtmlPatterns.build(GdUnitHtmlPatterns.TABLE_RECORD_TESTSUITE, self, report_link)


func output_path(report_dir :String) -> String:
	return "%s/test_suites/%s.%s.html" % [report_dir, path().replace("/", "."), name()]


func path_as_link() -> String:
	return "../path/%s.html" % path().replace("/", ".")


func write(report_dir :String) -> String:
	var template := GdUnitHtmlPatterns.load_template("res://addons/gdUnit4/src/report/template/suite_report.html")
	template = GdUnitHtmlPatterns.build(template, self, "")\
		.replace(GdUnitHtmlPatterns.BREADCRUMP_PATH_LINK, path_as_link())
		
	var report_output_path := output_path(report_dir)
	var test_report_table := PackedStringArray()
	for test_report in _reports:
		test_report_table.append(test_report.create_record(report_output_path))
	
	template = template.replace(GdUnitHtmlPatterns.TABLE_BY_TESTCASES, "\n".join(test_report_table))
	
	var dir := report_output_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	FileAccess.open(report_output_path, FileAccess.WRITE).store_string(template)
	return report_output_path


func set_duration(p_duration :int) -> void:
	_duration = p_duration


func time_stamp() -> int:
	return _time_stamp


func duration() -> int:
	return _duration


func set_skipped(skipped :int) -> void:
	_skipped_count = skipped


func set_orphans(orphans :int) -> void:
	_orphan_count = orphans


func set_failed(failed :bool) -> void:
	if failed:
		_failure_count += 1


func update(test_report :GdUnitTestCaseReport) -> void:
	for report in _reports:
		if report.name() == test_report.name():
			report.update(test_report)
