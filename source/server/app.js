var port = process.env.PORT || 5000;
var app = require('http').createServer(handler);
var io = require('socket.io').listen(app)
    , fs = require('fs')
    , mongoose = require('mongoose')
    , Users = require('./user/users.js')
    , Matchmaking = require('./matchmaking.js')
    , Router = require('./router.js');

app.listen(port);

io.set('flash policy port', -1)

io.set('transports', [
    'websocket'
    , 'flashsocket'
    , 'htmlfile'
    , 'xhr-polling'
    , 'jsonp-polling'
]);

var users = new Users();
var matchmaking = new Matchmaking(users);
var router = new Router(users, matchmaking);

//mongoose.connect('mongodb://localhost/test');
mongoose.connect('mongodb://user:user@ds043388.mongolab.com:43388/heroku_app24962573');

var db = mongoose.connection;

db.on('error', function connectionError(err)
{
    console.log("-- db connection error: " + err);
    global.dbConnected = false;
});

db.once('open', function callback()
{
    console.log("-- db connection success:");
    global.dbConnected = true;
});

io.set('close timeout', 20);
io.set('polling duration', 11);

function handler (req, res)
{
    if (req.url == '/crossdomain.xml')
    {
        fs.readFile(__dirname + '/crossdomain.xml',
        function (err, data)
        {
            if (err)
            {
                res.writeHead(500);
                return res.end('Error loading cd.xml');
            };

            res.writeHead(200, {'Content-Type': 'text/plain'});
            res.end(data);
        });

        return;
    };

    fs.readFile(__dirname + '/index.html',
    function (err, data)
    {
        if (err)
        {
            res.writeHead(500);
            return res.end('Error loading index.html');
        };

        res.writeHead(200);
        res.end(data);
    });
};

io.sockets.on('connection', function(socket)
{

});

var connected = function(socket)
{
    socket.on('ClientMessage', router.handleMessage);

    users.addUser(socket);

    socket.on('disconnect', function()
    {
        matchmaking.removeUser(socket.id);
        users.removeUser(socket.id);
    });
};

var connection = io
    .of('/game')
    .on('connection', connected);
