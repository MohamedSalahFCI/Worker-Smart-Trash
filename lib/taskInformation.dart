import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/location.dart';

class TaskInformation extends StatefulWidget {
  final bool del;
  final double latitude;
  final double longitude;
  final String onProg;
  final int id;
  final int trashNum;
  final String confirmedImages;
  TaskInformation(
      {this.del,
      this.latitude,
      this.longitude,
      this.onProg,
      this.id,
      this.trashNum,
      this.confirmedImages});
  @override
  _TaskInformationState createState() => _TaskInformationState();
}

class _TaskInformationState extends State<TaskInformation> {
  List splitedImages;
  String trashcanNumber;
  double lat;
  double long;
  MapView mapView = new MapView();
  CameraPosition cameraPosition;
  var staticMapProvider =
      new StaticMapProvider("AIzaSyDIcMiC8ddzMXceRVPWlEB15Rher_YHSJs");
  Uri staticMapUri;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      lat = widget.latitude;
      long = widget.longitude;
      staticMapUri = staticMapProvider.getStaticUri(new Location(lat, long), 12,
          height: 400, width: 900, mapType: StaticMapViewType.roadmap);
    });
    //cameraPosition=new CameraPosition(Location(30.56710, 32.26014), zoom)
    cameraPosition = new CameraPosition(new Location(lat, long), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(new Location(lat, long), 12,
        height: 400, width: 900, mapType: StaticMapViewType.roadmap);
    trashcanNumber = widget.trashNum.toString();
    splitedImages = widget.confirmedImages.split(",");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: new Text("Show Flutter Google maps"),
      ),
      body: ListView(
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                        child: new Image.network(staticMapUri.toString()),
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
                  "tap to map to interAct",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 25.0),
                child: new Text(
                    "camera Position : \n\nLat: ${cameraPosition.center.latitude}\n\nLng:${cameraPosition.center.longitude}\n\nZoom: ${cameraPosition.zoom}"),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.network(splitedImages[0]),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    height: 150,
                    width: 150,
                    child: Image.network(splitedImages[1]),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
