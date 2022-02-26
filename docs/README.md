# Maintainer Documentation
Read below information that is only needed by maintainers of the `godot-playfab` project - not by general users.

## Using the Model Creator
The Model Creator is a simple tool to allow you to quickly create models for PlayFab based on [PlayFab's REST API documentation](https://docs.microsoft.com/en-us/rest/api/playfab/admin/?view=playfab-rest).

Open a model definition in the browser and fill in title and data according to the image below:
![Model Editor + Docs](images/model-editor-and-docs.png)

This will not always generate perfect models. Specifically Type hints are likely to not compile. Either because there was an oversight on implementing the Model Creator, or because the docs are broken or you need to create another, downstream Model.

While it is not perfect, it still saves a *ton* of time.
