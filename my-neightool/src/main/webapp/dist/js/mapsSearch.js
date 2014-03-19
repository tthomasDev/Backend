var map;

var markerInfowindow;

function initialize() {
  var mapOptions = {
    zoom: 9
  };
  map = new google.maps.Map(document.getElementById('map-canvas'),
      mapOptions);
  
  var currentUserLat = document.getElementById('lat').value;
  var currentUserLng = document.getElementById('lng').value;
  
  var pos = new google.maps.LatLng(currentUserLat,
                                   currentUserLng);

  var infowindow = new google.maps.InfoWindow({
      content: 'Vous &ecirctes ici !'
});
  
  var marker = new google.maps.Marker({
      position: pos,
      map: map,
      icon: 'http://maps.google.com/mapfiles/marker_black.png'
  });
  
  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map,marker);
  });

  map.setCenter(pos);

  extractFromSelect();
      
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
			'<tbody>'+
				'<tr>'+
					'<td style="vertical-align:middle; text-align:center;"><img src="' + imTool + '" width="70px" height="70px"/></td>'+
					'<td style="vertical-align:middle; text-align:center;"><strong><a ' + 
					'href="dashboard.jsp?page=itemDetails&id=' + idTool + '">' + nameTool + '</a></strong><br />' + 
					'<p>' + descTool + '</p></td>'+
					'<td style="vertical-align:middle; text-align:center;">' + userName + '</td>'+
					'<td style="vertical-align:middle; text-align:center;">'+ cautTool +'€</td>'+
					'<td style="vertical-align:middle; text-align:center;">' + distTool +' km</td>'+
				'</tr>'+
			'</tbody>'+
		'</table>';
		
		addMarker(loc, contentString);
	}
}

function addMarker(location, contentString)
{
	
    var marker = new google.maps.Marker({
        position: location,
        map: map,
        icon: 'http://maps.google.com/mapfiles/marker_yellow.png'
    });
    
    markerInfowindow = new google.maps.InfoWindow({
	      content: contentString
	 	});
    
    google.maps.event.addListener(marker, 'click', function() {
	    markerInfowindow.open(map,marker);
	  });
}

google.maps.event.addDomListener(window, 'load', initialize);