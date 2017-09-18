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

Overpass Turbo is a great tool. But what if you wanted to query OpenStreetMap programmatically? The python functions below enable you to do just that.

## Querying OpenStreetMap using Python and the Overpass Turbo API

Rather than use Overpass Turbo graphical interface, we'll write a few python functions to get the data from OpenStreetMap. 

Here are three helper functions for querying OpenStreetMap data:

1. `query_OSM` writes a query to OpenStreetMap using Overpass API 
2. `overpass2geojson` converts the Overpass API JSON response to GeoJSON
3. `geojson2leaflet` creates a Leaflet map from GeoJSON using the Folium library

See the python notebook for the code behind these functions.

## Mapping toilets in New York City

Let's say we were interested in toilets in New York City. We want to know where they are and what tags people are using to describe them.

First we provide a bounding box. Overpass API expects the bounding box to be in South, West, North, East format.

`nyc_bbox = "40.543548,-74.167328,40.888082,-73.757401"`

Next, we use Overpass Turbo Query Wizard to construct an initial query, and paste the query directly into the script.

```
toilets_query = """
[out:json][timeout:500];
(
  node["amenity"="toilets"]({{bbox}});
  way["amenity"="toilets"]({{bbox}});
  relation["amenity"="toilets"]({{bbox}});
);
out body;
>;
out skel qt;
"""
```

Next, we use the `query_OSM` function to get a GeoJSON containing all of the toilets in New York City, according to OpenStreetMap.

`toilets_in_nyc = query_OSM(toilets_query, nyc_bbox)`

Finally, we use the `geojson2leaflet` function to easily create a leaflet map of the GeoJSON response from the previous step.

![fig](https://i.imgur.com/OR9hHDd.jpg)

Note that our function will retrieve polygon geometries when they are avilable.

![fig](https://i.imgur.com/ZEpiE1K.jpg)

## How are toilets in NYC tagged on OpenStreetMap?

Now that we have a dataset containing all of the locations, footprints and metadata of toilets in NYC, we can ask questions about how people tag these entities on OpenStreetMap.

![fig](https://i.imgur.com/M4NXroY.png)

We can also dig into each individual tag and see the frequencies of its corresponding values:

![fig](https://i.imgur.com/SzboCFh.png)


