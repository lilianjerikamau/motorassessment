import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/assessmentmodels.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReinspectionHistoryScreen extends StatefulWidget {
  const ReinspectionHistoryScreen({super.key});

  @override
  State<ReinspectionHistoryScreen> createState() =>
      _ReinspectionHistoryScreenState();
}

class _ReinspectionHistoryScreenState extends State<ReinspectionHistoryScreen> {
  GlobalKey<FormState> _formkey = new GlobalKey();
  List<Assesssment> _reqHistories = [];
  Assesssment? _selectedItem;
  String _message = 'Select from date and to date and press search';
  User? _loggedInuser;
  DateFormat _dateFormat = new DateFormat('yyyy-MM-dd');
  TextEditingController _fromDate = new TextEditingController();
  TextEditingController _toDate = new TextEditingController();
  // ignore: unused_field
  BuildContext? _context;
  String? _policyno;
  String? _chasisno;
  String? _make;
  String? _custName;
  String? _carmodel;
  String? _location;
  String? _regno;
  String? _date;
  int? _userid;
  List reinspectionHistJson = [];
  String? reinspectionHistString;
  @override
  void initState() {
    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        _loggedInuser = user;
        _userid = user.id;
      });
    });
    super.initState();
  }

  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString('reinspectionlist') as String;
    List customerList = auth.split(",");
    print("customerlist");
    print(customerList);
    setState(() {
      customerList = reinspectionHistJson;
    });
  }

  Future<void> saveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('reinspectionlist', reinspectionHistString!);
    print('user info:');
    // printWrapped(assessmentHistString!);
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          title: Text('Reinspection History')),
      body: _selectedItem != null
          ? Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Card(
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
                            leading: Icon(
                              Icons.history,
                              color: Colors.blue,
                            ),
                            title: InkWell(
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date : ' + _selectedItem!.date!,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
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
                                      _selectedItem!.make != null
                                          ? 'Make: $_make'
                                          : 'Chassis No: Chassis No',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Text(
                                  _selectedItem!.policyno != null
                                      ? 'Policy No: $_policyno'
                                      : 'Policy No:',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  _selectedItem!.model != null
                                      ? 'Car Model: $_carmodel'
                                      : 'Car Model',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  _selectedItem!.custname != null
                                      ? 'Customer Name: $_custName'
                                      : 'Customer Name',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Divider(),
                                Text(
                                  _selectedItem!.regno != null
                                      ? 'Registration No: $_regno'
                                      : 'Registration No',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : Container(
              color: Colors.white,
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Form(
                    key: _formkey,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      color: Colors.white70,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: DateTimeField(
                              format: _dateFormat,
                              onShowPicker: (ctx, val) {
                                return showDatePicker(
                                    context: ctx,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now());
                              },
                              controller: _fromDate,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select From Date';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                if (value != null) {
                                  String toDate = _toDate.text;
                                  if (toDate.isNotEmpty) {
                                    DateTime tdt = _dateFormat.parse(toDate);
                                    if (value.isAfter(tdt)) {
                                      setState(() {
                                        _fromDate.clear();
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (bc) {
                                            return AlertDialog(
                                              title: Text('Wrong input'),
                                              content: Text(
                                                  'From date cannot come after to date'),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(bc);
                                                    },
                                                    child: Text('Ok'))
                                              ],
                                            );
                                          });
                                    }
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide()),
                                  labelText: 'From Date'),
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                              child: DateTimeField(
                            format: _dateFormat,
                            controller: _toDate,
                            onShowPicker: (ctx, val) {
                              return showDatePicker(
                                  context: ctx,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now());
                            },
                            onChanged: (value) {
                              if (value != null) {
                                String fromDate = _fromDate.text;
                                if (fromDate.isNotEmpty) {
                                  DateTime frdt = _dateFormat.parse(fromDate);
                                  if (frdt.isAfter(value)) {
                                    setState(() {
                                      _toDate.clear();
                                    });
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text('Wrong input'),
                                            content: Text(
                                                'From date cannot come after to Date'),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(ctx);
                                                  },
                                                  child: Text('Ok'))
                                            ],
                                          );
                                        });
                                  }
                                }
                              }
                            },
                            decoration: InputDecoration(
                                labelText: 'To Date',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide())),
                            validator: (val) {
                              if (val == null) {
                                return 'Select To Date';
                              }
                              return null;
                            },
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(child: _itemsView()),
                  _baseView()
                ],
              ),
            ),
    );
  }

  _baseView() {
    return CupertinoButton(
        color: Colors.blue,
        child: Text('Search'),
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            String fromDate = _fromDate.text;
            String toDate = _toDate.text;

            ProgressDialog _dialog = new ProgressDialog(context);
            _dialog.style(message: 'Fetching data ... ');
            _dialog.show();
            String baseUrl = await Config.getBaseUrl();
            HttpClientResponse response = await Config.getRequestObject(
                baseUrl +
                    'valuation/reinspectionhistory/$_userid?from=$fromDate&to=$toDate',
                Config.get,
                dialog: _dialog);
            if (response != null) {
              response
                  .transform(utf8.decoder)
                  .transform(LineSplitter())
                  .listen((data) {
                var jsonResponse = json.decode(data);
                setState(() {
                  reinspectionHistJson = jsonResponse;
                  reinspectionHistString = reinspectionHistJson.join(",");
                  saveUserInfo();
                });
                var list = jsonResponse as List;
                List<Assesssment> reqHistories = list
                    .map<Assesssment>((e) => Assesssment.fromJson(e))
                    .toList();
                if (reqHistories.isNotEmpty) {
                  setState(() {
                    _reqHistories = reqHistories;
                  });
                } else {
                  setState(() {
                    _message =
                        'There were no results for the date range specified';
                  });
                }
              });
            } else {
              setState(() {
                _message = 'An error occurred while processing request';
              });
            }
          }
        });
  }

  _itemsView() {
    if (_reqHistories.isNotEmpty) {
      return ListView.builder(
          itemBuilder: (ctx, i) {
            Assesssment reqHistory = _reqHistories.elementAt(i);
            String? date = reqHistory.date;
            String? regno = reqHistory.regno;
            return Card(
              elevation: 20.0,
              child: ListTile(
                leading: Icon(Icons.history_toggle_off_outlined),
                title: Text('Date of Assessment: $date'),
                subtitle: Text('Registration No: $regno'),
                // trailing: Text('Tap to view'),
                onTap: () {
                  setState(() {
                    _selectedItem = reqHistory;
                    _policyno = _selectedItem!.policyno;
                    _chasisno = _selectedItem!.chassisno;
                    _make = _selectedItem!.make;
                    _custName = _selectedItem!.custname;
                    _carmodel = _selectedItem!.model;
                    _location = _selectedItem!.location;
                    _regno = _selectedItem!.regno;
                    _date = _selectedItem!.date;
                  });
                },
              ),
            );
          },
          itemCount: _reqHistories.length);
    }
    return Center(
      child: Text(_message),
    );
  }
}
