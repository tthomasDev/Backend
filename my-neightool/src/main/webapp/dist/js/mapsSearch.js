var map;

function initialize() {
  var mapOptions = {
    zoom: 9
  };
  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);

  if(navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var pos = new google.maps.LatLng(position.coords.latitude,
                                       position.coords.longitude);

      var infowindow = new google.maps.InfoWindow({
        map: map,
        position: pos,
        content: 'Vous &ecirctes ici actuellement !'
      });
      
      var marker = new google.maps.Marker({
          position: pos,
          map: map,
          icon: 'http://maps.google.com/mapfiles/marker_black.png',
          title: 'Hello World!'
      });

      map.setCenter(pos);

      extractFromSelect();
      
    }, function() {
      handleNoGeolocation(true);
    });
  } else {
    // Browser doesn't support Geolocation
    handleNoGeolocation(false);
  }
}


function extractFromSelect()
{
    var selectUsers = document.getElementById('users');
	for (var i = 0; i < selectUsers.options.length; i++) {

		var splittedText = selectUsers.options[i].text.split('\\');
		var idTool = splittedText[0];
		var nameTool = splittedText[1];
		var descTool = splittedText[2];
		var imTool = splittedText[3];
		var cautTool = splittedText[4];
		var distTool = splittedText[5];
		var userName = splittedText[6];
		var userLat = splittedText[7];
		var userLng = splittedText[8];
		
		var loc = new google.maps.LatLng(userLat,userLng);
		
		var contentString = '<table>'+
		'<thead>'+
			'<tr>'+
				'<th style="vertical-align:middle; text-align:center;" width="100px">Photo</th>'+
				'<th style="vertical-align:middle; text-align:center;" width="40%">Description</th>'+
				'<th style="vertical-align:middle; text-align:center;" width="20%">Preteur</th>'+
				'<th style="vertical-align:middle; text-align:center;" width="10%">Caution</th>'+
				'<th style="vertical-align:middle; text-align:center;" width="10%">Distance</th>'+
			'</tr>'+
		'</thead>'+
			'<tr>'+
				'<td style="vertical-align:middle; text-align:center;"><img src="' + imTool + '" width="70px" height="70px"/></td>'+
				'<td style="vertical-align:middle; text-align:center;"><strong><a ' + 
				'href="dashboard.jsp?page=itemDetails&id=' + idTool + '">' + nameTool + '</a></strong><br />' + 
				'<p>' + descTool + '</p></td>'+
				'<td style="vertical-align:middle; text-align:center;">' + userName + '</td>'+
				'<td style="vertical-align:middle; text-align:center;">'+ cautTool +'€</td>'+
				'<td style="vertical-align:middle; text-align:center;">' + distTool +' km</td>'+
			'</tr>'+
		'</table>';
		
		//var contentString = '<table><tr><td>1.1</td><td>1.2</td></tr><tr><td>2.1</td><td>2.2</td></tr></table>'
		
		addMarker(loc, contentString);
	}
}

function addMarker(location, contentString)
{
	var infowindow = new google.maps.InfoWindow({
	      content: contentString
	  });
	
    var marker = new google.maps.Marker({
        position: location,
        map: map,
        icon: 'http://maps.google.com/mapfiles/marker_yellow.png'
    });
    
    google.maps.event.addListener(marker, 'click', function() {
	    infowindow.open(map,marker);
	  });
}

function handleNoGeolocation(errorFlag) {
  if (errorFlag) {
    var content = 'Error: The Geolocation service failed.';
  } else {
    var content = 'Error: Your browser doesn\'t support geolocation.';
  }

  var options = {
    map: map,
    position: new google.maps.LatLng(60, 105),
    content: content
  };

  var infowindow = new google.maps.InfoWindow(options);
  map.setCenter(options.position);
}

google.maps.event.addDomListener(window, 'load', initialize);