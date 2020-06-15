var map;
var grids = [];
var centroid = null;
var frame;
var marker;
var sta = [];
var info = [];
var gsize = 0.025;
var ne_final = "";
var sw_final = "";
function placeMarker(location) {
    if (marker) {
        marker.setPosition(location);
        marker.setMap(map);
    } else {
        marker = new google.maps.Marker({
            position: location,
            map: map
        });
    }

    centroid = location;
}

function initMap() {

    centroid = new google.maps.LatLng(35.15, 126.84);

    var mapOptions = {
        center: centroid,
        zoom: 11,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    map = new google.maps.Map(document.getElementById("divMap"), mapOptions);

}
function Apply() {
    var ne = frame.getBounds().getNorthEast();
    var sw = frame.getBounds().getSouthWest();

    var h = ne.lat() - sw.lat();
    var w = ne.lng() - sw.lng();

    var mh = h % gsize; // m is modular
    var mw = w % gsize;

    var ch = 0; // count number cell by height

    if (mh >= (gsize / 2)) {
        ch = (h - mh) / gsize + 1;
    }
    else
        ch = (h - mh) / gsize;

    var hsize = h / ch;

    var cw = 0;
    if (mw >= (gsize / 2)) {
        cw = (w - mw) / gsize + 1;
    }
    else
        cw = (w - mw) / gsize;
    var wsize = w / cw;

    sta = new Array(ch * cw);
    grids = new Array(ch * cw);
    info = new Array(ch * cw);

    drawGrids(ne, sw, hsize, wsize);

    $("#btnApply").prop("disabled", true);
    $("#btnStart").prop("disabled", false);


    $("#setup").find('input, button, select').each(function () {
        $(this).prop('disabled', true);
    });
    $("#setup").css({
        'opacity': 0.7
    });
}

function showNewRect() {
    var ne = frame.getBounds().getNorthEast();
    var sw = frame.getBounds().getSouthWest();

    $("#txtLat1").val(ne.lat().toFixed(4));
    $("#txtLong1").val(ne.lng().toFixed(4));
    $("#txtLat2").val(sw.lat().toFixed(4));
    $("#txtLong2").val(sw.lng().toFixed(4));

    ne_final = ne.lat().toFixed(4) + ";" + ne.lng().toFixed(4);
    sw_final = sw.lat().toFixed(4) + ";" + sw.lng().toFixed(4);

}

function addGrid(n, s, e, w, id) {

    var rectangle = new google.maps.Rectangle({
        strokeColor: '#FF0000',
        strokeOpacity: 1,
        strokeWeight: 0.2,
        fillColor: '#FF0000',
        fillOpacity: 0.02,
        map: map,
        bounds: {
            north: n,
            south: s,
            east: e,
            west: w
        }
    });

    grids[id] = rectangle;
    cellClick(rectangle, id)
}

function drawGrids(ne, sw, hsize, wsize) {

    var count = 0;
    for (var i = sw.lat() ; i < ne.lat() ; i += hsize) {
        for (var j = sw.lng() ; j < ne.lng() ; j += wsize) {

            var s = i;
            var n = i + hsize;
            var w = j;
            var e = j + wsize;

            if (ne.lat() - s >= 0.8 * hsize && ne.lng() - w >= 0.8 * wsize) {
                addGrid(n, s, e, w, count);
                sta[count] = 0;
                info[count] = (count + 1) + ',' + parseFloat(n).toFixed(4) + ';' + parseFloat(e).toFixed(4) + ',' + parseFloat(s).toFixed(4) + ';' + parseFloat(e).toFixed(4);
                count += 1;
            }

        }
    }
    frame.setMap(null);
}

function cellClick(obj, id) {

    obj.addListener('click', function () {

        if (sta[id] == 0) {
            sta[id] = 1;

            obj.setOptions({ fillOpacity: 0.4, fillColor: '#FF0000' });
        }
        else {
            sta[id] = 0;
            obj.setOptions({ fillOpacity: 0.02, fillColor: '#FF0000' });
        }

        updateSelectedRegions();
    });
}

function processRow(row) {
    var r = row.split(",");
    var str = "Grid ID: " + r[0] + ", NE(" + r[1] + "), SW(" + r[2] + ")";
    return str;
}

function updateSelectedRegions() {
    var list = document.getElementById('listRegion');
    var data = "";
    var countSelected = 0;
    for (var i = 0; i < sta.length; i++) {
        if (sta[i] == 1) {

            var id = i;
            if (id < 9)
                id = "00" + (i + 1);
            else if (id < 99)
                id = "0" + (i + 1);
            else if (id == 99)
                id = "100";
            else
                id = id + 1;

            data += "<span id='r" + i + "'>" + processRow(info[i]) + "</span>";

            countSelected += 1;
        }
    }

    if (data.length > 0) {
        $("#btnSaveCSV").prop("disabled", false);
        $("#btnClear").prop("disabled", false);
    }
    else {
        $("#btnClear").prop("disabled", true);
        $("#btnSaveCSV").prop("disabled", true);
    }

    $("#lblTotal1").html('Number of regions: <b>' + countSelected + '</b>');

    list.innerHTML = data;
}

function getTime() {
    var str = "";

    var currentTime = new Date();
    var year = currentTime.getFullYear();
    var month = currentTime.getMonth() < 9 ? "0" + (currentTime.getMonth() + 1) : (currentTime.getMonth() + 1);
    var day = currentTime.getDate() < 10 ? "0" + currentTime.getDate() : currentTime.getDate();
    var hours = currentTime.getHours() < 10 ? "0" + currentTime.getHours() : currentTime.getHours();
    var minutes = currentTime.getMinutes() < 10 ? "0" + currentTime.getMinutes() : currentTime.getMinutes();
    var seconds = currentTime.getSeconds() < 10 ? "0" + currentTime.getSeconds() : currentTime.getSeconds();

    str += year + "" + month + "" + day + "" + hours + minutes + seconds;

    return str;
}

function exportToCsv(filename, rows) {
    var csvFile = '';

    csvFile += gsize + "," + ne_final + "," + sw_final + "\n";

    for (var i = 0; i < rows.length; i++) {
        if (sta[i] == 1)
            csvFile += rows[i] + "\n";
    }

    if (filename.trim() == "")
        filename = "selected_regions";

    filename = filename + "_" + getTime() + ".csv";

    var blob = new Blob([csvFile], { type: 'text/csv;charset=utf-8;' });
    if (navigator.msSaveBlob) { // IE 10+
        navigator.msSaveBlob(blob, filename);
    } else {
        var link = document.createElement("a");
        if (link.download !== undefined) { // feature detection
            // Browsers that support HTML5 download attribute
            var url = URL.createObjectURL(blob);
            link.setAttribute("href", url);
            link.setAttribute("download", filename);
            link.style.visibility = 'hidden';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    }
}

function Upload() {
    var fileUpload = document.getElementById("fileUpload");
    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;
    if (regex.test(fileUpload.value.toLowerCase())) {
        if (typeof (FileReader) != "undefined") {
            var reader = new FileReader();
            reader.onload = function (e) {
                var rows = e.target.result.split("\n");

                var firstRow = rows[0].split(",");
                gsize = parseFloat(firstRow[0]);
                $("#selectGridSize").val(gsize + "");

                var n = parseFloat(firstRow[1].split(";")[0]);
                var ea = parseFloat(firstRow[1].split(";")[1]);
                var s = parseFloat(firstRow[2].split(";")[0]);
                var w = parseFloat(firstRow[2].split(";")[1]);

                frame = new google.maps.Rectangle({
                    bounds: {
                        north: n,
                        south: s,
                        east: ea,
                        west: w
                    },
                    editable: true,
                    draggable: true
                });

                Apply();

                for (var i = 1; i < rows.length - 1; i++) {
                    var cells = rows[i].split(",");
                    var id = parseInt(cells[0]);
                    sta[id - 1] = 1;

                    info[id - 1] = rows[i];
                    grids[id - 1].setOptions({ fillOpacity: 0.4, fillColor: '#FF0000' });
                }

                showNewRect();

                updateSelectedRegions();
            }
            reader.readAsText(fileUpload.files[0]);
        } else {
            alert("This browser does not support HTML5.");
        }

    } else {
        alert("Please upload a valid CSV file.");
    }
}