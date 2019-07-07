import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:a_smart_trash/login.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:a_smart_trash/profilePage.dart';
import 'package:a_smart_trash/contactUs.dart';
import 'package:a_smart_trash/allTasks.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:a_smart_trash/taskInformation.dart';
import 'package:badges/badges.dart';
import 'package:a_smart_trash/allNotification.dart';
import 'package:a_smart_trash/aboutUs.dart';
import 'globals.dart' as globals;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nameKey = "allUserData";
  String nameKey2 = "NotificationCounter";
  String data;
  Map myUsingVar;
  List _data;
  int _counter = 0;

  Future<int> loadData2() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _counter = preferences.getInt(nameKey2);
    });
    return _counter;
  }

  Future<String> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(nameKey);
  }

  Future setData() async {
    await loadData().then((value) {
      setState(() {
        data = value;
        print(data);
        myUsingVar = json.decode(data);
      });
    });
    print("ana Aho ya $myUsingVar");
  }

  Future<bool> saveData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(nameKey, null);
    print("l shared tamam w B null");
  }

  Future logoutPress() async {
    String dataBaseToken = myUsingVar["token"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dataBaseToken";
    var reqBody = {
      "token": myUsingVar["user"]["token"],
    };
    String reqBodyJson = json.encode(reqBody);
    print("befour req");
    var resp = await http.post(
        "https://smart--trash.herokuapp.com/api/v1/logout",
        body: reqBodyJson,
        headers: headers);
    print("after req");
    print(resp.statusCode);
    if (resp.statusCode == 201 || resp.statusCode == 200) {
      print("kda hwa 3mal logout 7oot b2a l shared b null");
      await saveData();
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => LoginPage()));
      Toast.show("Logout Successfully", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //Fluttertoast.showToast(msg: "Logout Successfully");
    } else {
      print("error");
      Toast.show("Error In Logout", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //Fluttertoast.showToast(msg: "Error In Logout");
    }
  }

  Future<AllTasks> getAllTasks() async {
    String dataBaseToken = myUsingVar["token"];
    var yourID = myUsingVar["user"]["id"];
    Map<String, String> headers = new Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Accept"] = "application/json";
    headers["Authorization"] = "Bearer $dataBaseToken";
    print("befour req");
    var resp = await http.get(
        "https://smart--trash.herokuapp.com/api/v1/getAllTasks?worker=" +
            "$yourID",
        headers: headers);
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      final resBody = json.decode(resp.body);
      return new AllTasks.fromJson(resBody);
    } else {
      print("error");
    }
  }

//hanshof 7att l async de
  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    setData();
    loadData2();
    this.getAllTasks();
  }

  Widget _listView(_data) => new ListView.builder(
        itemCount: _data == null ? 0 : _data.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: new Card(
              elevation: 4.0,
              color: Colors.white.withOpacity(0.9),
              child: Container(
                alignment: Alignment.center,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            new Text(
                              'ID',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            new Text(
                              _data[index].id.toString(),
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            new Text(
                              'Color',
                              style: TextStyle(fontSize: 17),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            new Text(
                              _data[index].trash["color"].toString(),
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            new Text(
                              'Company',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            new Text(
                              "FCI",
                              style: TextStyle(
                                  color: Colors.black38, fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /*
            child: new Card(
              elevation: 4.0,
              color: Colors.grey,
              child: Container(
                height: 200,
                child: Column(
                  children: <Widget>[
                    new Text(
                      _data[index].createdAt,
                      textAlign: TextAlign.center,
                    ),
                    new Text(_data[index].deleted.toString()),
                    new Text(_data[index].trash["destination"][0].toString()),
                    new Text(_data[index].trash["destination"][1].toString()),
                    new Text(_data[index].trash["status"].toString()),
                    new Text(_data[index].trash["deleted"].toString()),
                    new Text(_data[index].trash["color"].toString()),
                    new Text(_data[index].trash["number"].toString()),
                    new Text(_data[index].trash["id"].toString()),
                    //new Text("${_data.length}"),
                  ],
                ),
              ),
            ),
            */
            onTap: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new TaskInformation(
                            del: _data[index].trash["deleted"],
                            latitude: _data[index].trash["destination"][0],
                            longitude: _data[index].trash["destination"][1],
                            onProg: _data[index].trash["status"].toString(),
                            id: _data[index].trash["id"],
                            trashNum: _data[index].id,
                            confirmedImages: _data[index].confirm,
                          )));
            },
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.red,
        title: new Text(
          "Home",
          style: TextStyle(letterSpacing: 6.0),
        ),
        actions: <Widget>[
          BadgeIconButton(
              itemCount: globals.count == 0 ? _counter : globals.count,
              //itemCount: 5,
              //l loon aly haytkatb 3aleh
              badgeColor: Colors.blue,
              //aly gay dh l rakam aly gwa haytkatb b eh
              badgeTextColor: Colors.white,
              icon: Icon(
                Icons.notifications,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => AlllNotification()));
              }),
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: Text(
                myUsingVar["user"]["firstname"] +
                    " " +
                    myUsingVar["user"]["lastname"],
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(myUsingVar["user"]["email"],
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(myUsingVar["user"]["img"]),
                  //child: Icon(Icons.person,color: Colors.white,),
                ),
              ),
              decoration: new BoxDecoration(color: Colors.red),
            ),
            //body
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: ListTile(
                title: new Text("Home"),
                leading: Icon(
                  Icons.home,
                  color: Colors.blue,
                ),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => Profile()));
              },
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ContactUs(
                              firstName: myUsingVar["user"]["firstname"],
                              secondName: myUsingVar["user"]["lastname"],
                              phoneNum: myUsingVar["user"]["phone"],
                              email: myUsingVar["user"]["email"],
                              dbToken: myUsingVar["token"],
                            )));
              },
              child: ListTile(
                title: Text('Contact Us'),
                leading: Icon(Icons.shopping_basket, color: Colors.blue),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => AboutUs()));
              },
              child: ListTile(
                title: new Text("About Us"),
                leading: Icon(
                  Icons.info,
                  color: Colors.blue,
                ),
              ),
            ),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings, color: Colors.blue),
              ),
            ),
            InkWell(
              onTap: () {
                //hna mafrod n3mal l request bta3 l logout bass hanmsheha 3ady dlw2y
                logoutPress();
              },
              child: ListTile(
                title: Text('LogOut'),
                leading: Icon(Icons.help, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<AllTasks>(
        future: getAllTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return LiquidPullToRefresh(
              color: Colors.red,
              showChildOpacityTransition: false,
              child: _listView(snapshot.data.myData),
              onRefresh: () => getAllTasks(),
            );
          } else if (snapshot.hasError) {
            return new Text("${snapshot.error}");
          }
          return new Center(child: new CircularProgressIndicator());
        },
      ),
    );
  }
}
