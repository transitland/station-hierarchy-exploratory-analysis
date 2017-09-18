## How do people tag things in OpenStreetMap?

OpenStreetMap is a collaborative, free and editable map of the world. It's an amazing resource with an incredible amount of information.

If you are working with OpenStreetMap data, you may find yourself asking questions about the OpenStreetMap community's tagging conventions. Am I using the correct tags in my query? Am I missing any tags? What other tags are people using to describe the thing that I am querying for? These sorts of questions might be relevant if you were, for example, using OpenStreetMap data to find wheelchair accessible places (see: [Wheelmap](https://wheelmap.org/en/map#/?zoom=14)), or gathering training data for a machine learning model to recognize objects from satellite imagery using OpenStreetMap labels. The question, *"How do people tag things in OpenStreetMap?"* is a meaningful one, and it provides the motivation for this notebook.

There exist a number of tools for getting and asking questions of OpenStreetMap data:

- [Overpass API](http://wiki.openstreetmap.org/wiki/Overpass_API) serves up custom selected parts of OpenStreetMap data, enabling us to ask questions about what exists in OpenStreetMap
- [Overpass Turbo](http://overpass-turbo.eu/) is an online querying tool which runs any kind of Overpass API query and displays the results on an interactive map
- [Overpass QL](http://wiki.openstreetmap.org/wiki/Overpass_API/Overpass_QL), is a query language built specifically for the Overpass API

In this notebook, we will define a few python functions to query the Overpass API programatically and convert the response to GeoJSON. We will download the locations, metadata and building footprints (if applicable) of all of the toilets in New York City, and we will ask some questions about how people tag New York City toilets in OpenStreetMap.

## Searching OpenStreetMap for toilets in NYC using Overpass Turbo

Below we use Overpass Turbo to construct a query for OpenStreetMap entities with "amenity"="toilets" in New York Cityl Overpass Turbo relies on OverPass Query Language, which can be a bit cryptic. Luckily, however, it comes with a Query Wizard tool which can help you generate queries by keyword search. From Overpass Turbo, we can view the data on an interactive map and export the data to a variety of file types, including GeoJSON, GPX and KML. 

![fig](https://i.imgur.com/hd5z2rl.jpg)

