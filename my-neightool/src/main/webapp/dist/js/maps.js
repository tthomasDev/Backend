var map;
var z = 9;
var geocoder;
var mycoordinates;
var markers = [];


function initialize() {
geocoder = new google.maps.Geocoder();
var mapOptions = {
zoom : z
};

map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

if (navigator.geolocation) {
navigator.geolocation.getCurrentPosition(
function(position) {
mycoordinates = position;
var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
var infowindow = new google.maps.InfoWindow({
map : map,
position : pos,
zoom : z,
content : 'Vous êtes ici actuellement !'
});
map.setCenter(pos);
}, function() {
handleNoGeolocation(true);
});
} else {
handleNoGeolocation(false);
}


//Ajoute marker si clique de souris
google.maps.event.addListener(map, 'click', function(event) {
addMarker(event.latLng);
});

}

function handleNoGeolocation(errorFlag) {
if (errorFlag) {
var content = 'Error: The Geolocation service failed.';
} else {
var content = 'Error: Your browser doesn\'t support geolocation.';
}

var options = {
map : map,
position : new google.maps.LatLng(60, 105),
content : content
};

var infowindow = new google.maps.InfoWindow(options);
map.setCenter(options.position);
}

function codeAddress() {
var address = document.getElementById('location').value;

geocoder.geocode( { 'address': address}, function(results, status) {
if (status == google.maps.GeocoderStatus.OK) {
map.setCenter(results[0].geometry.location);	
addMarker(results[0].geometry.location);


$('#lat').val(results[0].geometry.location.lat());
$('#long').val(results[0].geometry.location.lat());


} else {
alert('Geocode was not successful for the following reason: ' + status);
}
});
}

function codeLatLng(marker) {
var long;
var lat;

if(marker)
{
lat = markers[0].getPosition().lat();
lng = markers[0].getPosition().lng();
//alert("coord"+lat+" "+lng);

$('#lat').val(lat);
$('#long').val(lng);

}
else
{
lat = parseFloat(mycoordinates.coords.latitude);
lng = parseFloat(mycoordinates.coords.longitude);

$('#lat').val(lat);
$('#long').val(lng);
//alert("coord"+lat+" "+lng);

}

var latlng = new google.maps.LatLng(lat, lng);
geocoder.geocode({'latLng': latlng}, function(results, status) {
if (status == google.maps.GeocoderStatus.OK) {
if (results[1]) {
if(!marker)
{
addMarker(latlng);
}
document.getElementById('location').value=results[1].formatted_address;
//infowindow.setContent(results[1].formatted_address);
//infowindow.open(map, marker);
} else {
alert('No results found');
}
} else {
alert('Geocoder failed due to: ' + status);
}
});
}

// Sets the map on all markers in the array.
function setAllMap(map) {
for (var i = 0; i < markers.length; i++) {
markers[i].setMap(map);
}
}

// Removes the markers from the map, but keeps them in the array.
function clearMarkers() {
setAllMap(null);
}

// Shows any markers currently in the array.
function showMarkers() {
setAllMap(map);
}

// Deletes all markers in the array by removing references to them.
function deleteMarkers() {
clearMarkers();
markers = [];
}

// Add a marker to the map and push to the array.
function addMarker(location) {
var marker = new google.maps.Marker({
position: location,
map: map
});

//delete and clear markers, only one marker
deleteMarkers();

//Add marker
markers.push(marker);
showMarkers();
}


function getMyMarker() {
if(markers[0])
{
codeLatLng(markers[0]);
}
else
{
alert("Vous n'avez pas mis de marqueur !")
}
}


google.maps.event.addDomListener(window, 'load', initialize);