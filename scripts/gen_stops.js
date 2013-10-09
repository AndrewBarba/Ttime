
var data = {};

var keys = [ "orange", "red", "blue", "green" ];

var mbta = {

	"orange" : [
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=913_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=903_",
	],

	"red" : [
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=931_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=933_",
	],

	"blue" : [
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=9482",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=948_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=946_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=9462",
	],

	"green" : [
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=810_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=812_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=822_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=830_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=831_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=840_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=842_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=852_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=880_",
		"http://realtime.mbta.com/developer/api/v1/stopsbyroute?api_key=MQMcpRbPNkusVWUGofSMIA&route=882_",
	]
};

function parseMBTA(callback) {
	if (keys.length) {
		console.log("parsing...");
		var key = keys.pop();
		var line = mbta[key];
		console.log("parsing line: "+key);
		parseLine(line, key, function(){
			parseMBTA(callback);
		});
	} else {
		console.log("done!");
		if (callback) callback();
	}
}

function parseLine(line, key, callback) {	
	if (line.length) {
		var url = line.pop();
		console.log("parsing url: "+url);
		$.getJSON(url, function(route){
			console.log("parsing route...");
			parseRoute(route, key);
			parseLine(line, key, callback);
		});
	} else {
		if (callback) callback();
	}
}

function parseRoute(route, line) {
	$.each(route.direction, function(i, dir){
		$.each(dir.stop, function(i, stop){
			addStop(stop, line);
		});
	});
}

function addStop(stop, line) {
	if (!data[line]) {
		data[line] = {};
	}
	data[line][stop.parent_station] = stop;
}

parseMBTA(function(){
	console.log(data);
	console.log(JSON.stringify(data));
});

