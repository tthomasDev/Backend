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
	
	var mapOptions = {
		zoom : z
	};

	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	if (navigator.geolocation) {
		navigator.geolocation.getCurrentPosition(function(position) {
			mycoordinates = position;
			var pos = new google.maps.LatLng(position.coords.latitude,
					position.coords.longitude);
			
			var infowindow = new google.maps.InfoWindow({
				map : map,
				position : pos,
				zoom : z,
				content : 'Vous &ecirctes ici actuellement !'
			});
			map.setCenter(pos);
			
			var selectUsers = document.getElementById('users');

			
			for (var i = 0; i < selectUsers.options.length; i++) {
				var splittedText = selectUsers.options[i].text.split('\\');
				var idTool = splittedText[0];
				var nameTool = splittedText[1];
				var descTool = splittedText[2];
				var imTool = splittedText[3];
				var userName = splittedText[4];
				var userLat = splittedText[5];
				var userLng = splittedText[6];
				
				alert('im ' + imTool);

    		    var contentString = 'L\'utilisateur <b>' + userName
    		 		+ '</b> pr&ecircte un outil &agrave <b>' + descTool + '</b> (' + nameTool +' de route) de chez vous ! <b>Inscrivez-vous</b> pour pouvoir l\'emprunter';
    		      
  		 		var loc = new google.maps.LatLng(userLat,userLng);
    		 	addMarker(loc, true, contentString);
			}
			
			//Ajoute marker si clique de souris
			google.maps.event.addListener(map, 'click', function(event) {
				google.maps.event.trigger(map, 'resize');
			});
			
		}, function() {
			handleNoGeolocation(true);
		});
	} else {
		handleNoGeolocation(false);
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