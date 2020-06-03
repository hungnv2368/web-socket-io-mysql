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
var notes = []
var isInitNotes = false
var socketCount = 0

io.sockets.on('connection', function (socket) {
    // Socket has connected, increase socket count
    socketCount++
    // Let all sockets know how many are connected
    io.sockets.emit('users connected', socketCount)

    socket.on('disconnect', function () {
        // Decrease the socket count on a disconnect, emit
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

    // Check to see if initial query/notes are set
    if (!isInitNotes) {
        // Initial app start, run db query
        db.query('SELECT * FROM notes')
            .on('result', function (data) {
                // Push results onto the notes array
                notes.push(data)
            })
            .on('end', function () {
                // Only emit notes after query has been completed
                socket.emit('initial notes', notes)
            })

        isInitNotes = true
    } else {
        // Initial notes already exist, send out
        socket.emit('initial notes', notes)
    }
})