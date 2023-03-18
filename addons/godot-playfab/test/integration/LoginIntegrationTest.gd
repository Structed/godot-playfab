class_name LoginIntegrationTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const __source = 'res://Scenes/Login.gd'



var combined_info_request_params = GetPlayerCombinedInfoRequestParams.new()
var player_profile_view_constraints = PlayerProfileViewConstraints.new()
var tags = {}
var email = OS.get_environment("GODOT_PLAYFAB_TEST_USER")
var password = OS.get_environment("GODOT_PLAYFAB_TEST_PASSWORD")


func before_all():
	combined_info_request_params.show_all()
	combined_info_request_params.ProfileConstraints = player_profile_view_constraints


# TODO: Test is (IMO) properly implemented, `logged_in` is in fact fired
# but GDUnit thinks it is not and times out.
# It is currently unclear whether:
# 1. if I used GDUnit4 correct to check for the signal
# 2. or if GDUnit4 is broken and does not handle siggnals properly yet
func test_login__emits_logged_in_signal_and_returns_LoginResult():
	# Arrange
	var pf_client = auto_free(PlayFabClient.new())
	pf_client.connect("logged_in",Callable(self,"_on_logged_in"))
	pf_client.connect("api_error",Callable(self,"_on_api_error"))

	# Add to tree so _ready() gets called on PlayFabClient
	add_child(pf_client)

	# Act
	pf_client.login_with_email(email, password, tags, combined_info_request_params)

	# wait for pf_client to emit the signal 'logged_in'
	# or 5 seconds, whichever comes first.
#	await yield_to(pf_client, 'logged_in', 5).YIELD

	# Assert
#	assert_signal_emitted(pf_client, 'logged_in', 'Maybe it did, maybe it didnt, but we still got here.')
	await assert_signal(pf_client).wait_until(5000).is_emitted("logged_in")


func _on_logged_in(login_result: LoginResult):
	assert_object(login_result.EntityToken).is_not_null()
	assert_object(login_result.InfoResultPayload).is_not_null()
	assert_float(login_result.LastLoginTime).is_not_zero()
	assert_float(login_result.LastLoginTime).is_not_null()
	assert_bool(login_result.NewlyCreated).is_false()
	assert_str(login_result.PlayFabId).is_equal("BC894B06364B0093")
	assert_str(login_result.SessionTicket).is_not_empty()
	assert_object(login_result.TreatmentAssignment).is_class("Dictionary")

#	assert_not_null(login_result.EntityToken)
#	assert_not_null(login_result.InfoResultPayload)
#	assert_ne("", login_result.LastLoginTime)
#	assert_false(login_result.NewlyCreated)
#	assert_eq("BC894B06364B0093", login_result.PlayFabId)
#	assert_ne("", login_result.SessionTicket)
#	assert_typeof(login_result.TreatmentAssignment, TYPE_DICTIONARY)


func _on_api_error(api_error_wrapper: ApiErrorWrapper):
	var text = "%s" % api_error_wrapper.errorMessage
	var error_details = api_error_wrapper.errorDetails

	if error_details:
		for key in error_details.keys():
			text += "%s: " % key
			for element in error_details[key]:
				text += "%s\n" % element
	print(text)
