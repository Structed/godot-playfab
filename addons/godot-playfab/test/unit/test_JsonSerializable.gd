extends "res://addons/gut/test.gd"

var model

func before_each():
	gut.p("ran setup", 2)
	model = JsonSerializableImpl.new()

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)


func test_implements_JsonSerializable():
	assert_is(model, JsonSerializable);


func test_to_dict_returns_dictionary():
	var dict = model.to_dict();
	assert_true(dict is Dictionary)



func generate_params__test_to_dict_returns_expected_dictionary():
	var etr = EntityTokenResponse.new()
	var ek = EntityKey.new()
	ek.Id = "asdf"
	ek.Type = EntityKey.ENTITY_TYPE_CHARACTER
	etr.Entity = ek
	etr.EntityToken = "test"
	etr.TokenExpiration = "expiration"

	# Empty
	var etr_rempty = EntityTokenResponse.new()

	return ParameterFactory.named_parameters(
		['actual', 'expected'],
		[
			[
				model.to_dict(),
				{
					"foo": "foo_value",
					"bar": "bar_value"
				}
			],
			[
				etr.to_dict(),
				{
					"Entity": {
						"Id": "asdf",
						"Type": EntityKey.ENTITY_TYPE_CHARACTER
					},
					"EntityToken": "test",
					"TokenExpiration": "expiration"
				}
			],
			[
				etr_rempty.to_dict(),
				{
					"Entity": null,
					"EntityToken": "",
					"TokenExpiration": ""
				}
			]
		]
		)


func test_to_dict_returns_expected_dictionary(p = use_parameters(generate_params__test_to_dict_returns_expected_dictionary())):
	var result = compare_deep(p.expected, p.actual)
	assert_true(result.are_equal)
