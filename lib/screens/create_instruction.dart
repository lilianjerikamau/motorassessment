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
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';

import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/screens/create_instruction.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:motorassesmentapp/screens/login_screen.dart';

import 'package:motorassesmentapp/widgets/validators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:query_params/query_params.dart';

class CreateInstruction extends StatefulWidget {
  @override
  _CreateInstruction createState() => _CreateInstruction();
}

const TWO_PI = 3.14 * .6;
List<String> selectedCategory = [];

List<String> listOfCustomers = [
  'AIG INSURANCE',
  'KENYAN ALLIANCE INSURANCE',
  'AIG INSURANCE',
  'SAHAM ASSURANCE',
  "TAUSI ASSURANCE"
];
List<String> listOfBrokers = ['broker1', 'broker2'];
List<String> listOfMotorclasses = [
  'Car/ Pickup',
  'Truck',
  'Motorcycle',
  'TukTuk',
  "Bus"
];
List<String> listOftransmissiontypes = [
  'Automatic',
  'Manual',
  'Tiptronic',
];
List<String> listOfDriveType = ['2WD', '4WD', '4*2', '6*2', "6*4"];
List<String> listOfInstructiontypes = [
  'Assessement',
  'Supplementary',
  'Motor Valuation-Standard',
  'Motor Valuation-Special',
  "Reinspection"
];
List techniciansJson = [];
List customersJson = [];

List technicians = [];

class _CreateInstruction extends State<CreateInstruction> {
  late User _loggedInUser;
  int? _userid;
  int? _custid;
  int? _hrid;
  String? _username;
  String? _costcenter;
  String? loanofficerName;
  String? loanofficerEmail;
  String? loanofficerPhone;
  String? vehicleReg;
  String? chassisNo;
  String? carModel;
  String? vehicleType;
  String? vehicleColor;
  String? engineNo;
  String? custName;
  String? custPhone;
  bool _loggedIn = false;
  String? remarks;
  String? installationLocation;
  List<Customer> _customers = [];
  int? customerid;

  static late var _custName;
  // static late var _custEmail;
  static late var _custPhone;
  static late var _salesrepId = null;
  static late var _salesrepName = null;
  static late var _installationBranch = null;
  static late var noTracker = null;
  static late var _techName;
  static late var _techId;
  static late var _financierEmail;
  static late var _financierPhone;
  static late var custid;
  static late var financierid;
  static late var _financierName;
  void _toggle() {
    setState(() {
      isExistingClient = !isExistingClient;
    });
  }

  void _toggleFinancier() {
    setState(() {
      isExistingFinancier = !isExistingFinancier;
    });
  }

  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);
    _dateinput.text = formattedDate; //set the initial value of text field

    financierid = null;
    _financierName = null;
    custid = null;
    _financierEmail = null;
    _financierPhone = null;
    _custName = null;
    // _custEmail = null;
    _custPhone = null;
    _techName = null;
    _techId = null;
    // SessionPreferences().getSelectedFinancier().then((financier) {
    //   setState(() {
    //     _selectedFinancier = financier;
    //   });
    // });

    // SessionPreferences().getSelectedCustomer().then((customer) {
    //   setState(() {
    //     _selectedCustomer = customer;
    //   });
    // });
    // customerid = widget.custID;
    // _custName = widget.custName;
    // financierid = widget.custID;
    // _financierName = widget.custName;
    isBankSelected = false;
    isFinancierSelected = false;
    iscameraopen = false;
    // isExistingClient = true;
    // print(customerid);

    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        _loggedInUser = user;
        _userid = user.id;
        _hrid = user.hrid;
        _costcenter = user.branchname;
        _username = user.fullname;
      });
    });

    super.initState();
  }

  bool _searchmode = false;
  late BuildContext _context;

  // late User _loggedInUser;
  TextEditingController _itemDescController = new TextEditingController();

  String? _searchString;
  final _userNameInput = TextEditingController();
  final _passWordInput = TextEditingController();
  TextEditingController _searchController = new TextEditingController();
  final _loanofficername = TextEditingController();
  final _loanofficerphone = TextEditingController();
  final _loanofficeremail = TextEditingController();
  final _vehiclereg = TextEditingController();
  final _chassisno = TextEditingController();
  final _carmodel = TextEditingController();
  final _vehicletype = TextEditingController();
  final _vehiclecolor = TextEditingController();
  final _engineno = TextEditingController();
  final _custname = TextEditingController();
  final _custphone = TextEditingController();
  final _custEmail = TextEditingController();
  // final _financierid = TextEditingController();
  // final _customerid = TextEditingController();
  final _customertypeid = TextEditingController();
  final _notracker = TextEditingController();
  final _fuelsensor = TextEditingController();
  final _location = TextEditingController();
  final _installationdate = TextEditingController();
  final _remarks = TextEditingController();
  TextEditingController _dateinput = TextEditingController();
// User? _loggedInUser;

  // List<Technician>? technicians;
  String _message = 'Search';

  // late final custID;
  // late final custName;
  // TextEditingController _searchController = TextEditingController();
  // TextEditingController _itemDescController = new TextEditingController();

  bool _isEnable = false;
  var _selectedValue = null;
  var _selectedInstaller = null;
  var _selectedAccount = 'Selected Value';
  String? _dropdownError;
  late int? loansNumber = null;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey16 = GlobalKey<FormState>();

  bool isLoading = false;
  bool isOtherEnabled = false;
  bool isOtherEnabled2 = false;
  bool isOtherEnabled3 = false;
  bool? isBankSelected;
  bool? isFinancierSelected;
  bool? iscameraopen;
  bool isExistingClient = false;
  bool isExistingFinancier = false;
  bool isOther5 = false;
  bool isOther6 = false;
  bool isOther7 = false;
  late String otherValue6;
  late String otherValue7;

  int currentForm = 0;
  int frequencyOfTransaction = 0;
  int hasInsurance = 1;
  int hasCard = 1;
  int doYouOwnaBusiness = 1;
  int percentageComplete = 0;

  late int totalLoan;
  late String frequencyOfTransactionText;
  late String operationTime;

  late String paymentPeriodInMonths, loanTaker;
  List<String> selectedCategory = [];
  List<String> selectedCategory2 = [];
  List<String> selectedCategory3 = [];
  List<String> selectedCategory4 = [];
  List<String> selectedCategory5 = [];
  List<String> selectedCategory6 = [];
  List<String> selectedCategory7 = [];
  List<Widget> widgets = [];

  late String otherValue1;
  late String otherValue2;
  late String otherValue3;
  late String otherValue5;
  static final double containerHeight = 170.0;
  double clipHeight = containerHeight * 0.35;
  DiagonalPosition position = DiagonalPosition.BOTTOM_LEFT;
  final size = 200.0;

  @override
  Widget build(BuildContext context) {
    return isBankSelected == false && isFinancierSelected == false
        ? Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      print("the current form is $currentForm");
                      setState(() {
                        var form;
                        switch (currentForm) {
                          case 0:
                            form = _formKey.currentState;
                            if (currentForm == 0) {
                              currentForm = 0;
                              percentageComplete = 50;
                            }
                            break;
                          case 1:
                            form = _formKey16.currentState;
                            if (currentForm == 1) {
                              currentForm = 0;
                              percentageComplete = 100;
                            }
                            break;
                          case 2:
                            form = _formKey16.currentState;
                            if (currentForm == 2) {
                              currentForm = 1;
                              percentageComplete = 100;
                            }
                            break;
                        }
                      });
                    },
                    icon: Icon(
                      currentForm == 0 ? Icons.error : Icons.arrow_back,
                      color: Colors.redAccent,
                    ),
                    label: Text(currentForm == 0 ? "Invalid" : "Prev"),
                    heroTag: null,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    onPressed: () {
                      print("the current form is $currentForm");
                      setState(() {
                        var form;
                        switch (currentForm) {
                          case 0:
                            form = _formKey.currentState;
                            if (form.validate()) {
                              form.save();
                              currentForm = 2;
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Make sure all required fields are filled"),
                                duration: Duration(seconds: 3),
                              ));
                            }
                            if (form.validate()) {
                              form.save();
                              currentForm = 1;
                              percentageComplete = 25;
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Make sure all required fields are filled"),
                                duration: Duration(seconds: 3),
                              ));
                            }

                            break;

                          case 1:
                            form = _formKey16.currentState;
                            if (form.validate()) {
                              form.save();
                              currentForm = 2;
                              percentageComplete = 100;
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Make sure all required fields are filled"),
                                duration: Duration(seconds: 3),
                              ));
                            }

                            break;
                          case 2:
                        }
                      });
                    },
                    icon: Icon(currentForm == 2
                        ? Icons.upload_rounded
                        : Icons.arrow_forward),
                    label: Text(currentForm == 2 ? "finish" : "next"),
                  ),
                ),
              ],
            ),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
              leading: Builder(
                builder: (BuildContext context) {
                  return RotatedBox(
                    quarterTurns: 1,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                top: true,
                child: Column(
                  children: <Widget>[
                    Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        isLoading
                            ? const LinearProgressIndicator()
                            : const SizedBox(),
                        Diagonal(
                          position: position,
                          clipHeight: clipHeight,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                'Create Instruction',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 1.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    [
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Card(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 30, bottom: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(),
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Card(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 30),
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Select Customer",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        DropdownButtonFormField(
                                          hint: const Text(
                                            "Select Customer",
                                          ),
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            _toggleFinancier();
                                            setState(() {
                                              _selectedAccount = value!;
                                              if (_selectedAccount ==
                                                  'Selected Value') {
                                                setState(() {
                                                  // isBankSelected = false;
                                                });
                                              } else if (_selectedAccount ==
                                                  'Bank') {
                                                setState(() {
                                                  // isBankSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              _selectedAccount = value!;
                                            });
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              return null;
                                            } else {
                                              return "can't be empty";
                                            }
                                          },
                                          items:
                                              listOfCustomers.map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Instruction Type	",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        DropdownButtonFormField(
                                          hint: const Text(
                                            "Instruction Type",
                                          ),
                                          // value: _selectedAccount,
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            _toggleFinancier();
                                            setState(() {
                                              _selectedAccount = value!;
                                              if (_selectedAccount ==
                                                  'Selected Value') {
                                                setState(() {
                                                  // isBankSelected = false;
                                                });
                                              } else if (_selectedAccount ==
                                                  'Bank') {
                                                setState(() {
                                                  // isBankSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              _selectedAccount = value!;
                                            });
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              return null;
                                            } else {
                                              return "can't be empty";
                                            }
                                          },
                                          items: listOfInstructiontypes
                                              .map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Broker	",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        DropdownButtonFormField(
                                          // value: _selectedValue,
                                          hint: const Text(
                                            "Broker",
                                          ),
                                          // value: _selectedAccount,
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            _toggleFinancier();
                                            setState(() {
                                              _selectedAccount = value!;
                                              if (_selectedAccount ==
                                                  'Selected Value') {
                                                setState(() {
                                                  // isBankSelected = false;
                                                });
                                              } else if (_selectedAccount ==
                                                  'Bank') {
                                                setState(() {
                                                  // isBankSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              _selectedAccount = value!;
                                            });
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              return null;
                                            } else {
                                              return "can't be empty";
                                            }
                                          },
                                          items:
                                              listOfBrokers.map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Motor Class",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        DropdownButtonFormField(
                                          // value: _selectedValue,
                                          hint: const Text(
                                            "Motor Class",
                                          ),
                                          // value: _selectedAccount,
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            _toggleFinancier();
                                            setState(() {
                                              _selectedAccount = value!;
                                              if (_selectedAccount ==
                                                  'Selected Value') {
                                                setState(() {
                                                  // isBankSelected = false;
                                                });
                                              } else if (_selectedAccount ==
                                                  'Bank') {
                                                setState(() {
                                                  // isBankSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              _selectedAccount = value!;
                                            });
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              return null;
                                            } else {
                                              return "can't be empty";
                                            }
                                          },
                                          items: listOfMotorclasses
                                              .map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Drive Type",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        DropdownButtonFormField(
                                          // value: _selectedValue,
                                          hint: const Text(
                                            "Drive Type",
                                          ),
                                          // value: _selectedAccount,
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            _toggleFinancier();
                                            setState(() {
                                              _selectedAccount = value!;
                                              if (_selectedAccount ==
                                                  'Selected Value') {
                                                setState(() {
                                                  // isBankSelected = false;
                                                });
                                              } else if (_selectedAccount ==
                                                  'Bank') {
                                                setState(() {
                                                  // isBankSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              _selectedAccount = value!;
                                            });
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              return null;
                                            } else {
                                              return "can't be empty";
                                            }
                                          },
                                          items:
                                              listOfDriveType.map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Transmission Type",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        DropdownButtonFormField(
                                          // value: _selectedValue,
                                          hint: const Text(
                                            "Transmission Type",
                                          ),
                                          // value: _selectedAccount,
                                          isExpanded: true,
                                          onChanged: (String? value) {
                                            _toggleFinancier();
                                            setState(() {
                                              _selectedAccount = value!;
                                              if (_selectedAccount ==
                                                  'Selected Value') {
                                                setState(() {
                                                  // isBankSelected = false;
                                                });
                                              } else if (_selectedAccount ==
                                                  'Bank') {
                                                setState(() {
                                                  // isBankSelected = true;
                                                });
                                              }
                                            });
                                          },
                                          onSaved: (String? value) {
                                            setState(() {
                                              _selectedAccount = value!;
                                            });
                                          },
                                          validator: (value) {
                                            if (value != null) {
                                              return null;
                                            } else {
                                              return "can't be empty";
                                            }
                                          },
                                          items: listOftransmissiontypes
                                              .map((String val) {
                                            return DropdownMenuItem(
                                              value: val,
                                              child: Text(
                                                val,
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Description",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        TextFormField(
                                          controller: _vehiclereg,
                                          validator: (value) => value!.isEmpty
                                              ? "This field is required"
                                              : null,
                                          onSaved: (value) => {vehicleReg},
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Description"),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Transmission Speed",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            Text(
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        TextFormField(
                                          controller: _vehiclereg,
                                          validator: (value) => value!.isEmpty
                                              ? "This field is required"
                                              : null,
                                          onSaved: (value) => {vehicleReg},
                                          keyboardType: TextInputType.name,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  "Enter Vehicle Registration No"),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ])),
                      Form(
                          key: _formKey16,
                          child: Column(children: <Widget>[
                            Card(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Instruction Details",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Card(
                                margin:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 30, bottom: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Insured/Owner",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "*",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _vehiclereg,
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        onSaved: (value) => {vehicleReg},
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                            hintText: "Insured/Owner"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Insured PIN",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "*",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _carmodel,
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        onSaved: (value) => {carModel},
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                            hintText: "Insured PIN"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Address",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _chassisno,
                                        onSaved: (value) => {chassisNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Address"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Claim No",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _engineno,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Claim No"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Policy No.",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _vehiclecolor,
                                        onSaved: (value) => {vehicleColor},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Policy No."),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Chassis No*",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "*",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _location,
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        onSaved: (value) =>
                                            {installationLocation},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Chassis No*"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Cert No.",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "*",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _notracker,
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        onSaved: (value) => {noTracker},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Cert No."),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Location",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "*",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: _costcenter,
                                        onSaved: (value) => {},
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Vehicle Location"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       "Installation Branch",
                                      //       overflow: TextOverflow.ellipsis,
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .subtitle2!
                                      //           .copyWith(),
                                      //     ),
                                      //     Text(
                                      //       "*",
                                      //       style: Theme.of(context)
                                      //           .textTheme
                                      //           .subtitle2!
                                      //           .copyWith(color: Colors.red),
                                      //     )
                                      //   ],
                                      // ),
                                      // TextFormField(
                                      //   readOnly: true,
                                      //   initialValue: _costcenter,
                                      //   onSaved: (value) => {},
                                      //   keyboardType: TextInputType.number,
                                      //   decoration: const InputDecoration(
                                      //       hintText:
                                      //           "Enter Vehicle No of Trackers"),
                                      // ),
                                      // const SizedBox(
                                      //   height: 10,
                                      // ),

                                      Row(
                                        children: [
                                          Text(
                                            "Broker",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Broker"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Reg No",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Reg No"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Make",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Make"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Model",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Model"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Class of Use",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Class of Use"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Log Book No",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Log Book No"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Log Book Free of Endorsement",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Enter Log Book Free of Endorsement"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Log Book Owner",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Log Book Owner"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "No of Owners/Logbook",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "No of Owners/Logbook"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Insured Value	",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "0"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Excess",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Forced Value",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "0.0"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "Date of Loss",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextField(
                                        controller:
                                            _dateinput, //editing controller of this TextField
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.red,
                                          ), //icon of text field
                                        ),
                                        readOnly:
                                            true, //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(
                                                      2000), //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2101));

                                          if (pickedDate != null) {
                                            print(
                                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                            String formattedDate =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(pickedDate);
                                            print(
                                                formattedDate); //formatted date output using intl package =>  2021-03-16
                                            //you can implement different kind of Date Format here according to your requirement

                                            setState(() {
                                              _dateinput.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          } else {
                                            print("Date is not selected");
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Claimant(s)	",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            const InputDecoration(hintText: ""),
                                      ),
                                      SearchableDropdown(
                                        hint: const Text(
                                          "Assigned To",
                                        ),
                                        isExpanded: true,
                                        onChanged: (value) {
                                          (value) => value == null
                                              ? 'field required'
                                              : null;
                                          _selectedInstaller = value;
                                          _techId = value != null
                                              ? value['empid']
                                              : null;
                                          _techName = value != null
                                              ? value['empname']
                                              : null;
                                          setState(() {
                                            // _selectedValue = value!;
                                          });
                                          print(_selectedInstaller);
                                          print(_techName);
                                          print(_techId);
                                        },

                                        value: _selectedInstaller,

                                        // isCaseSensitiveSearch: true,
                                        searchHint: new Text(
                                          'Select Assignee ',
                                          style: new TextStyle(fontSize: 20),
                                        ),
                                        items: techniciansJson.map((val) {
                                          return DropdownMenuItem(
                                            child: Text(val['empname']),
                                            value: val,
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Instructed by",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _remarks,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Instructed by"),
                                      ),
                                      SearchableDropdown(
                                        hint: const Text(
                                          "Instruction Mode	",
                                        ),
                                        isExpanded: true,
                                        onChanged: (value) {
                                          (value) => value == null
                                              ? 'field required'
                                              : null;
                                          _selectedInstaller = value;
                                          _techId = value != null
                                              ? value['empid']
                                              : null;
                                          _techName = value != null
                                              ? value['empname']
                                              : null;
                                          setState(() {
                                            // _selectedValue = value!;
                                          });
                                          print(_selectedInstaller);
                                          print(_techName);
                                          print(_techId);
                                        },

                                        value: _selectedInstaller,

                                        // isCaseSensitiveSearch: true,
                                        searchHint: new Text(
                                          'Select Instruction Mode	 ',
                                          style: new TextStyle(fontSize: 20),
                                        ),
                                        items: techniciansJson.map((val) {
                                          return DropdownMenuItem(
                                            child: Text(val['empname']),
                                            value: val,
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Report Due Date",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          Text(
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextField(
                                        controller:
                                            _dateinput, //editing controller of this TextField
                                        decoration: const InputDecoration(
                                          icon: Icon(
                                            Icons.calendar_today,
                                            color: Colors.red,
                                          ), //icon of text field
                                        ),
                                        readOnly:
                                            true, //set it true, so that user will not able to edit text
                                        onTap: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(
                                                      2000), //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2101));

                                          if (pickedDate != null) {
                                            print(
                                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                            String formattedDate =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(pickedDate);
                                            print(
                                                formattedDate); //formatted date output using intl package =>  2021-03-16
                                            //you can implement different kind of Date Format here according to your requirement

                                            setState(() {
                                              _dateinput.text =
                                                  formattedDate; //set output date to TextField value.
                                            });
                                          } else {
                                            print("Date is not selected");
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ])),
                      Column(children: <Widget>[
                        Card(
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 30, bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            )),
                      ])
                    ][currentForm]
                  ],
                ),
              ),
            ))
        : isBankSelected == true && isFinancierSelected == false
            ? WillPopScope(
                onWillPop: () async {
                  if (_searchmode) {
                    setState(() {
                      _searchmode = false;
                      _searchString = null;
                    });
                    return false;
                  }
                  return true;
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: _searchmode
                        ? TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                hintText: 'Search financier company',
                                hintStyle: TextStyle(color: Colors.white)),
                            onChanged: (value) {
                              setState(() {
                                _searchString = value;
                              });
                            })
                        : Text('Search Financier '),
                    actions: <Widget>[
                      Visibility(
                        visible: !_searchmode,
                        child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _searchmode = true;
                              });
                            }),
                      )
                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Container(),
                  ),
                ),
              )
            : WillPopScope(
                onWillPop: () async {
                  if (_searchmode) {
                    setState(() {
                      _searchmode = false;
                      _searchString = null;
                    });
                    return false;
                  }
                  return true;
                },
                child: Scaffold(
                    appBar: AppBar(
                      title: _searchmode
                          ? TextFormField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                  hintText: 'Search financier name',
                                  hintStyle: TextStyle(color: Colors.white)),
                              onChanged: (value) {
                                setState(() {
                                  _searchString = value;
                                });
                              })
                          : const Text(
                              'Search Financier by company name,email or phone number'),
                      actions: <Widget>[
                        Visibility(
                          visible: !_searchmode,
                          child: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _searchmode = true;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    body: Container(
                      color: Colors.white,
                      child: Container(),
                    )),
              );
  }

  _fetchCustomers() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url + 'trackerjobcard/customer/?type=1&param=', Config.get);
    if (response != null) {
      print(response);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        setState(() {
          customersJson = jsonResponse;
        });
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Customer> result = list.map<Customer>((json) {
          return Customer.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          setState(() {
            result.sort((a, b) =>
                a.company!.toLowerCase().compareTo(b.company!.toLowerCase()));
            _customers = result;
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

  // late User _loggedInUser;
  // User? _loggedInUser;
  Widget getListTile(val) {
    return ListTile(
      leading: Text(val['mobile'] ?? ''),
      title: Text(val['company'] ?? ''),
      trailing: Text(val['email'] ?? ''),
    );
  }
}

void showAlertDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (BuildContext bc) {
        return CupertinoAlertDialog(
          title: Text('Error'),
          content: Text('$message'),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(bc);
                },
                child: Text('Ok'))
          ],
        );
      });
}

void _showDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CreateInstruction()));
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(
      "Success!",
      style: TextStyle(color: Colors.green),
    ),
    content: Text("You have successfully created  a Job Card"),
    actions: [
      okButton,
    ],
  );
  //   context: context,
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  //   _submit() async {
  //   showDialog(
  //       context: this.context,
  //       builder: (ctx) {
  //         return AlertDialog(
  //           title: const Text('Submit?'),
  //           content: const Text('Are you sure you want to submit'),
  //           actions: <Widget>[
  //             FlatButton(
  //                 child: const Text('No'),
  //                 onPressed: () {
  //                   Navigator.pop(ctx);
  //                 }),
  //             FlatButton(
  //                 onPressed: () async {
  //                   Navigator.pop(ctx);
  //                   log(images.toString());
  //                   String chassisno = _chasisno.text.trim();
  //                   String trackerlocation = _trackerLocation.text.trim();
  //                   String vehiclecolor = _vehcolor.text.trim();
  //                   String engineno = _engineno.text.trim();

  //                   String region = _region.text.trim();

  //                   String remarks = _remarks.text.trim();
  //                   String dateinput = _dateinput.text;
  //                   LinearProgressIndicator dial =
  //                       const LinearProgressIndicator();

  //                   String demoUrl = await Config.getBaseUrl();
  //                   Uri url = Uri.parse(demoUrl + 'tracker/');
  //                   print(url);

  //                   final response = await http.post(url,
  //                       headers: <String, String>{
  //                         'Content-Type': 'application/json',
  //                       },
  //                       body: jsonEncode(<String, dynamic>{
  //                         "instructionid": ,
  //                         "custid": ,
  //                         "insttructiontype": ,
  //                         "brokerid": ,
  //                         "transactiondate": ,
  //                         "instructiondate": ,
  //                         "departmentid": ,
  //                         "checked":,
  //                         "approved":,
  //                         "description": ,
  //                         "motorclassid":,
  //                         "transmissionspeed":,
  //                         "drivetype": ,
  //                         "transmissiontype": ,
  //                         "owner": ,
  //                         "insuredpin": ,
  //                         "address": ,
  //                         "claimno": ,
  //                         "policyno": ,
  //                         "chasisno": ,
  //                         "certno": ,
  //                         "location": ,
  //                         "broker": ,
  //                         "regno": ,
  //                         "make": ,
  //                         "model": ,
  //                         "class": ,,
  //                         "logbookno": ,,
  //                         "logbook": ,,
  //                         "logbookowner": ,,
  //                         "capacity": ,,
  //                         "noowners": ,
  //                         "insuredval": ,
  //                         "excess": ,
  //                         "forcedval": ,
  //                         "lossdate": ,
  //                         "claimant": ,
  //                         "asigneeid": ,
  //                         "secondofficer":,
  //                         "thirdofficer": ,
  //                         "fourthofficer": ,
  //                         "instructer": ,
  //                         "instructionmodeid":,
  //                         "reportduedate": ,
  //                       }));

  //                   log(jsonEncode(<String, dynamic>{
  //                     // "trackertypeid": 0,
  //                     // "trackerlocation": trackerlocation,
  //                     // "chassisno": chassisno,
  //                     // "vehiclecolor": vehiclecolor,
  //                     // "region": region,
  //                     // "jobcardid": _jobCardId,
  //                     // "imeinoid": _imeinoId != null ? _imeinoId : 0,
  //                     // "backupimeinoid": _imeinoId1 != null ? _imeinoId1 : 0,
  //                     // "backupimeino2id": _imeinoId2 != null ? _imeinoId2 : 0,
  //                     // "devicenoid": _devicenoId != null ? _devicenoId : 0,
  //                     // "backupdevicenoid":
  //                     //     _devicenoId1 != null ? _devicenoId1 : 0,
  //                     // "backupdeviceno2id":
  //                     //     _devicenoId2 != null ? _devicenoId2 : 0,
  //                     // "value1inspb1": value1inspb1,
  //                     // "value1inspb2": value1inspb2,
  //                     // "value1inspb3": value1inspb3,
  //                     // "value1inspb4": value1inspb4,
  //                     // "value1inspb5": value1inspb5,
  //                     // "value1inspb6": value1inspb6,
  //                     // "value1inspb7": value1inspb7,
  //                     // "value1inspb8": value1inspb8,
  //                     // "value1inspb9": value1inspb9,
  //                     // "value1inspb10": value1inspb10,
  //                     // "value1inspb11": value1inspb11,
  //                     // "value1inspb12": value1inspb12,
  //                     // "value1inspb13": value1inspb13,
  //                     // "value1inspb14": value1inspb14,
  //                     // "value1inspb15": value1inspb15,
  //                     // "value1inspb16": value1inspb16,
  //                     // "value1inspaf1": value1inspaf1,
  //                     // "value1inspaf2": value1inspaf2,
  //                     // "value1inspaf3": value1inspaf3,
  //                     // "value1inspaf4": value1inspaf4,
  //                     // "value1inspaf5": value1inspaf5,
  //                     // "value1inspaf6": value1inspaf6,
  //                     // "value1inspaf7": value1inspaf7,
  //                     // "value1inspaf8": value1inspaf8,
  //                     // "value1inspaf9": value1inspaf9,
  //                     // "value1inspaf10": value1inspaf10,
  //                     // "value1inspaf11": value1inspaf11,
  //                     // "value1inspaf12": value1inspaf12,
  //                     // "value1inspaf13": value1inspaf13,
  //                     // "value1inspaf14": value1inspaf14,
  //                     // "value1inspaf15": value1inspaf15,
  //                     // "value1inspaf16": value1inspaf16,
  //                     // // "trackerlocation": _location,
  //                     // "remarks": remarks,
  //                     // "userid": _userid,
  //                     "photolist": newList
  //                   }));
  //                   if (response != null) {
  //                     int statusCode = response.statusCode;
  //                     if (statusCode == 200) {
  //                       return _showDialog(this.context);
  //                     } else {
  //                       print(
  //                           "Submit Status code::" + response.body.toString());
  //                       showAlertDialog(this.context, response.body);
  //                     }
  //                   } else {
  //                     Fluttertoast.showToast(
  //                         msg: 'There was no response from the server');
  //                   }
  //                 },
  //                 child: const Text('Yes'))
  //           ],
  //         );
  //       });
  // }
}
