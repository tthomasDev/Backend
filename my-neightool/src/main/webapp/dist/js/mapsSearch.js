var map;

var markerInfowindow;

var toolMap = {}; // map contenant une liste d'outil de chaque utilisateur
var nbVar = 9; // nombre de valeur récupéré dans le select

function initialize() {
	var mapOptions = {
		zoom : 9
	};
	map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

	var currentUserLat = document.getElementById('lat').value;
	var currentUserLng = document.getElementById('lng').value;

	var pos = new google.maps.LatLng(currentUserLat, currentUserLng);

	var infowindow = new google.maps.InfoWindow({
		content : 'Vous &ecirctes ici !'
	});

	var marker = new google.maps.Marker({
		position : pos,
		map : map,
		icon : 'http://maps.google.com/mapfiles/marker_black.png'
	});

	google.maps.event.addListener(marker, 'click', function() {
		infowindow.open(map, marker);
	});

	map.setCenter(pos);

	extractFromSelect();

}

function extractFromSelect() {
	var selectUsers = document.getElementById('users');
	for (var i = 0; i < selectUsers.options.length; i++) {

		var splittedText = selectUsers.options[i].text.split('\\');
		var idTool = splittedText[0];
		var nameTool = splittedText[1];
		var descTool = splittedText[2];
		var imTool = splittedText[3];
		var cautTool = splittedText[4];
		var distTool = splittedText[5];
		var userLogin = splittedText[6];
		var userLat = splittedText[7];
		var userLng = splittedText[8];

		if (userLogin in toolMap) {
			toolMap[userLogin].push([ idTool, nameTool, descTool, imTool,
					cautTool, distTool, userLogin, userLat, userLng ]);
		} else {
			toolMap[userLogin] = new Array([ idTool, nameTool, descTool, imTool,
					cautTool, distTool, userLogin, userLat, userLng ]);
		}
	}


	var loc;

	for ( var k in toolMap) {
		if (toolMap.hasOwnProperty(k)) {
			
			var contentString = '<table>'
				+ '<thead>'
				+ '<tr>'
				+ '<th style="vertical-align:middle; text-align:center;" width="100px">Photo</th>'
				+ '<th style="vertical-align:middle; text-align:center;" width="40%">Description</th>'
				+ '<th style="vertical-align:middle; text-align:center;" width="20%">Preteur</th>'
				+ '<th style="vertical-align:middle; text-align:center;" width="10%">Caution</th>'
				+ '<th style="vertical-align:middle; text-align:center;" width="10%">Distance</th>'
				+ '</tr>' + '</thead>' + '<tbody>';
			
			
			for (var i = 0; i < toolMap[k].length; i++) {
				contentString += '<tr>'
						+ '<td style="vertical-align:middle; text-align:center;"><img src="'
						+ toolMap[k][i][3]
						+ '" width="70px" height="70px"/></td>'
						+ '<td style="vertical-align:middle; text-align:center;"><strong><a '
						+ 'href="dashboard.jsp?page=itemDetails&id='
						+ toolMap[k][i][0]
						+ '">'
						+ toolMap[k][i][1]
						+ '</a></strong><br />'
						+ '<p>'
						+ toolMap[k][i][2]
						+ '</p></td>'
						+ '<td style="vertical-align:middle; text-align:center;">'
						+ toolMap[k][i][6]
						+ '</td>'
						+ '<td style="vertical-align:middle; text-align:center;">'
						+ toolMap[k][i][4]
						+ '€</td>'
						+ '<td style="vertical-align:middle; text-align:center;">'
						+ toolMap[k][i][5] + ' km</td>' 
						+ '</tr>';
				loc = new google.maps.LatLng(toolMap[k][i][7], toolMap[k][i][8]);
			}
			contentString += '</tbody></table>';
			addMarker(loc, contentString);
		}
	}

}

function addMarker(location, contentString) {

	var marker = new google.maps.Marker({
		position : location,
		map : map,
		icon : 'http://maps.google.com/mapfiles/marker_yellow.png'
	});

	markerInfowindow = new google.maps.InfoWindow({
		content : contentString
	});

	google.maps.event.addListener(marker, 'click', function() {

 		markerInfowindow.setContent(contentString);
		markerInfowindow.open(map, marker);
	});
}

google.maps.event.addDomListener(window, 'load', initialize);