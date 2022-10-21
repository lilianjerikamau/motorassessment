import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/imagesmodels.dart';
import 'package:motorassesmentapp/models/instructionmodels.dart';
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
import 'package:camera/camera.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:io' as Io;
import 'package:photo_view/photo_view.dart';

class CreateAssesment extends StatefulWidget {
  const CreateAssesment({Key? key}) : super(key: key);

  @override
  State<CreateAssesment> createState() => _CreateAssesmentState();
}

class _CreateAssesmentState extends State<CreateAssesment> {
  User? _loggedInUser;

  int? _userid;
  int? _custid;
  int? _custId;
  int? custId;
  int? _hrid;
  int? _instructionId;
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
  Images? images;
  List<Map<String, dynamic>>? newImagesList;
  List<Images>? newList = [];
  List<Images>? newimages = [];
  int? customerid;
  String? _policyno;
  String? _chasisno;
  String? _make;
  String? _carmodel;
  String? _location;
  String? _claimno;
  int? _insuredvalue;
  String? _excess;
  String? _owner;
  String? _vehiclereg;

  List<Customer> _customers = [];
  List<Instruction> _instruction = [];
  List instructionsJson = [];
  static late var _custName;

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

  void _addImage(XFile image) {
    setState(() {
      imageslist!.add(image);
    });
  }

  void _addImages(Images images) {
    setState(() {
      newList!.add(images);
      print(newList);
      uploadmultipleimage();
    });
  }

  void _addDescription(String description) {
    setState(() {
      filenames!.add(description);
    });
  }

  List<XFile>? imageslist = [];
  List<String>? filenames = [];
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image; //for captured image

  @override
  void initState() {
    _fetchCustomers();
    _instructionId = 2;
    loadCamera();

    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        _loggedInUser = user;
        custId = user.custid;
        _userid = user.id;
        _hrid = user.hrid;
        print('userid');
        print(_hrid);
      });
    });
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);
    _dateinput.text = formattedDate; //set the initial value of text field
    isBankSelected = false;
    isFinancierSelected = false;
    iscameraopen = false;

    super.initState();
  }

  bool _searchmode = false;
  late BuildContext _context;

  // late User _loggedInUser;

  String? _searchString;
  final _drivenby = TextEditingController();
  // final _make = TextEditingController();
  TextEditingController _searchController = new TextEditingController();
  final _year = TextEditingController();
  final _color = TextEditingController();
  final _itemDescController = TextEditingController();
  final _loanofficeremail = TextEditingController();
  // final _vehiclereg = TextEditingController();
  final _chassisno = TextEditingController();
  // final _carmodel = TextEditingController();
  final _mileage = TextEditingController();
  final _engineno = TextEditingController();
  // final _chasisno = TextEditingController();
  final _pav = TextEditingController();
  final _salvage = TextEditingController();
  final _brakes = TextEditingController();
  // final _financierid = TextEditingController();
  // final _customerid = TextEditingController();
  final _steering = TextEditingController();
  final _RHF = TextEditingController();
  final _LHR = TextEditingController();
  final _LHF = TextEditingController();
  final _RHR = TextEditingController();
  final _paintwork = TextEditingController();
  final _spare = TextEditingController();
  final _damagesobserved = TextEditingController();
  // final _deliveredby = TextEditingController();
  // final _owner = TextEditingController();
  // final _claimno = TextEditingController();
  // final _policyno = TextEditingController();
  // final _location = TextEditingController();
  // final _insuredvalue = TextEditingController();
  // final _excess = TextEditingController();

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
  final _formKey17 = GlobalKey<FormState>();
  final _formKey18 = GlobalKey<FormState>();
  bool isLoading = false;
  bool revised = false;
  bool revised2 = false;
  bool revised3 = false;
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
  String? filename;
  late String otherValue1;
  late String otherValue2;
  late String otherValue3;
  late String otherValue5;
  static final double containerHeight = 170.0;
  double clipHeight = containerHeight * 0.35;
  DiagonalPosition position = DiagonalPosition.BOTTOM_LEFT;
  final size = 200.0;
  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras![0], ResolutionPreset.max);
      //cameras[0] = first camera, change to 1 to another camera

      controller!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      print("NO any camera found");
    }
  }

  Future uploadmultipleimage() async {
    for (int i = 0; i < newList!.length; i++) {
      print(newList![i].filename);
      newImagesList = newList!.map((e) {
        return {"filename": e.filename, "attachment": e.attachment};
      }).toList();
      print(newImagesList);
    }
    // _submit();
  }

  _submit() async {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Submit?'),
            content: const Text('Are you sure you want to submit'),
            actions: <Widget>[
              FlatButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  }),
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);
                    dial.show();
                    dial.style(
                      message: 'Sending Assessment',
                    );

                    // String chassisno = _chasisno.text.trim();
                    // String make = _make.text.trim();
                    String vehiclecolor = _color.text.trim();
                    String engineno = _engineno.text.trim();

                    // String model = _carmodel.text.trim();
                    String year = _year.text.trim();
                    String dateinput = _dateinput.text;
                    String pav = _pav.text.trim();
                    String salvage = _salvage.text.trim();
                    String brakes = _brakes.text.trim();
                    String paintwork = _paintwork.text.trim();
                    String mileage = _mileage.text.trim();
                    String steering = _steering.text.trim();

                    String RHF = _RHF.text.trim();
                    String LHR = _LHR.text;
                    String RHR = _RHR.text;
                    String LHF = _LHF.text.trim();
                    String spare = _spare.text.trim();
                    String damagesobserved = _damagesobserved.text.trim();

                    String demoUrl = await Config.getBaseUrl();
                    Uri url = Uri.parse(demoUrl + 'valuation/assessment/');
                    print(url);

                    final response = await http.post(url,
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode(<String, dynamic>{
                          "userid": _userid,
                          "custid": _custId,
                          "revised": revised,
                          "cashinlieu": revised2,
                          "instructionno": _instructionId,
                          "driven": isOther5,
                          "drivenby": "null",
                          "towed": isOther6,
                          "make": _make,
                          "model": _carmodel,
                          "year": year,
                          "mileage": mileage,
                          "color": vehiclecolor,
                          "engineno": engineno,
                          "chasisno": _chasisno,
                          "pav": pav != "" ? pav : 1,
                          "salvage": salvage != "" ? salvage : "0",
                          "brakes": brakes,
                          "paintwork": paintwork,
                          "steering": steering,
                          "RHF": RHF,
                          "LHR": LHR,
                          "RHR": RHR,
                          "LHF": LHF,
                          "Spare": spare,
                          "damagesobserved": damagesobserved,
                          "photolist": newImagesList,
                        }));

                    printWrapped(jsonEncode(<String, dynamic>{
                      // "userid": _userid,
                      // "custid": _custId,
                      // "revised": isOther7,
                      // "cashinlieu": revised2,
                      // "instructionno": 1,
                      // "driven": isOther5,
                      // "drivenby": drivenby,
                      // "towed": isOther6,
                      // "make": _make,
                      // "model": _carmodel,
                      // "year": year,
                      // "mileage": mileage,
                      // "color": vehiclecolor,
                      // "engineno": engineno,
                      // "chasisno": _chasisno,
                      // "pav": pav,
                      // "salvage": salvage,
                      // "brakes": brakes,
                      // "paintwork": paintwork,
                      // "steering": steering,
                      // "RHF": RHF,
                      // "LHR": LHR,
                      // "RHR": RHR,
                      // "LHF": LHF,
                      // "Spare": spare,
                      // "damagesobserved": damagesobserved,
                      "photolist": newImagesList,
                      // "photolist": newList,
                    }));
                    if (response != null) {
                      dial.hide();
                      int statusCode = response.statusCode;
                      if (statusCode == 200) {
                        return _showDialog(this.context);
                      } else {
                        print(
                            "Submit Status code::" + response.body.toString());
                        showAlertDialog(this.context, response.body);
                      }
                    } else {
                      dial.hide();
                      Fluttertoast.showToast(
                          msg: 'There was no response from the server');
                    }
                  },
                  child: const Text('Yes'))
            ],
          );
        });
  }

  _fetchCustomers() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url + 'trackerjobcard/customer/?type=1&param=', Config.get);
    if (response != null) {
      print(response);
      response
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((data) {
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

  _fetchInstructions() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url +
            'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=$revised',
        Config.get);
    if (response != null) {
      print(url +
          'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=$revised');
      print(response);
      response
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((data) {
        var jsonResponse = json.decode(data);
        setState(() {
          instructionsJson = jsonResponse;
        });
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Instruction> result = list.map<Instruction>((json) {
          return Instruction.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          setState(() {
            result.sort((a, b) => a.chassisno!
                .toLowerCase()
                .compareTo(b.chassisno!.toLowerCase()));
            _instruction = result;
            if (_instruction != null && _instruction.isNotEmpty) {
              _instruction.forEach((instruction) {
                setState(() {});

                print(_make);
              });
            }
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

  Widget getListTile1(val) {
    return ListTile(
      leading: Text(val['regno'] ?? ''),
      title: Text(val['owner'] ?? ''),
      trailing: Text(val['location'] ?? ''),
    );
  }

  Widget getListTile(val) {
    return ListTile(
      leading: Text(val['mobile'] ?? ''),
      title: Text(val['company'] ?? ''),
      trailing: Text(val['email'] ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return iscameraopen == false
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
                            form = _formKey17.currentState;
                            if (currentForm == 2) {
                              currentForm = 1;
                              percentageComplete = 100;
                            }
                            break;
                          case 3:
                            if (currentForm == 3) {
                              currentForm = 2;
                              percentageComplete = 100;
                            }
                            break;
                          case 4:
                            if (currentForm == 4) {
                              currentForm = 3;
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
                            if (form.validate() &&
                                _instructionId != null &&
                                _custId != null) {
                              form.save();
                              currentForm = 2;
                              // _fetchInstructions();
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Make sure all required fields are filled"),
                                duration: Duration(seconds: 3),
                              ));
                            }
                            if (form.validate() &&
                                _instructionId != null &&
                                _custId != null) {
                              form.save();
                              currentForm = 1;
                              percentageComplete = 25;
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Select customer and attach instruction',
                                  textColor: Colors.red);
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
                            form = _formKey17.currentState;
                            if (form.validate()) {
                              form.save();
                              currentForm = 3;
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
                          case 3:
                            setState(() {
                              currentForm = 4;
                            });
                            break;
                          case 4:
                            _submit();
                        }
                      });
                    },
                    icon: Icon(currentForm == 4
                        ? Icons.upload_rounded
                        : Icons.arrow_forward),
                    label: Text(currentForm == 4 ? "finish" : "next"),
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
                    quarterTurns: 0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
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
                                'Create Assessment',
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
                                        SearchableDropdown(
                                          hint: const Text(
                                            "Select Customer",
                                          ),

                                          isExpanded: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value;
                                              _custId = value != null
                                                  ? value['custid']
                                                  : null;
                                              _custName = value != null
                                                  ? value['company']
                                                  : null;
                                              _custPhone = value != null
                                                  ? value['mobile']
                                                  : null;
                                              // _custEmail = value != null
                                              //     ? ['email']
                                              //     : null;

                                              _fetchInstructions();
                                            });
                                            print(_selectedValue);
                                            print(_custName);
                                            print(_custId);
                                            print(_custPhone);
                                            _dropdownError = null;
                                          },

                                          // isCaseSensitiveSearch: true,
                                          searchHint: const Text(
                                            'Select Customer ',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          items: customersJson.map((val) {
                                            return DropdownMenuItem(
                                              child: getListTile(val),
                                              value: val,
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.trailing,
                                          title: Text(
                                            'Revised',
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                          value: revised,
                                          activeColor: Colors.red,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              if (_custId != null) {
                                                _fetchInstructions();
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'Select Customer');
                                              }

                                              revised = value!;
                                            });
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Txn Date:",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    _dateinput, //editing controller of this TextField
                                                decoration:
                                                    const InputDecoration(
                                                        //icon of text field
                                                        ),
                                                readOnly:
                                                    true, //set it true, so that user will not able to edit text
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate: DateTime(
                                                              2000), //DateTime.now() - not to allow to choose before today.
                                                          lastDate:
                                                              DateTime(2101));

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
                                                    print(
                                                        "Date is not selected");
                                                  }
                                                },
                                              ),
                                            ),
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Asmt Date:",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    _dateinput, //editing controller of this TextField
                                                decoration:
                                                    const InputDecoration(
                                                        //icon of text field
                                                        ),
                                                readOnly:
                                                    true, //set it true, so that user will not able to edit text
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate: DateTime(
                                                              2000), //DateTime.now() - not to allow to choose before today.
                                                          lastDate:
                                                              DateTime(2101));

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
                                                    print(
                                                        "Date is not selected");
                                                  }
                                                },
                                              ),
                                            ),
                                            Icon(
                                              Icons.calendar_today,
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        SearchableDropdown(
                                          hint: const Text(
                                            "Attach Instruction",
                                          ),

                                          isExpanded: true,
                                          onChanged: (value) {
                                            // _location = (value != null
                                            //     ? ['location']
                                            //     : null);

                                            setState(() {
                                              _selectedValue = value;
                                              _instructionId = value != null
                                                  ? value['id']
                                                  : null;
                                              _make = value != null
                                                  ? value['make']
                                                  : null;
                                              _chasisno = value != null
                                                  ? value['chassisno']
                                                  : null;
                                              _policyno = value != null
                                                  ? value['policyno']
                                                  : null;
                                              _claimno = value != null
                                                  ? value['claimno']
                                                  : null;
                                              _carmodel = value != null
                                                  ? value['model']
                                                  : null;

                                              _location = value != null
                                                  ? value['location']
                                                  : null;
                                              _owner = value != null
                                                  ? value['owner']
                                                  : null;
                                              _insuredvalue = value != null
                                                  ? value['insuredvalue']
                                                  : null;
                                              _vehiclereg = value != null
                                                  ? value['regno']
                                                  : null;
                                              _excess = value != null
                                                  ? value['excess']
                                                  : null;
                                              print(_insuredvalue);
                                              _fetchInstructions();
                                            });
                                            print(_instructionId);
                                            // print(_custName);
                                            // print(_custId);
                                            // print(_custPhone);
                                            _dropdownError = null;
                                          },

                                          // isCaseSensitiveSearch: true,
                                          searchHint: const Text(
                                            'Attach Instruction',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          items: instructionsJson.map((val) {
                                            return DropdownMenuItem(
                                              child: getListTile1(val),
                                              value: val,
                                            );
                                          }).toList(),
                                        ),
                                        const SizedBox(
                                          height: 20,
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
                                      const SizedBox(
                                        height: 20,
                                      ),
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        initialValue: _owner,
                                        style:
                                            const TextStyle(color: Colors.red),
                                        onSaved: (value) => {vehicleReg},
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                            hintText: "Insured/Owner"),
                                      ),
                                      const SizedBox(
                                        height: 10,
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
                                        style:
                                            const TextStyle(color: Colors.red),
                                        initialValue:
                                            _claimno != null ? _claimno : '',
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
                                        initialValue: _policyno ?? '',
                                        style:
                                            const TextStyle(color: Colors.red),
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
                                            "Reg No.",
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
                                        initialValue: _vehiclereg ?? '',
                                        style:
                                            const TextStyle(color: Colors.red),
                                        onSaved: (value) => {vehicleColor},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Reg No."),
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        initialValue:
                                            _location != null ? _location : '',
                                        style:
                                            const TextStyle(color: Colors.red),
                                        onSaved: (value) => {},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Vehicle Location"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Insured Value",
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
                                        initialValue: _insuredvalue.toString(),
                                        style:
                                            const TextStyle(color: Colors.red),
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Insured Value"),
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
                                        initialValue: _excess,
                                        style:
                                            const TextStyle(color: Colors.red),
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Excess"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Chassis No",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        initialValue: _chasisno,
                                        onSaved: (value) => {engineNo},
                                        style:
                                            const TextStyle(color: Colors.red),
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Chassis No"),
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
                                            "*",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        style:
                                            const TextStyle(color: Colors.red),
                                        initialValue:
                                            _make != null ? _make : '',
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Make"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Type/Model	",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        style:
                                            const TextStyle(color: Colors.red),
                                        initialValue:
                                            _carmodel != null ? _carmodel : '',
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Type/Model	 By"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        title: Text(
                                          'Driven',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(),
                                        ),
                                        value: isOther5,
                                        activeColor: Colors.red,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isOther5 = value!;
                                          });
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        title: Text(
                                          'Towed',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(),
                                        ),
                                        value: isOther6,
                                        activeColor: Colors.red,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isOther6 = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ))
                          ])),
                      Form(
                          key: _formKey17,
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
                                        "Vehicle Details",
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
                                            "Year",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _year,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: "Year"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Mileage",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _mileage,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Mileage"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Color",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _color,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Color"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Engine No.",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _engineno,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Engine No."),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "P.A.V",
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
                                        controller: _pav,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: "P.A.V"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Salvage",
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
                                        controller: _salvage,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                            hintText: "Salvage"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Pre-Accident Condition",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Brakes",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _brakes,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Brakes"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "PaintWork",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _paintwork,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "PaintWork"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Steering",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _steering,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Steering"),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Tyres",
                                              style: const TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "RHF",
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
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? "This field is required"
                                                      : null,
                                              controller: _RHF,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  hintText: "RHF"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "LHR",
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
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? "This field is required"
                                                      : null,
                                              controller: _LHR,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  hintText: "LHR"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "RHR",
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
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? "This field is required"
                                                      : null,
                                              controller: _RHR,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  hintText: "RHR"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "LHF",
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
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              validator: (value) =>
                                                  value!.isEmpty
                                                      ? "This field is required"
                                                      : null,
                                              controller: _LHF,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  hintText: "LHF"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Spare",
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
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _spare,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: const InputDecoration(
                                                  hintText: "Spare"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                    ],
                                  ),
                                ))
                          ])),
                      Form(
                          key: _formKey18,
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
                                        "Photos",
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
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            iscameraopen = true;
                                            image = null;
                                            _itemDescController.clear();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "Add photos",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            const SizedBox(
                                              width: 200,
                                            ),
                                            const Icon(
                                              Icons.camera_enhance,
                                              color: Colors.red,
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      imageslist != null
                                          ? Container(
                                              child: GridView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                ),
                                                itemCount: imageslist!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Container(
                                                    child: Stack(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      children: <Widget>[
                                                        InteractiveViewer(
                                                          panEnabled: true,
                                                          boundaryMargin:
                                                              const EdgeInsets
                                                                  .all(80),
                                                          minScale: 0.5,
                                                          maxScale: 4,
                                                          child: FadeInImage(
                                                            image: FileImage(
                                                              File(imageslist![
                                                                      index]
                                                                  .path),
                                                            ),
                                                            placeholder:
                                                                MemoryImage(
                                                                    kTransparentImage),
                                                            fit: BoxFit.cover,
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors.black
                                                              .withOpacity(0.1),
                                                          height: 30,
                                                          width:
                                                              double.infinity,
                                                          child: Center(
                                                            child: Text(
                                                              filenames![index],
                                                              maxLines: 8,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Regular'),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Container(),
                                      const SizedBox(
                                        height: 80,
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
        : Scaffold(
            appBar: AppBar(
              title: const Text("Capture Image from Camera"),
              backgroundColor: Colors.redAccent,
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
                        setState(() {
                          iscameraopen = false;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
                child: Container(
                    child: Column(children: [
              Container(
                height: 500,
                width: 500,
                child: controller == null
                    ? const Center(child: Text("Loading Camera..."))
                    : !controller!.value.isInitialized
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CameraPreview(controller!),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    "Image Description",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(),
                  ),
                ],
              ),
              TextFormField(
                validator: (value) =>
                    value!.isEmpty ? "This field is required" : null,
                controller: _itemDescController,
                onSaved: (value) => {engineNo},
                keyboardType: TextInputType.text,
                decoration:
                    const InputDecoration(hintText: "Enter Image Description"),
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton.icon(
                //image capture button
                onPressed: () async {
                  if (_itemDescController.text != '') {
                    try {
                      if (controller != null) {
                        //check if contrller is not null
                        if (controller!.value.isInitialized) {
                          //check if controller is initialized
                          image =
                              await controller!.takePicture(); //capture image
                          setState(() {
                            String? description =
                                _itemDescController.text.trim();
                            print(description);
                            final bytes =
                                Io.File(image!.path).readAsBytesSync();

                            String imageFile = base64Encode(bytes);
                            images = Images(
                                filename: description, attachment: imageFile);
                            _addImage(image!);
                            _addImages(images!);
                            _addDescription(description);
                          });
                        }
                      }
                    } catch (e) {
                      print(e); //show error
                    }
                    setState(() {
                      iscameraopen = false;
                    });
                  } else {
                    setState(() {
                      image = null;
                      images = null;
                    });

                    Fluttertoast.showToast(
                        msg: 'Please fill the description to capture image');
                  }
                },
                icon: const Icon(Icons.camera),
                label: const Text("Capture"),
              ),
            ]))),
          );
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

void _showDialog(BuildContext context) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Home()));
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text(
      "Success!",
      style: const TextStyle(color: Colors.green),
    ),
    content: const Text("Successful!"),
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
}
