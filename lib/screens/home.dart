import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/assessmentmodels.dart';
import 'package:motorassesmentapp/models/inspectionmodels.dart';
import 'package:motorassesmentapp/models/instructionmodels.dart';
import 'package:motorassesmentapp/models/supplementarymodels.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/models/valuationmodels.dart';
import 'package:motorassesmentapp/screens/create_assesment.dart';
import 'package:motorassesmentapp/screens/create_reinspection.dart';
import 'package:motorassesmentapp/screens/create_supplementary.dart';
import 'package:motorassesmentapp/screens/create_valuationstd.dart';
import 'package:motorassesmentapp/screens/assessment_history_screen.dart';
import 'package:motorassesmentapp/screens/reinspection_history_screen.dart';
import 'package:motorassesmentapp/screens/sidemenu/side_menu.dart';
import 'package:motorassesmentapp/screens/valuation_history_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;
import 'package:geolocator/geolocator.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Timer? timer;
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  late User _loggedInUser;
  int? _userid;
  int? _custid;
  int? _custId;
  int? custId;
  int? _hrid;
  List<Assesssment> _assessments = [];
  List<Inspection> _reinspections = [];
  List<Valuation> _valuations = [];
  int? assessmentCount;
  int? inspectionCount;
  int? valuationCount;
  int? supplementaryCount;
  // List<Inspection> _assessments3 = [];
  List<Supplementary> _assessments4 = [];
  List instructionsJson = [];
  String? _policyno;
  String? _chasisno;
  String? _make;
  String? _custName;
  String? _carmodel;
  String? _location;
  String? _regno;
  String _message = 'Search';
  @override
  void initState() {
    checkGps();
    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        _loggedInUser = user;
        custId = user.custid;
        _userid = user.id;
        _hrid = user.hrid;
        print('hrid');
        print(_hrid);
      });
    });
    super.initState();
    bool isAssessmentTapped = false;
    bool isReinspectionTapped = false;
    bool isStandardValuationTapped = false;
    // bool isSpecialValuationTapped = false;
    bool isInstructionTapped = false;
    _fetchPendingassessment();
    _fetchPendinginspection();
    _fetchPendingvaluation();
    _fetchSupplementary();
    timer = Timer.periodic(Duration(minutes: 5), (Timer t) => checkGps());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }
      if (haspermission) {
        setState(() {
          //refresh the UI
        });
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }
    setState(() {
      //refresh the UI
    });
  }

  _refresh() {
    _fetchPendingassessment();
    _fetchPendinginspection();
    _fetchPendingvaluation();
    _fetchSupplementary();
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
        postLocation();
      });
    });
  }

  postLocation() async {
    String demoUrl = await Config.getBaseUrl();
    Uri url = Uri.parse(demoUrl + 'mobileuser/location/');
    print(url);

    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          "userid": _userid,
          "latitude": lat,
          "longitude": long,
        }));

    if (response != null) {
      int statusCode = response.statusCode;
      if (statusCode == 200) {
        return print('success!');
      } else {
        print("Submit Status code::" + response.body.toString());
        print(response.body);
      }
    } else {
      print('Response is null');
    }
  }

  bool isAssessmentTapped = false;
  bool isReinspectionTapped = false;
  bool isStandardValuationTapped = false;
  // bool isSpecialValuationTapped = false;
  bool isInstructionTapped = false;
  bool isAssessmentHistTapped = false;
  bool isReinspectionHistTapped = false;
  bool isStandardValuationHistTapped = false;

  @override
  Widget build(BuildContext context) {
    return isAssessmentTapped == false &&
            isInstructionTapped == false &&
            isReinspectionTapped == false &&
            isStandardValuationTapped == false
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            drawer: SideMenu(),
            appBar: AppBar(
              title: Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              leading: Builder(
                builder: (BuildContext context) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.bar_chart_rounded,
                        color: Colors.black,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      ProgressDialog dial = new ProgressDialog(context);
                      dial.style(message: 'Refreshing dashboard data');
                      dial.show();
                      _refresh();
                      ;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                      print('----------------> CALLS MADE !!!!!!!!!!!');
                      dial.hide();
                    }),
              ],
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        side: BorderSide(
                          color: Colors.blue,
                          width: 1, //<-- SEE HERE
                        ),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.all(12.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('TASKS TO DO',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Icon(
                                      Icons.notifications_active,
                                      color: Colors.blue,
                                    ),
                                  ]),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isAssessmentTapped = true;
                                    _fetchPendingassessment();
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.pending),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      assessmentCount != null
                                          ? "Assessments:$assessmentCount"
                                          : "Assessments:0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isStandardValuationTapped = true;
                                    _fetchPendingvaluation();
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.pending),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      valuationCount != null
                                          ? "Valuations:$valuationCount"
                                          : "Valuations:0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isReinspectionTapped = true;
                                    _fetchPendinginspection();
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.pending),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      inspectionCount != null
                                          ? "Reinspections:$inspectionCount"
                                          : "Reinspections:0",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            side: BorderSide(
                              color: Colors.blue,
                              width: 1, //<-- SEE HERE
                            ),
                          ),
                          elevation: 2,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateAssesment(
                                                  custID: 0,
                                                  custName: 'null',
                                                )),
                                      );
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Assessment',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            side: BorderSide(
                              color: Colors.blue,
                              width: 1, //<-- SEE HERE
                            ),
                          ),
                          elevation: 2,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateValuation(
                                                  custID: 0,
                                                  custName: 'null',
                                                )),
                                      );
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Valuation',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            side: BorderSide(
                              color: Colors.blue,
                              width: 1, //<-- SEE HERE
                            ),
                          ),
                          elevation: 2,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateReinspection(
                                                  custID: 0,
                                                  custName: 'null',
                                                )),
                                      );
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Re-Inspection',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            side: BorderSide(
                              color: Colors.blue,
                              width: 1, //<-- SEE HERE
                            ),
                          ),
                          elevation: 2,
                          margin: EdgeInsets.all(10.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateSupplementary()),
                                      );
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Supplementary',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )),
                                          Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                          ),
                                        ]),
                                  ),
                                ),
                                SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        side: BorderSide(
                          color: Colors.blue,
                          width: 1, //<-- SEE HERE
                        ),
                      ),
                      elevation: 2,
                      margin: EdgeInsets.all(12.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('HISTORY',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Icon(
                                      Icons.history,
                                      color: Colors.blue,
                                    ),
                                  ]),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AssesssmentHistoryScreen()),
                                    );
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.history),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Assessments Histoy",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ValuationHistoryScreen()),
                                    );
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.history),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Valuations History",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReinspectionHistoryScreen()),
                                    );
                                  });
                                },
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.history),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Reinspections History",
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        : isAssessmentTapped == true
            ? Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: AppBar(
                  title: Text(
                    'Assessments',
                    style: TextStyle(color: Colors.black),
                  ),
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0.0,
                ),
                body: _body())
            : isInstructionTapped == true
                ? Scaffold(
                    backgroundColor: Colors.grey[200],
                    appBar: AppBar(
                      title: Text(
                        'Supplementary',
                        style: TextStyle(color: Colors.black),
                      ),
                      leading: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0.0,
                    ),
                    body: _body4())
                : isReinspectionTapped == true
                    ? Scaffold(
                        backgroundColor: Colors.grey[200],
                        appBar: AppBar(
                          title: Text(
                            'Reinspections',
                            style: TextStyle(color: Colors.black),
                          ),
                          leading: IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            },
                          ),
                          backgroundColor: Colors.white,
                          elevation: 0.0,
                        ),
                        body: _body4())
                    : isStandardValuationTapped == true
                        ? Scaffold(
                            backgroundColor: Colors.grey[200],
                            appBar: AppBar(
                              title: Text(
                                'Valuations',
                                style: TextStyle(color: Colors.black),
                              ),
                              leading: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                              ),
                              backgroundColor: Colors.white,
                              elevation: 0.0,
                            ),
                            body: _body2())
                        : Container();
  }

  _fetchPendingassessment() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url + 'valuation/pendingassessment/?userid=$_userid', Config.get);
    if (response != null) {
      print(url + 'valuation/pendingassessment/?userid=$_userid');
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        print('assessments');
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Assesssment> result = list.map<Assesssment>((json) {
          return Assesssment.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          setState(() {
            // result.sort((a, b) =>
            //     a.regno!.toLowerCase().compareTo(b.regno!.toLowerCase()));
            result.sort((b, a) => a.id!.compareTo(b.id!));
            _assessments = result;
            assessmentCount = _assessments.length;
          });
        } else {
          setState(() {
            _message = 'You have not been assigned any customers';
          });
        }
      });
    } else {
      print('response is null');
    }
  }

  _fetchPendinginspection() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url + 'valuation/pendingpeinspection/?userid=$_userid', Config.get);
    if (response != null) {
      print(response);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        print('pendingpeinspection');
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Inspection> result = list.map<Inspection>((json) {
          return Inspection.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          setState(() {
            // result.sort((a, b) =>
            //     a.regno!.toLowerCase().compareTo(b.regno!.toLowerCase()));
            result.sort((b, a) => a.id!.compareTo(b.id!));
            _reinspections = result;
            inspectionCount = _reinspections.length;
          });
        } else {
          setState(() {
            _message = 'You have not been assigned any customers';
          });
        }
      });
    } else {
      print('response is null ');
    }
  }

  _fetchPendingvaluation() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url + 'valuation/pendingvaluation/?userid=$_userid', Config.get);
    if (response != null) {
      print(response);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        print('pendingpeinspection');
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Valuation> result = list.map<Valuation>((json) {
          return Valuation.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          setState(() {
            // result.sort((b, a) => a.instructionno!.compareTo(b.instructionno!));
            result.sort((b, a) => a.id!.compareTo(b.id!));
            _valuations = result;
            print("valuation");
            print(_valuations);
            valuationCount = _valuations.length;
          });
        } else {
          setState(() {
            _message = 'You have not been assigned any customers';
          });
        }
      });
    } else {
      print('response is null ');
    }
  }

  _fetchSupplementary() async {
    // String url = await Config.getBaseUrl();

    // HttpClientResponse response = await Config.getRequestObject(
    //     url +
    //         'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=false',
    //     Config.get);
    // if (response != null) {
    //   print(response);
    //   response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
    //     var jsonResponse = json.decode(data);
    //     setState(() {
    //       instructionsJson = jsonResponse;
    //     });
    //     print(jsonResponse);
    //     var list = jsonResponse as List;
    //     List<Supplementary> result = list.map<Supplementary>((json) {
    //       return Supplementary.fromJson(json);
    //     }).toList();
    //     if (result.isNotEmpty) {
    //       setState(() {
    //         result.sort((a, b) =>
    //             a.regno!.toLowerCase().compareTo(b.regno!.toLowerCase()));
    //         _assessments4 = result;
    //       });
    //     } else {
    //       setState(() {
    //         _message = 'You have not been assigned any customers';
    //       });
    //     }
    //   });
    // } else {
    //   print('response is null ');
    // }
  }

  _body() {
    if (_assessments != null && _assessments.isNotEmpty) {
      _assessments.forEach((assessment) {
        _make = assessment.make!;
        _regno = assessment.regno!;
        // _chasisno = assessment.chasisno!;
        _policyno = assessment.policyno!;
        _carmodel = assessment.model!;
      });
      return _listViewBuilder(_assessments);
    }
    return Center(
      child: Text('No Assessments'),
    );
  }

  _body2() {
    if (_valuations != null && _valuations.isNotEmpty) {
      _valuations.forEach((instruction) {
        _make = instruction.make!;
        // _chasisno = instruction.chasisno!;
        _carmodel = instruction.model!;
        print(_regno);
      });
      return _listViewBuilder2(_valuations);
    }
    return Center(
      child: Text('No Valuations'),
    );
  }

  // _body3() {
  //   if (_assessments != null && _assessments.isNotEmpty) {
  //     _assessments.forEach((instruction) {
  //       _make = instruction.make!;
  //       _chasisno = instruction.chassisno!;
  //       _policyno = instruction.policyno!;
  //       _regno = instruction.claimno!;
  //       _carmodel = instruction.model!;
  //     });
  //     return _listViewBuilder(_assessments3);
  //   }
  //   return Center(
  //     child: Text('No instructions'),
  //   );
  // }

  _body4() {
    if (_reinspections != null && _reinspections.isNotEmpty) {
      _reinspections.forEach((inspection) {
        print(_reinspections.length);
        // _make = inspection.make!;
        // _chasisno = inspection.chasisno!;
        // // _policyno = instruction.policyno!;
        // _regno = inspection.regno!;
        // _carmodel = inspection.model!;
      });
      return _listViewBuilder4(_reinspections);
    }
    return Center(
      child: Text('No Re-Inspections'),
    );
  }

  _listViewBuilder(List<Assesssment> data) {
    return ListView.builder(
        itemBuilder: (bc, i) {
          Assesssment instruction = data.elementAt(i);
          _make = instruction.make!;
          // _chasisno = instruction.chasisno!;
          _policyno = instruction.policyno!;
          _regno = instruction.regno!;
          _carmodel = instruction.model!;
          String? _custName = instruction.custname!;
          int? _custId = instruction.custid!;

          print("Jobcard id :::: ${instruction.custid}");
          // print(_custId);

          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue, width: 0),
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),

              // padding:  EdgeInsets.all(10.0),
              child: Container(
                child: ListTile(
                  leading: SizedBox(),
                  title: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAssesment(
                                custID: _custId, custName: _custName)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_regno!,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Row(
                        children: [
                          Text(
                            _make != null
                                ? 'Make: $_make'
                                : 'Chassis No: Chassis No',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        _policyno != null
                            ? 'Policy No: $_policyno'
                            : 'Policy No:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _carmodel != null
                            ? 'Car Model: $_carmodel'
                            : 'Car Model',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _custName != null
                            ? 'Customer Name: $_custName'
                            : 'Customer Name',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: data.length);
  }

  _listViewBuilder4(List<Inspection> data) {
    return ListView.builder(
        itemBuilder: (bc, i) {
          Inspection inspection = data.elementAt(i);
          _make = inspection.make!;
          _chasisno = inspection.chassisno!;
          _policyno = inspection.policyno!;
          _regno = inspection.regno!;
          _carmodel = inspection.model!;
          String? _custName = inspection.custname;
          int? _custId = inspection.custid;
          print("inspection make :::: ${inspection.make}");

          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue, width: 0),
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),

              // padding:  EdgeInsets.all(10.0),
              child: Container(
                child: ListTile(
                  leading: SizedBox(),
                  title: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateReinspection(
                                custID: _custId, custName: _custName)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_regno!,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Row(
                        children: [
                          Text(
                            _make != null ? 'Make: $_make' : 'Make: Make',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        _chasisno != null
                            ? 'Chassis No: $_chasisno'
                            : 'Chassis No: Chassis No',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _policyno != null
                            ? 'Policy No: $_policyno'
                            : 'Policy No:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _carmodel != null
                            ? 'Car Model: $_carmodel'
                            : 'Car Model',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _custName != null
                            ? 'Customer Name: $_custName'
                            : 'Customer Name',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: data.length);
  }

  _listViewBuilder2(List<Valuation> data) {
    return ListView.builder(
        itemBuilder: (bc, i) {
          Valuation valuation = data.elementAt(i);
          _make = valuation.make!;
          // _chasisno = instruction.chasisno!;
          _policyno = valuation.policyno!;
          _regno = valuation.regno!;
          _carmodel = valuation.model!;
          String? _custName = valuation.custname;
          int? _custId = valuation.custid;
          print("valuation make :::: ${valuation.make}");

          return Card(
            margin: EdgeInsets.all(10),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.blue, width: 0),
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 10),

              // padding:  EdgeInsets.all(10.0),
              child: Container(
                child: ListTile(
                  leading: SizedBox(),
                  title: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateValuation(
                                custID: _custId, custName: _custName)),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_regno!,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Divider(),
                      Row(
                        children: [
                          Text(
                            _make != null ? 'Make: $_make' : 'Make: Make',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                      Text(
                        _policyno != null
                            ? 'Policy No: $_policyno'
                            : 'Policy No:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _carmodel != null
                            ? 'Car Model: $_carmodel'
                            : 'Car Model',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                      Text(
                        _custName != null
                            ? 'Customer Name: $_custName'
                            : 'Customer Name',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: data.length);
  }
}
