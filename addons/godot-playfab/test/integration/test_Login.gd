extends "res://addons/gut/test.gd"

var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
var player_profile_view_constraints = PlayerProfileViewConstraints.new()
var tags = {}
var email = OS.get_environment("GODOT_PLAYFAB_TEST_USER")
var password = OS.get_environment("GODOT_PLAYFAB_TEST_PASSWORD")


func before_all():
	combined_info_request_params.show_all()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints


func test_login__emits_logged_in_signal_and_returns_LoginResult():
	# Arrange
	var pf_client = PlayFabClient.new()
	pf_client.connect("logged_in", self, "_on_logged_in")
	pf_client.connect("api_error", self, "_on_api_error")
	add_child_autofree(pf_client)

	# Act
	pf_client.login_with_email(email, password, tags, combined_info_request_params)

	# wait for pf_client to emit the signal 'logged_in'
	# or 5 seconds, whichever comes first.
	yield(yield_to(pf_client, 'logged_in', 5), YIELD)

	# Assert
	assert_signal_emitted(pf_client, 'logged_in', 'Maybe it did, maybe it didnt, but we still got here.')


func _on_logged_in(login_result: LoginResult):
	assert_not_null(login_result.EntityToken)
	assert_not_null(login_result.InfoResultPayload)
	assert_ne("", login_result.LastLoginTime)
	assert_false(login_result.NewlyCreated)
	assert_eq("BC894B06364B0093", login_result.PlayFabId)
	assert_ne("", login_result.SessionTicket)
	assert_typeof(login_result.TreatmentAssignment, TYPE_DICTIONARY)


func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	var text = "%s" % api_error_wrapper.errorMessage
	var error_details = api_error_wrapper.errorDetails

	if error_details:
		for key in error_details.keys():
			text += "%s: " % key
			for element in error_details[key]:
				text += "%s\n" % element
	print(text)
