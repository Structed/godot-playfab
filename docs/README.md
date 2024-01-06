# Maintainer Documentation
Read below information that is only needed by maintainers of the `godot-playfab` project - not by general users.

## Setup
In order to run integration tests, you need to set two Environment Variables for login credentials of an existing user:

* `GODOT_PLAYFAB_TEST_USER`
* `GODOT_PLAYFAB_TEST_PASSWORD`

## Using the Model Creator
The Model Creator is a simple tool to allow you to quickly create models for PlayFab based on [PlayFab's REST API documentation](https://docs.microsoft.com/en-us/rest/api/playfab/admin/?view=playfab-rest).

Open a model definition in the browser and fill in title and data according to the image below:
![Model Editor + Docs](images/model-editor-and-docs.png)

This will not always generate perfect models. Specifically Type hints are likely to not compile. Either because there was an oversight on implementing the Model Creator, or because the docs are broken or you need to create another, downstream Model.

While it is not perfect, it still saves a *ton* of time.


## Implementing a Model with an Array of Objects
Some Request models have properties, which are arrays of Objects.

<div style="color: indianred">If the elements in this array will be custom classes in Godot, serialization of them will <b><u>fail</u></b>!</div>

In order for them to correctly (de-)serialize, you need to do the following steps:

1. Create a new Class, inheriting from `AbstractJsonSerializableCollection`.

    It is important, to also add a type hint for the type of the items.
    This type hint needs to be initialized on construction (`_init()`).

    ### Example:
    Given you want to create a collection for items of type `StatisticUpdate`, this is how your class should look like:
    ````gdscript
    extends AbstractJsonSerializableCollection
    class_name EventContentsCollection

    func _init():
        _item_type = EventContents
    ````
2. Instead of an `Array`, the property should use the newly created collection class. See the `Events` property below:
    ````gdscript
    extends JsonSerializable
    class_name WriteEventsRequest

    # Collection of events to write to PlayStream.
    var Events: EventContentsCollection

    func _init():
        Events = EventContentsCollection.new()
    ````

> ⚠️ Please be advised: Failure to implement this properly will lead to issues when deserializing!

## <a name="commits"></a> Git Commit Guidelines

We have very precise rules over how our git commit messages can be formatted.  This leads to **more
readable messages** that are easy to follow when looking through the **project history**.  But also,
we use the git commit messages to **generate the AngularJS change log**.

The commit message formatting can be added using a typical git workflow or through the use of a CLI
wizard ([Commitizen](https://github.com/commitizen/cz-cli)). To use the wizard, run `yarn run commit`
in your terminal after staging your changes in git.

### Commit Message Format
Each commit message consists of a **header**, a **body** and a **footer**.  The header has a special
format that includes a **type**, a **scope** and a **subject**:

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

The **header** is mandatory and the **scope** of the header is optional.

Any line of the commit message cannot be longer than 100 characters! This allows the message to be easier
to read on GitHub as well as in various git tools.

### Revert
If the commit reverts a previous commit, it should begin with `revert: `, followed by the header
of the reverted commit.
In the body it should say: `This reverts commit <hash>.`, where the hash is the SHA of the commit
being reverted.

### Type
Must be one of the following:

* **feat**: A new feature
* **fix**: A bug fix
* **docs**: Documentation only changes
* **style**: Changes that do not affect the meaning of the code (white-space, formatting, missing
  semi-colons, etc)
* **refactor**: A code change that neither fixes a bug nor adds a feature
* **perf**: A code change that improves performance
* **test**: Adding missing or correcting existing tests
* **chore**: Changes to the build process or auxiliary tools and libraries such as documentation
  generation

### Scope
The scope could be anything specifying place of the commit change.

You can use `*` when the change affects more than a single scope.

### Subject
The subject contains succinct description of the change:

* use the imperative, present tense: "change" not "changed" nor "changes"
* don't capitalize first letter
* no dot (.) at the end

### Body
Just as in the **subject**, use the imperative, present tense: "change" not "changed" nor "changes".
The body should include the motivation for the change and contrast this with previous behavior.

### Footer
The footer should contain any information about **Breaking Changes** and is also the place to
[reference GitHub issues that this commit closes](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue).

**Breaking Changes** should start with the word `BREAKING CHANGE:` with a space or two newlines.
The rest of the commit message is then used for this.
