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
                io.sockets.emit('initial devices', devices);
            })
        isInitDevices = true
    } else {
        // Initial notes already exist, send out
        io.sockets.emit('initial devices', devices)
    }

    socket.on('max user_requests', function (data) {
        console.log('get max user request');
        db.query('select max(id) as id from user_requests')
            .on('result', function (data) {
                // Push results onto the notes array
                if (!data.id)
                    maxIdUserRequest = 0;
                else maxIdUserRequest = data.id;
                console.log('lay duoc max user request: ' + maxIdUserRequest);
            })
            .on('end', function (dt) {
                // Only emit notes after query has been completed
                io.sockets.emit('max user_requests', maxIdUserRequest);
                console.log('send noti max user request ' + maxIdUserRequest);
            })
    })
    socket.on('new user_requests', function (data) {
        try {
            console.log('insert user request ' + data.lastRequestID);
            db.query(`insert into user_requests (id, bandwidth) values(${data.lastRequestID},${data.req_bandwidth})`)
                .on('result', function (dx) {
                    console.log('insert xong user request');
                })
                .on('end', function (dt) {
                    // Only emit notes after query has been completed
                    io.sockets.emit('new user_requests', data.lastRequestID);
                    console.log('send noti new user request ' + data.lastRequestID);
                })

        } catch (error) {
            console.error(error);
        }

    })
    socket.on('new regions', function (data) {
        try {
            console.log('insert regions' + data.id);
            db.query(`insert into regions (id, lati_north, longti_east, lati_south, longti_west)
             values(${data.id},${data.lati_north},${data.longti_east},${data.lati_south},${data.longti_west})`)
                .on('result', function (dx) {
                    console.log('insert xong regions');
                })
                .on('end', function (dt) {
                    //console.log('send noti new region ' + data.id);
                })

        } catch (error) {
            console.error(error);
        }
    })
    socket.on('new regions_of_request', function (data) {
        try {
            console.log('insert regions_of_request ' + data.usr_request_id);
            db.query(`insert into regions_of_request (usr_request_id, region_id)
             values(${data.usr_request_id},${data.region_id})`, function name(a, b, c) {
                var dd = 2;
            })
                .on('result', function (dx) {
                    console.log('insert xong regions_of_request');
                })
                .on('end', function (dt) {
                    //console.log('send noti new region ' + data.id);
                })

        } catch (error) {
            console.error(error);
        }

    })
    socket.on('update regions', function (data) {
        try {
            console.log('update regions' + data.device_id);
            db.query(`update regions set device_id=${data.device_id} where id=${data.region_id}`)
                .on('result', function (dx) {
                    console.log('update xong regions');
                })
                .on('end', function (dt) {
                })

        } catch (error) {
            console.error(error);
        }

    })

})