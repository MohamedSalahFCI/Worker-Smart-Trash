import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'globals.dart' as globals;

class HaveThisTask extends StatefulWidget {
  final int subjectID;
  HaveThisTask({this.subjectID});
  @override
  _HaveThisTaskState createState() => _HaveThisTaskState();
}

class _HaveThisTaskState extends State<HaveThisTask> {
  String trashcanNumber;
  double lat;
  double long;
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider =
      new StaticMapProvider("AIzaSyDIcMiC8ddzMXceRVPWlEB15Rher_YHSJs");
  Uri staticMapUri;
  bool del;

  showMap() {
    List<Marker> markers = <Marker>[
      new Marker("1", "Trashcan Number $trashcanNumber", lat, long,
          color: Colors.amber)
    ];
    mapView.show(new MapOptions(
      mapViewType: MapViewType.normal,
      initialCameraPosition: new CameraPosition(new Location(lat, long), 0.0),
      showUserLocation: true,
      title: "Trashcan Location",
    ));
    var sub = mapView.onMapReady.listen((_) {
      mapView.setMarkers(markers);
      mapView.zoomToFit(padding: 50);
    });
  }

  Map info;
  int yourNotifyId;
  Future<Map> getMessaeInfo() async {
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/trash/" + "$yourNotifyId",
        headers: headers);
    print("your status code is");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      setState(() {
        del = false;
        info = resBody;
        lat = resBody["destination"][0];
        long = resBody["destination"][1];
        trashcanNumber = resBody["number"];
      });
    } else if (resp.statusCode == 404) {
      setState(() {
        del = true;
        final resBody = json.decode(resp.body);
        info = {"error": "not found"};
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      staticMapUri = staticMapProvider.getStaticUri(new Location(lat, long), 12,
          height: 400, width: 900, mapType: StaticMapViewType.roadmap);
      yourNotifyId = widget.subjectID;
    });
    getMessaeInfo();
    //cameraPosition=new CameraPosition(Location(30.56710, 32.26014), zoom)
    cameraPosition = new CameraPosition(new Location(lat, long), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(new Location(lat, long), 12,
        height: 400, width: 900, mapType: StaticMapViewType.roadmap);
  }

  Future<bool> loadData2() async {
    globals.count = 0;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: loadData2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Colors.red,
          title: new Text("Trashcan Information"),
        ),
        body: info == null
            ? new Center(child: new CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  del
                      ? Center(
                          child: Text("This Trash Removed"),
                        )
                      : new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            new Container(
                              height: 300.0,
                              child: new Stack(
                                children: <Widget>[
                                  new Center(
                                    child: new Container(
                                      child: new Text(
                                        "Maps Shoud show Here",
                                        textAlign: TextAlign.center,
                                      ),
                                      padding: const EdgeInsets.all(20.0),
                                    ),
                                  ),
                                  new InkWell(
                                    child: new Center(
                                      child: new Image.network(
                                          staticMapUri.toString()),
                                    ),
                                    onTap: () {
                                      showMap();
                                    },
                                  )
                                ],
                              ),
                            ),
                            new Container(
                              padding: new EdgeInsets.only(top: 10.0),
                              child: new Text(
                                "tap to map to interAct and show full location",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Current Status :-",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(info["status"]),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Trash Color :-",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(info["color"]),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Trash Number :-",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(info["number"]),
                                  ],
                                ),
                              ],
                            ),
                            // Text(info["createdAt"]),
                            // Text(info["updatedAt"]),
                            // Text(info["worker"].toString()),
                          ],
                        ),
                ],
              ),
      ),
    );
  }
}
