var mysql = require('mysql2');
var config = require('config');
var port = config.get('port');
var mysqlConfig = config.get('mysql');
var io = require('socket.io').listen(port);
// Define our db creds
var db = mysql.createConnection({
    host: mysqlConfig.host,
    port: mysqlConfig.port,
    user: mysqlConfig.user,
    password: mysqlConfig.password,
    database: mysqlConfig.database
});

// Log any errors connected to the db
db.connect(function (err) {
    if (err) console.log(err)
})
console.log('app listen port ' + port);
// Define/initialize our global vars
var devices = [];
var isInitDevices = false;
var socketCount = 0
var maxIdUserRequest = 0;

io.sockets.on('connection', function (socket) {
    socketCount++
    io.sockets.emit('users connected', socketCount)

    socket.on('disconnect', function () {
        socketCount--
        io.sockets.emit('users connected', socketCount)
    })

    socket.on('new note', function (data) {
        // New note added, push to all sockets and insert into db
        notes.push(data)
        io.sockets.emit('new note', data)
        // Use node's db injection format to filter incoming data
        db.query('INSERT INTO notes (note) VALUES (?)', data.note)
    })
    if (!isInitDevices) {
        // Initial app start, run db query
        db.query('select id, lati_north, longti_east, lati_south, longti_west from devices')
            .on('result', function (data) {
                // Push results onto the notes array
                devices.push(data);
            })
            .on('end', function () {
                // Only emit notes after query has been completed
                socket.emit('initial devices', devices);
            })
        isInitDevices = true
    } else {
        // Initial notes already exist, send out
        socket.emit('initial devices', devices)
    }
    db.query('select max(id) as id from user_requests')
        .on('result', function (data) {
            // Push results onto the notes array
            if (!data.id)
                maxIdUserRequest = 0;
            else maxIdUserRequest = data.id;
        })
        .on('end', function (dt) {
            // Only emit notes after query has been completed
            socket.emit('max user_requests', maxIdUserRequest);
        })
    socket.on('max user_requests', function (data) {
        io.sockets.emit('max user_requests', maxIdUserRequest);
    })
    socket.on('new user_requests', function (data) {
        db.query(`insert into user_requests (id, bandwidth) values(?, ?)`, data.lastRequestID, data.req_bandwidth);
        io.sockets.emit('new user_requests', maxIdUserRequest++);

    })

})