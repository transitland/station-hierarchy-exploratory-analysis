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

![fig]("https://i.imgur.com/1pkp9Ww.jpg")
