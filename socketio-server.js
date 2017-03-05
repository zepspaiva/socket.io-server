var express = require('express');
var app = express();
var server = require('http').createServer(app);

var io = require('socket.io')(server);
var port = process.env.PORT || 80;

io.sockets.on('connection', function (socket) {

	console.log('new socket.io connection...');

	socket.on('room', function(room) {
		socket.join(room);
	});

	socket.on('message', function(data) {
		console.log(data);
		io.sockets.in([data.signal,data.ctx].join('-')).emit('message', data);
		socket.emit ('messageSuccess', data);
	});

});

app.get('/delivery/*', function(res, path) {
	res.writeHead(302, {'Location': 'http://data.mobyfood.com.br/' + req.url});
	res.end();
});

app.use('/', express.static('/static', {
	maxage: '120h',
	setHeaders: function(res, path) {
		res.setHeader("Expires", new Date(Date.now() + 86400000*5).toUTCString());
	}
}));

console.log('Will listen on', port);

server.listen(port);
