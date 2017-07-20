// Import Unfolding Maps
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.events.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.mapdisplay.shaders.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.utils.*;

// Import some Java utilities
import java.util.Date;
import java.text.SimpleDateFormat;

// Declare Global Variables
UnfoldingMap map;

String inputFile = "data/bay_area.csv";
//String inputFile = "data/california_morning.csv";

int totalFrames = 900;
int totalSeconds;
Table tripTable;
ArrayList<Trips> trips = new ArrayList<Trips>();
ArrayList<String> operators = new ArrayList<String>();
ArrayList<String> route_types = new ArrayList<String>();
ScreenPosition startPos;
ScreenPosition endPos;
Location startLocation;
Location endLocation;
Date minDate;
Date maxDate;
Date startDate;
Date endDate;
Date thisStartDate;
Date thisEndDate;
PImage clock; 
PImage calendar;
PImage airport;
PFont raleway;
PFont ralewayBold;

// define date format of raw data
SimpleDateFormat myDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat hour = new SimpleDateFormat("h:mm a");
SimpleDateFormat day = new SimpleDateFormat("MMMM dd, yyyy");
SimpleDateFormat weekday = new SimpleDateFormat("EEEE");

// Basemap providers
AbstractMapProvider provider1;
AbstractMapProvider provider2;
AbstractMapProvider provider3;
AbstractMapProvider provider4;
AbstractMapProvider provider5;
AbstractMapProvider provider6;
AbstractMapProvider provider7;
AbstractMapProvider provider8;
AbstractMapProvider provider9;
AbstractMapProvider provider0;
AbstractMapProvider providerq;
AbstractMapProvider providerw;
AbstractMapProvider providere;
AbstractMapProvider providerr;
AbstractMapProvider providert;
AbstractMapProvider providery;
AbstractMapProvider provideru;
AbstractMapProvider provideri;

// Set the default zoom level
int zoom;

void setup(){
  //size(1000, 860, P2D);
  fullScreen(P3D);
  
  provider1 = new OpenStreetMap.OpenStreetMapProvider();
  provider2 = new OpenStreetMap.OSMGrayProvider();
  provider3 = new EsriProvider.WorldStreetMap();
  provider4 = new EsriProvider.DeLorme();
  provider5 = new EsriProvider.WorldShadedRelief();
  provider6 = new EsriProvider.NatGeoWorldMap();
  provider7 = new EsriProvider.OceanBasemap();
  provider8 = new EsriProvider.WorldGrayCanvas();
  provider9 = new EsriProvider.WorldPhysical();
  provider0 = new EsriProvider.WorldStreetMap();
  providerq = new EsriProvider.WorldTerrain();
  providerw = new EsriProvider.WorldTopoMap();
  providere = new Google.GoogleMapProvider();
  providerr = new StamenMapProvider.TonerLite();
  providert = new CartoDB.Positron();
  providery = new StamenMapProvider.TonerBackground();
  provideru = new Microsoft.AerialProvider();
  provideri = new StamenMapProvider.TonerBackground();
  
  smooth();
  
  // Instantiate the map
  map = new UnfoldingMap(this, providert);

  // Give map interactive capabilities
  MapUtils.createDefaultEventDispatcher(this, map);
  
  // Create default location variables
  // Location nyc = new Location(40.72, -74.0);
  Location sf = new Location(37.93, -122.23);
  
  // Set the default zoom level
  int zoom = 9;
  
  // Fly to Location on the map
  map.zoomAndPanTo(zoom, sf);
  
  //
  loadData();
  
  // Fonts and icons
  raleway  = createFont("Raleway-Heavy", 32);
  ralewayBold  = createFont("Raleway-Bold", 28);
  clock = loadImage("../data/google_clock.png");
  clock.resize(0, 35);
  calendar = loadImage("../data/google_calendar.png");
  calendar.resize(0,35);
}

void loadData(){
  Table tripTable = loadTable(inputFile, "header");
  println(str(tripTable.getRowCount()) + " records loaded...");
  
  // calculate min start time and max end time (must be sorted ascending)
  String first = tripTable.getString(0, "start_time");
  String last = tripTable.getString(tripTable.getRowCount()-1, "end_time");
  
  println("Min departure time: ", first);
  println("Max departure time: ", last);
  
  try {
    minDate = myDateFormat.parse(first); //first "2017-07-17 9:59:00"
    maxDate = myDateFormat.parse(last); //last
    totalSeconds = int(maxDate.getTime()/1000) - int(minDate.getTime()/1000);
  } 
  catch (Exception e) {
    println("Unable to parse date stamp");
  }
  println("Min starttime:", minDate, ". In epoch:", minDate.getTime()/1000);
  println("Max starttime:", maxDate, ". In epoch:", maxDate.getTime()/1000);
  println("Total seconds in dataset:", totalSeconds);
  println("Total frames:", totalFrames);
  
  
  for (TableRow row : tripTable.rows()) {
    String route_type = row.getString("route_type");
    route_types.add(route_type); 
    
    int tripduration = row.getInt("duration");
    int duration = round(map(tripduration, 0, totalSeconds, 0, totalFrames));
    
    try {
      thisStartDate = myDateFormat.parse(row.getString("start_time"));
      thisEndDate = myDateFormat.parse(row.getString("end_time"));
    } catch (Exception e) {
      println("Unable to parse destination");
    }
    
    int startFrame = floor(map(thisStartDate.getTime()/1000, minDate.getTime()/1000, maxDate.getTime()/1000, 0, totalFrames));
    int endFrame = floor(map(thisEndDate.getTime()/1000, minDate.getTime()/1000, maxDate.getTime()/1000, 0, totalFrames));
    
    float startLat = row.getFloat("start_lat");
    float startLon = row.getFloat("start_lon");
    float endLat = row.getFloat("end_lat");
    float endLon = row.getFloat("end_lon");
    startLocation = new Location(startLat, startLon);
    endLocation = new Location(endLat, endLon);
    trips.add(new Trips(duration, startFrame, endFrame, startLocation, endLocation));
  }   
}

void draw(){
    
  map.draw();
  noStroke();
  fill(0,25);
  rect(0,0,width,height);
  
  // convert time to epoch
  float epoch_float = map(frameCount, 0, totalFrames, int(minDate.getTime()/1000), int(maxDate.getTime()/1000));
  int epoch = int(epoch_float);
  
  // String date = new java.text.SimpleDateFormat("MM/dd/yyyy hh:mm a").format(new java.util.Date(epoch * 1000L));
  // String date = new java.text.SimpleDateFormat("EEEE MMMM d, yyyy").format(new java.util.Date(epoch * 1000L));
  String time = new java.text.SimpleDateFormat("h:mm a").format(new java.util.Date(epoch * 1000L));
 
  // draw trips
  for (int i=0; i < trips.size(); i++) {
    Trips trip = trips.get(i);
    
    if (route_types.get(i).equals("tram")){ // Light rail
      color c = color(124,252,0);
      fill(c, 200);
      trip.plotRide();
    } else if (route_types.get(i).equals("metro")){ // Subway
      color c = color(255,0,0);
      fill(c, 200);
      trip.plotRide();
    } else if (route_types.get(i).equals("rail")){ // Rail
      color c = color(255,215,0);
      fill(c, 200);
      trip.plotRide();
    } else if (route_types.get(i).equals("bus")){ // Bus
      color c = color(0,173,253);
      fill(c, 255);
      trip.plotRide();
    } else if (route_types.get(i).equals("ferry")){ // Ferry
      color c = color(255,105,180);
      fill(c, 200);
      trip.plotRide();
    } else if (route_types.get(i).equals("cable_car")){ // Cable Car
      color c = color(238,130,238);
      fill(c, 200);
      trip.plotRide();
    } else if (route_types.get(i).equals("gondola")){ // Gondola
      color c = color(255,127,80);
      fill(c, 200);
      trip.plotRide();
    } else if (route_types.get(i).equals("funicular")){ // Funicular
      color c = color(153,50,204);
      fill(c, 200);
      trip.plotRide();
    } else { // Bus
      color c = color(0,173,253);
      fill(c, 255);
      trip.plotRide();
    }
  }

  // Time and icons
  textSize(32);
  fill(255, 255, 255, 255);
  image(clock, 30, 25);
  stroke(255, 255, 255, 255);
  line(30,70,210,70);
  image(calendar, 30, 80 );
  textFont(raleway);
  noStroke();
  text(time, 75, 55);
  textFont(ralewayBold);
  text("Weekday", 75, 110);
  
  // Legend
  fill(124,252,0, 200);
  ellipse(52, 270, 20, 20);
  fill(255, 255, 255);
  textFont(raleway, 20);
  text("Light Rail", 72, 277);

  fill(220,20,60, 200);
  ellipse(52, 310, 20, 20);
  fill(255, 255, 255);
  textFont(raleway, 20);
  text("Subway", 72, 317);
  
  fill(255,215,0, 200);
  ellipse(52, 350, 20, 20);
  fill(255, 255, 255);
  textFont(raleway, 20);
  text("Rail", 72, 357);
  
  fill(0,173,253, 200);
  ellipse(52, 390, 20, 20);
  fill(255, 255, 255, 255);
  textFont(raleway, 20);
  text("Bus", 72, 397);
  
  fill(255,105,180, 200);
  ellipse(52, 430, 20, 20);
  fill(255, 255, 255, 255);
  textFont(raleway, 20);
  text("Ferry", 72, 437);
  
  fill(238,130,238, 200);
  ellipse(52, 470, 20, 20);
  fill(255, 255, 255, 255);
  textFont(raleway, 20);
  text("Cable Car", 72, 477);
  
  fill(255,127,80, 200);
  ellipse(52, 510, 20, 20);
  fill(255, 255, 255, 255);
  textFont(raleway, 20);
  text("Gondola", 72, 517);
  
  fill(153,50,204, 225);
  ellipse(52, 550, 20, 20);
  fill(255, 255, 255, 255);
  textFont(raleway, 20);
  text("Funicular", 72, 557);
  
  boolean recording = false;
  
  if (recording == true){
    if(frameCount < totalFrames) {
      saveFrame("frames/######.png");
    }
  }
}

void keyPressed() {
    if (key == '1') {
        map.mapDisplay.setProvider(provider1);
    } else if (key == '2') {
        map.mapDisplay.setProvider(provider2);
    } else if (key == '3') {
        map.mapDisplay.setProvider(provider3);
    } else if (key == '4') {
        map.mapDisplay.setProvider(provider4);
    } else if (key == '5') {
        map.mapDisplay.setProvider(provider5);
    } else if (key == '6') {
        map.mapDisplay.setProvider(provider6);
    } else if (key == '7') {
        map.mapDisplay.setProvider(provider7);
    } else if (key == '8') {
        map.mapDisplay.setProvider(provider8);
    } else if (key == '9') {
        map.mapDisplay.setProvider(provider9);
    } else if (key == '0') {
        map.mapDisplay.setProvider(provider0);
    } else if (key == 'q') {
        map.mapDisplay.setProvider(providerq);
    } else if (key == 'w') {
        map.mapDisplay.setProvider(providerw);
    } else if (key == 'e') {
        map.mapDisplay.setProvider(providere);
    } else if (key == 'r') {
        map.mapDisplay.setProvider(providerr);
    } else if (key == 't') {
        map.mapDisplay.setProvider(providert);
    } else if (key == 'y') {
        map.mapDisplay.setProvider(providery);
    } else if (key == 'u') {
        map.mapDisplay.setProvider(provideru);
    } else if (key == 'i') {
        map.mapDisplay.setProvider(provideri);
    } 
}