var map;
var z = 9;
var geocoder;
var mycoordinates;
var markers = [];
var clickMarker;
var bounds;

var origin;
var destinations2 = [];
var usersNames = [];

var markerInfowindow;

var originIcon = 'http://maps.google.com/mapfiles/marker.png';
var destinationIcon = 'http://maps.google.com/mapfiles/marker_green.png';

function initialize() {
	geocoder = new google.maps.Geocoder();
	
	
	var selectUsers = document.getElementById('users');
	for(var i=0; i<selectUsers.options.length; i++)
		{
			var splittedText = selectUsers.options[i].text.split('/');
			var lat = splittedText[2];
			var lng = splittedText[1];
			var name = splittedText[0];
			
			var latlng = new google.maps.LatLng(lat, lng);
			destinations2.push(latlng);
			usersNames.push(name);
		}
	
	var mapOptions = {
		zoom : z
	};

	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			mycoordinates = position;
			var pos = new google.maps.LatLng(position.coords.latitude,
					position.coords.longitude);
			origin = pos;
			var infowindow = new google.maps.InfoWindow({
				map : map,
				position : pos,
				zoom : z,
				content : 'Vous &ecirctes ici actuellement !'
			});
			map.setCenter(pos);
			
			// Ajoute marker si clique de souris
			google.maps.event.addListener(map, 'click', function(event) {
				addClickMarker(event.latLng);
				origin = event.latLng;
				calculateDistances();
			});
			
			calculateDistances();
			
		}, function() {
			handleNoGeolocation(true);
		});
	} else {
		handleNoGeolocation(false);
	}
	


}

function calculateDistances() {
	//Si il y a des destinations alors on procède sinon non
	if (destinations2.length > 0 )
		{
		  var service = new google.maps.DistanceMatrixService();
		  service.getDistanceMatrix(
		    {
		      origins: [origin],
		      destinations: destinations2,
		      travelMode: google.maps.TravelMode.DRIVING,
		      unitSystem: google.maps.UnitSystem.METRIC,
		      avoidHighways: false,
		      avoidTolls: false
		    }, callback);
	  
		}
	}

	function callback(response, status) {
	  if (status != google.maps.DistanceMatrixStatus.OK) {
	    alert('Error was: ' + status);
	  } else {
	    var origins = response.originAddresses;
	    var destinations = response.destinationAddresses;
	    //deleteOverlays();
	    for (var i = 0; i < origins.length; i++) {
	      var results = response.rows[i].elements;
	      //addMarker(origins[i], false);
	      for (var j = 0; j < results.length; j++) {
	    	 if(results[j].distance.value < 100000)
	    		 {
	    		 	markerInfowindow = new google.maps.InfoWindow({
	    		      maxWidth: 200
	    		 	});

	    		    var contentString = 'L\'utilisateur <b>' + usersNames[j]
	    		 		+ '</b> pr&ecircte un outil &agrave <b>' + results[j].distance.text + '</b> (' + results[j].duration.text +' de route) de chez vous ! <b>Inscrivez-vous</b> pour pouvoir l\'emprunter';
	    		      
	  		 		
	    		 	addMarker(destinations[j], true, contentString);
	    		 }
	      }
	    }
	  }
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

	geocoder.geocode({
		'address' : address
	}, function(results, status) {
		if (status == google.maps.GeocoderStatus.OK) {
			map.setCenter(results[0].geometry.location);
			addClickMarker(results[0].geometry.location);

			$('#lat').val(results[0].geometry.location.lat());
			$('#long').val(results[0].geometry.location.lat());

		} else {
			alert('Geocode was not successful for the following reason: '
					+ status);
		}
	});
}

function codeLatLng(marker) {
	var long;
	var lat;

	if (marker != null) {
		lat = marker.getPosition().lat();
		lng = marker.getPosition().lng();
		// alert("coord"+lat+" "+lng);

		$('#lat').val(lat);
		$('#long').val(lng);

	} else {
		lat = parseFloat(mycoordinates.coords.latitude);
		lng = parseFloat(mycoordinates.coords.longitude);

		$('#lat').val(lat);
		$('#long').val(lng);
		// alert("coord"+lat+" "+lng);

	}

	var latlng = new google.maps.LatLng(lat, lng);
	geocoder
			.geocode(
					{
						'latLng' : latlng
					},
					function(results, status) {
						if (status == google.maps.GeocoderStatus.OK) {
							if (results[1]) {
								if (!marker) {
									addClickMarker(latlng);
								}
								document.getElementById('location').value = results[1].formatted_address;
								// infowindow.setContent(results[1].formatted_address);
								// infowindow.open(map, marker);
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
	if (clickMarker != null)
		clickMarker.setMap(map);
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
	clickMarker = null;
	markers = [];
}

// Add a marker to the map and push to the array.
function addClickMarker(location) {
	var marker = new google.maps.Marker({
		position : location,
	    animation: google.maps.Animation.DROP,
		map : map
	});

	// delete and clear markers, only one marker
	deleteMarkers();

	//Add marker
	clickMarker = marker;
	showMarkers();
}

function addMarker(location, isDestination, contentString) {
	  var icon;
	  if (isDestination) {
	    icon = destinationIcon;
	  } else {
	    icon = originIcon;
	  }
	
	  geocoder.geocode({'address': location}, function(results, status) {
	    if (status == google.maps.GeocoderStatus.OK) {
	      var marker = new google.maps.Marker({
	        map: map,
	        position: results[0].geometry.location,
	        icon: icon
	      });
	      
	      google.maps.event.addListener(marker, 'click', function() {
  		 		markerInfowindow.setContent(contentString);
	    	    markerInfowindow.open(map,marker);
	    	  });
	      
	      markers.push(marker);
	      showMarkers();
	    } else {
	      alert('Geocode was not successful for the following reason: '
	        + status);
	    }
	  });
}


function getMyMarker() {
	if (clickMarker != null) {
		codeLatLng(clickMarker);
	} else {
		alert("Vous n'avez pas mis de marqueur !")
	}
}

google.maps.event.addDomListener(window, 'load', initialize);