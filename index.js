var mysql = require('mysql2');
var config = require('config');
var port = config.get('port');
var mysqlConfig = config.get('mysql');
var io = require('socket.io').listen(port);
// dinh nghia cac thong so ket noi db mysql
var db = mysql.createConnection({
    host: mysqlConfig.host,
    port: mysqlConfig.port,
    user: mysqlConfig.user,
    password: mysqlConfig.password,
    database: mysqlConfig.database
});

// connect toi db
db.connect(function (err) {
    if (err) console.log(err)
})
console.log('app listen port ' + port);
var devices = [];
var isInitDevices = false;
var socketCount = 0
var maxIdUserRequest = 0;
// khi co nguoi dung ket noi toi socket => raise event connection
io.sockets.on('connection', function (socket) {
    socketCount++;
    // gui luon ve client users connected thanh cong
    io.sockets.emit('users connected', socketCount);
    socket.on('disconnect', function () {
        socketCount--
        io.sockets.emit('users connected', socketCount)
    })
    if (!isInitDevices) {
        // Initial app start, run db query lay all devices
        db.query('select id, lati_north, longti_east, lati_south, longti_west from devices')
            .on('result', function (data) {
                // them du lieu lay duoc vao arr devices 
                devices.push(data);
            })
            .on('end', function () {
                // Lay xong het du lieu devices, gui ve client theo kenh initial devices, gia tri gui ve la devices
                io.sockets.emit('initial devices', devices);
            })
        isInitDevices = true
    } else {
        // Initial notes already exist, send out
        io.sockets.emit('initial devices', devices)
    }
    socket.on('new user_requests', function (data) {
        try {
            console.log('insert user request ' + data.req_bandwidth+' '+data.req_delay);
            // cient gui yeu cau them moi user_requests => insert vao db xong roi gui ve client theo kenh new user_requests
            db.query(`insert into user_requests (bw_mbps,delay_ms) values(${data.req_bandwidth},${data.req_delay})`)
                .on('result', function (dx) {
                    console.log('send noti new user request ' + dx.insertId);
                    io.sockets.emit('new user_requests', dx.insertId);
                })
                .on('end', function (dt) {
                    // Only emit notes after query has been completed
                })
        } catch (error) {
            console.error(error);
        }
    })
    socket.on('new regions', function (data) {
        try {
            console.log('insert regions ' + data.id);
            // cient gui yeu cau them moi/update regions => insert/update vao db xong roi gui ve client theo kenh new regions
            db.query(`insert into regions (id, lati_north, longti_east, lati_south, longti_west)
            select ${data.id},${data.lati_north},${data.longti_east},${data.lati_south},${data.longti_west}
            WHERE NOT EXISTS (Select id From regions WHERE id =${data.id}) LIMIT 1`, null, function (err, results, fields) {
                if (!err) {
                    console.log('insert xong regions ' + data.id);
                    io.sockets.emit('new regions', data);
                }
                else {
                    console.log(err);
                }
            })

        } catch (error) {
            console.error(error);
        }
    })
    socket.on('new regions_of_request', function (data) {
        try {
            console.log('insert regions_of_request ' + data.usr_request_id);
            // them moi regions_of_request
            db.query(`insert into regions_of_request (usr_request_id, region_id)
             values(${data.usr_request_id},${data.region_id})`,
                function (err, results, fields) {
                    if (!err) {
                        console.log('insert xong regions_of_request ' + data.usr_request_id);
                    }
                    else {
                        console.error(err);
                    }
                })

        } catch (error) {
            console.error(error);
        }

    })
    socket.on('update regions', function (data) {
        try {
            console.log('update regions ' + data.device_id);
            // update regions
            db.query(`update regions set device_id='${data.device_id}' where id=${data.region_id}`, null,
                function (err, results, fields) {
                    if (!err) {
                        console.log(`update xong regions ${data.device_id} - ${data.region_id}`);
                    }
                    else {
                        console.error(err);
                    }
                })


        } catch (error) {
            console.error(error);
        }

    })

})
