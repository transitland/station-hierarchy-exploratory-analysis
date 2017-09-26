## How do people tag transit stations on OpenStreetMap?

OpenStreetMap is a collaborative, free and editable map of the world. It's an amazing resource with an incredible amount of information contributed by millions of users.

Information about an entity on OpenStreetMap, such as its name or categorical attributes, is stored as key-value pairs called "tags". For example, a park bench may be tagged with "amenity"="bench". If you are working with OpenStreetMap data, you may find yourself asking questions about these tagging conventions. Am I using the correct tags in my query? Am I missing any tags? What other tags are people using to describe the thing that I am querying for? These sorts of questions might be relevant if you were, for example, using OpenStreetMap data to find wheelchair accessible places (see: [Wheelmap](https://wheelmap.org/en/map#/?zoom=14)), or gathering training data for a machine learning model to recognize objects from satellite imagery using OpenStreetMap labels. The question, *"How do people tag things in OpenStreetMap?"* is a meaningful one, and it provides the motivation for this notebook.

There exist a number of tools for getting and asking questions of OpenStreetMap data:

- [Overpass API](http://wiki.openstreetmap.org/wiki/Overpass_API) serves up custom selected parts of OpenStreetMap data, enabling us to ask questions about what exists on OpenStreetMap
- [Overpass Turbo](http://overpass-turbo.eu/) is an online querying tool which runs any kind of Overpass API query and displays the results on an interactive map
- [Overpass QL](http://wiki.openstreetmap.org/wiki/Overpass_API/Overpass_QL), is a query language built specifically for the Overpass API

There's even a project called [taginfo](https://taginfo.openstreetmap.org/) which collects and presents information about OpenStreetMap tags. It's an amazing resource for learning about tagging conventions across the global OSM community. But what if you want to ask questions about a particular place? Or access the raw metadata? Well, read on!

In this notebook, we will define a few python functions to:

1) Query the Overpass API programatically
2) Convert the response from Overpass API to GeoJSON
3) Plot the data on a leaflet map using the [folium](https://github.com/python-visualization/folium) library
    
We will download the locations, metadata and building footprints (if available) of all of the transit stations in New York City, and we will ask some questions about how people tag transit stations in New York City on OpenStreetMap.

## Searching OpenStreetMap for transit stations in NYC using Overpass Turbo

Below, we use Overpass Turbo to construct an initial query for transit stations on OpenStreetMap in the greater New York City area. Overpass Turbo relies on OverPass Query Language, which can be a bit cryptic. Luckily, however, it comes with a Query Wizard tool which can help you generate queries based on a keyword search. Overpass Turbo enables us to view selected data from OpenStreetMap on an interactive map and export the data to a variety of file types, including GeoJSON, GPX and KML. 

![fig](https://i.imgur.com/1pkp9Ww.jpg)

You may view this query on [Overpass Turbo](http://overpass-turbo.eu/s/rZ7).

## Programmatically querying OSM via the Overpass Turbo API

Overpass Turbo is a great tool. But what if you wanted to query OpenStreetMap programmatically and analyze the raw data? Rather than use the Overpass Turbo graphical interface, let's write a few python functions to get the data from OpenStreetMap. 

In this [jupyter notebook](https://github.com/transitland/station-hierarchy-exploratory-analysis) I define three helper functions for querying OpenStreetMap data:

1. `queryOSM` writes a query to OpenStreetMap using Overpass API and returns a JSON response
2. `overpass2geojson` converts the Overpass API JSON response to GeoJSON
3. `geojson2leaflet` creates a Leaflet map from GeoJSON using the Folium library

See the notebook for the code behind these functions.

We are interested in how people tag transit stations in New York City. We want to know where all of the transit stations are and what tags people are using to describe them. Let's use the aforementioned functions to get and explore this data.

First, we need to define the bounding box that we are interested in.

```
# Define your bounding box. Overpass expects bbox in the format: South, West, North, East
your_bbox = "40.460532,-74.308777,40.939452,-73.714142" # NYC
```

Next, we craft an initial query using the Overpass Turbo Query Wizard and paste it into a string.

```
# Our initial query as created with Overpass Turbo Query Wizard

your_query = """
[out:json][timeout:500];
// gather results
(
  // auto-generated query for “railway=station”
  node["railway"="station"]({{bbox}});
  way["railway"="station"]({{bbox}});
  relation["railway"="station"]({{bbox}});
  
  // custom piece to include "public_transport"="station, too:
  node["public_transport"="station"]({{bbox}});
  way["public_transport"="station"]({{bbox}});
  relation["public_transport"="station"]({{bbox}});
);
// print results
out body;
>;
out skel qt;
"""
```

Now, we can use the `queryOSM` function to get a GeoJSON containing locations and metadata for all of the transit stations in New York City that exist on OpenStreetMap.

```
results_geojson = queryOSM(your_query, your_bbox)
```

And finally, we use `geojson2leaflet` function to make a map of the GeoJSON response from the previous step. Clicking on any marker or polygon will bring up a popup containing all of it's OpenStreetMap tags.

```
the_map = geojson2leaflet(results_geojson, your_bbox, tiles='OpenStreetMap')
the_map.save("output/nyc_map.html")
```

**Stations in Greater NYC Area on OpenStreetMap:**

![fig](https://i.imgur.com/MGbO0Pl.jpg)
*View the interactive map [here](https://transitland.github.io/station-hierarchy-exploratory-analysis/maps/nyc_stations.html)*

You are now the proud owner of a map and a dataset containing every transit station in New York City that exists on OpenStreetMap!

## How do people tag transit stations in NYC vs. Berlin on OpenStreetMap?

Now that we have a dataset containing all of the locations, footprints and metadata of transit stations in NYC, we can ask questions about how people tag these entities on OpenStreetMap. See the jupyter note book for the code behind the following analysis.

First, let's visualize all of the keys used to describe transit stations, ranked by popularity, for New York City and Berlin.

![fig](https://i.imgur.com/26V9f3F.png)

Notice that 95% of transit stations in Berlin have a wheelchair key associated with them, versus only 72% of transit stations in New York City. Let's dive into that further to see the various values associated with the wheelchair key:

#### Wheelchair

![fig](https://i.imgur.com/bq5O6Vp.png)

Not only are Berlin's stations more thoroughly tagged with the wheelchair key, but 75% of those stations with a wheelchair key have the value "yes", indiciating unlimited wheelchair accessibility. In NYC, it is nearly the reverse. 71% of stations tagged with a wheelchair key in NYC have the value "no", indicating no wheelchair accessibility.

#### Railway

![fig](https://i.imgur.com/YMvrhcU.png)

It's interesting to note that in Berlin there is a distinction made between larger stations and "halts", which are small stations, usually unstaffed and with few or no facilities.

Here are a few more comparisons of other popular key-value pairs:

#### Network

![fig](https://i.imgur.com/wznB3VY.png)


# Mapping transit stations and bus stops with custom icons

As a reward for reading this far, here's a map of all the transit stations and bus stops in NYC on OpenStreetMap. It appears that bus stops in South Brooklyn are under-mapped.

![fig](https://i.imgur.com/gM5KEeK.jpg)
*Interactive map [here](https://transitland.github.io/station-hierarchy-exploratory-analysis/maps/nyc_stations_and_stops.html)







