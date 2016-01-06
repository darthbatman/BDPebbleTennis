var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var sendgrid = require('sendgrid')('darthbatman', '*********');

var slices = 0;
var topspin = 0;
var forehand = 0;
var backhand = 0;
var emails = [];

app.get('/', function(req, res){
  res.send("<h1>PebbleTennis</h1>");
});


app.get('/coordinates', function(req, res){
  console.log(req.url);
});

app.get("/startgame", function(req, res){
  slices = 0;
  topspin = 0;
  forehand = 0;
  backhand = 0;
  res.send("START GAME");
  console.log("start");
});

app.get("/endgame", function(req, res){
  console.log("endgame");
  var gameReport = "Slices = "  + slices + "\n" + "Topspin = " + topspin + "\n" + "Forehand = " + forehand + "\n" + "Backhand = " + backhand + "\n";
  sendgrid.send({
  to:       emails,
  from:     'pebble@tennis.com',
  subject:  'Your game report',
  text:     gameReport
}, function(err, json) {
  if (err) { return console.error(err); }
  console.log(json);
});
res.send(gameReport);
});

app.post('/set', function(req, res){

  emails = [];

  var body = ""; // request body

  req.on('data', function(data) {
      body += data.toString(); // convert data to string and append it to request body
  });

  req.on('end', function() {
      console.log(JSON.parse(body)); // request is finished receiving data, parse it

      var theObj = JSON.parse(body);
      emails.push(theObj.me);
      emails.push(theObj.coach);
      console.log(emails);

  });

});

app.get("/forehand", function(req, res){
  forehand++;
  res.send("FOREHAND " + forehand);
  console.log("forehand");
});

app.get("/backhand", function(req, res){
backhand++;
res.send("BACKHAND");
console.log("backhand");
});

app.get('/slice', function(req, res){
//  console.log("SLICE");
res.send("SLICE");
slices++;
});

app.get('/topspin', function(req, res){
  console.log("TOPSPIN");
  topspin++;
  res.send("TOPSPIN");
});

io.on('connection', function(socket){

  socket.on("hello", function(){

console.log("hello");

  });

  console.log("connected")

  app.post('/coordinates', function(req, res){

    var body = ""; // request body

  	req.on('data', function(data) {
  	    body += data.toString(); // convert data to string and append it to request body
  	});

  	req.on('end', function() {
  	    console.log(JSON.parse(body)); // request is finished receiving data, parse it

        var theObj = JSON.parse(body);

        console.log("x = " + theObj.x);
        console.log("y = " + theObj.y);
        console.log("z = " + theObj.z);

        io.emit("display data", theObj.x, theObj.y, theObj.z);
    });

  });

});

http.listen(8080, function(){
  console.log("Listening on *:8080");
});
