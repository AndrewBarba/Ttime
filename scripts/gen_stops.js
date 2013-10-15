
mbta = {

	"orange" : [
		{
			"name" : "main",
			"route_ids" : [ "903_", "913_" ],
			"outbound_end" : "Forest Hills",
			"inbound_end" : "Oak Grove"
		}
	],

	"blue" : [
		{
			"name" : "main",
			"route_ids" : [ "9482", "948_", "946_", "9462" ],
			"outbound_end" : "Bowdoin",
			"inbound_end" : "Wonderland"
		}
	],

	"red" : [
		{
			"name" : "ashmont",
			"route_ids" : [ "931_" ],
			"outbound_end" : "Ashmont",
			"inbound_end" : "Alewife"
		},
		{
			"name" : "braintree",
			"route_ids" : [ "933_" ],
			"outbound_end" : "Braintree",
			"inbound_end" : "Alewife"
		}
	],

	"green" : [
		{
			"name" : "E",
			"route_ids" : [ "880_", "882_" ],
			"outbound_end" : "Heath Street",
			"inbound_end" : "Lechemere"
		},
		{
			"name" : "D",
			"route_ids" : [ "840_", "842_", "852_" ],
			"outbound_end" : "Riverside",
			"inbound_end" : "Lechemere"
		},
		{
			"name" : "C",
			"route_ids" : [ "830_", "831_" ],
			"outbound_end" : "Clevand Circle",
			"inbound_end" : "Lechemere"
		},
		{
			"name" : "B",
			"route_ids" : [ "810_", "812_", "822_" ],
			"outbound_end" : "Boston College",
			"inbound_end" : "Lechemere"
		}
	],

	"silver" : [
		{
			"name" : "SL1",
			"route_ids" : [ "741" ],
			"outbound_end" : "Logan Airport",
			"inbound_end" : "South Station"
		},
		{
			"name" : "SL2",
			"route_ids" : [ "742" ],
			"outbound_end" : "Dry Dock",
			"inbound_end" : "South Station"
		},
		{
			"name" : "SL4",
			"route_ids" : [ "751" ],
			"outbound_end" : "Dudley",
			"inbound_end" : "Essex"
		},
		{
			"name" : "SL5",
			"route_ids" : [ "749" ],
			"outbound_end" : "Dudley",
			"inbound_end" : "Temple"
		}
	]
};

function parseMBTA(callback) {
	$.each(mbta, function(line, trains){
		parseLineAndTrains(line, trains);
	});

	console.log("done!");

	console.log(JSON.stringify(mbta));

	console.log(mbta);
}

function parseLineAndTrains(line, trains) {
	$.each(trains, function(index, train){
		parseTrain(train);
	});
}

function parseTrain(train) {
	var stops_dict = {};
	$.each(train.route_ids, function(index, route_id){
		var route = getRoute(route_id);
		parseRoute(route, stops_dict);
	});
	train["stops"] = stops_dict;
}

function getRoute(route_id) {
    var url = "http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=" + route_id;
    console.log("fetching url: "+url);
    var text = $.ajax({
        type: "GET",
        url: url,
        async: false,
        contentType: "application/json"
    }).responseText;
    return JSON.parse(text);
}

function parseRoute(route, dict) {
	$.each(route.direction, function(i, dir){
		$.each(dir.stop, function(i, stop){
			dict[stop.stop_id] = stop;
		});
	});
}

parseMBTA();

