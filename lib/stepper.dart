import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import "package:simple_permissions/simple_permissions.dart";
import 'package:toast/toast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:a_smart_trash/home.dart';
import 'globals.dart' as globals;

class MyStepper extends StatefulWidget {
  final String dbToken;
  final int theID;
  MyStepper({this.dbToken, this.theID});
  @override
  _MyStepperState createState() => _MyStepperState();
}

class _MyStepperState extends State<MyStepper> {
  int _currentStep = 0;
  String _reader = '';
  Permission permission = Permission.Camera;
  File _image1;
  File _image2;
  String theToken;
  int notificationID;
  Future getFirstImg(bool isCam) async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image1 = img;
    });
  }

  Future getsecondtImg(bool isCam) async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image2 = img;
    });
  }

  Future finishTask() async {
    Toast.show("Please wait a second", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    String fileName1 = _image1.path.split("/").last;
    String fileName2 = _image2.path.split("/").last;
    final _dio = new Dio();
    _dio.options.headers = {'Authorization': 'Bearer $theToken'};
    // _dio.options.contentType =
    //     ContentType.parse("application/x-www-form-urlencoded");
    FormData formData = new FormData.from({
      "confirm": [
        new UploadFileInfo(_image1, fileName1),
        new UploadFileInfo(_image2, fileName2)
      ]
    });

    Response resp = await _dio.put(
        "https://smart--trash.herokuapp.com/api/v1/trash/" +
            "$notificationID" +
            "/empty",
        data: formData);
    print("your status code is ");
    print(resp.statusCode);
    if (resp.statusCode == 201 ||
        resp.statusCode == 200 ||
        resp.statusCode == 204) {
      Toast.show("Task Finish Complete", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      print("Error");
      Toast.show("Something wrong second", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      theToken = widget.dbToken.toString();
      notificationID = widget.theID;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Add Task",
          style: TextStyle(letterSpacing: 6.0),
        ),
        backgroundColor: Colors.red,
      ),
      body: Stepper(
        type: StepperType.vertical,
        steps: _mySteps(),
        currentStep: this._currentStep,
        onStepContinue: () {
          if (_currentStep == 0) {
            if (_reader == '') {
              //hna hanshta8al bel toast Akiid
              print("B Null Ya kpeer mesh haynf3");
              Toast.show("You Must Read QR Firts", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              setState(() {
                this._currentStep = this._currentStep + 1;
              });
            }
          } else if (_currentStep == 1) {
            if (_image1 == null || _image2 == null) {
              print("l pics");
              Toast.show("You must Take 2 pics of trashcan", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else {
              globals.count = 0;
              finishTask();
            }
          }
        },
        onStepCancel: () {
          setState(() {
            if (this._currentStep > 0) {
              this._currentStep = this._currentStep - 1;
            } else {
              this._currentStep = 0;
            }
          });
        },
        /*
        onStepContinue: () {
          if (_currentStep == 0) {
            if (s1.text.length < 5) {
              print("Asghar ya negm");
            } else {
              this._currentStep = this._currentStep + 1;
            }
          }
        },
        */
        /*
        //hna ha3mal dh lw 3ayz ashta8al 3alehom 3aady y3ny atna2al benhom bass dh mesh 3ayzo ana 3ayz step by step
        onStepTapped: (step) {
          setState(() {
            this._currentStep = step;
          });
        },
        */
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: new Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Material(
      //       borderRadius: BorderRadius.circular(20.0),
      //       color: Colors.red.withOpacity(1.0),
      //       elevation: 0.0,
      //       child: MaterialButton(
      //         onPressed: () {
      //           if (_image1 != null && _image2 != null) {
      //             finishTask();
      //           } else {
      //             Toast.show("You must Take 2 pics of trashcan", context,
      //                 duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //           }
      //         },
      //         minWidth: MediaQuery.of(context).size.width,
      //         child: Text(
      //           "confirm Now",
      //           textAlign: TextAlign.center,
      //           style: TextStyle(
      //               color: Colors.white,
      //               fontWeight: FontWeight.bold,
      //               fontSize: 20.0),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text("QR Reading"),
        //subtitle: Text("QR Reading"),
        content: Column(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
            new Text(
              '$_reader',
              softWrap: true,
              style: new TextStyle(fontSize: 30.0, color: Colors.blue),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.red.withOpacity(1.0),
                elevation: 0.0,
                child: MaterialButton(
                  onPressed: () {
                    scan();
                  },
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Scan QR Now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text("Pick Images"),
        //subtitle: Text("type 2"),
        content: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                _image1 == null
                    ? Container()
                    : Image.file(
                        _image1,
                        height: 150.0,
                        width: 130.0,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red.withOpacity(1.0),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        getFirstImg(true);
                      },
                      minWidth: 100,
                      child: Text(
                        "pick 1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(
                //     Icons.camera_alt,
                //     color: Colors.red,
                //   ),
                //   onPressed: () {
                //     getFirstImg(true);
                //   },
                // ),
              ],
            ),
            Column(
              children: <Widget>[
                _image2 == null
                    ? Container()
                    : Image.file(
                        _image1,
                        height: 150.0,
                        width: 130.0,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.red.withOpacity(1.0),
                    elevation: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        getsecondtImg(true);
                      },
                      minWidth: 100,
                      child: Text(
                        "pick 2",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(
                //     Icons.camera_alt,
                //     color: Colors.red,
                //   ),
                //   onPressed: () {
                //     getsecondtImg(true);
                //   },
                // ),
              ],
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      // Step(
      //   title: Text("Confirm "),
      //   //subtitle: Text("type 3"),
      //   content: Column(
      //     children: <Widget>[
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Material(
      //           borderRadius: BorderRadius.circular(20.0),
      //           color: Colors.red.withOpacity(1.0),
      //           elevation: 0.0,
      //           child: MaterialButton(
      //             onPressed: () {
      //               finishTask();
      //             },
      //             minWidth: MediaQuery.of(context).size.width,
      //             child: Text(
      //               "confirm Now",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 20.0),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      //   isActive: _currentStep >= 2,
      // )
    ];
    return _steps;
  }

  requestPermission() async {
    bool result =
        (await SimplePermissions.requestPermission(permission)) as bool;
    setState(
      () => new SnackBar(
            backgroundColor: Colors.red,
            content: new Text(" $result"),
          ),
    );
  }

  scan() async {
    try {
      String reader = await BarcodeScanner.scan();

      if (!mounted) {
        return;
      }

      setState(() => this._reader = reader);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        requestPermission();
      } else {
        setState(() => _reader = "unknown exception $e");
      }
    } on FormatException {
      setState(() => _reader =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => _reader = 'Unknown error: $e');
    }
  }
}
