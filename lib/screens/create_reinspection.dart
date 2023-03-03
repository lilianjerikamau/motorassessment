import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/assessmentmodels.dart';
import 'package:motorassesmentapp/models/imagesmodels.dart';
import 'package:motorassesmentapp/models/instructionmodels.dart';
import 'package:motorassesmentapp/models/reinspection_model.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/screens/create_instruction.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:motorassesmentapp/screens/save_reinspection.dart';
import 'package:motorassesmentapp/utils/network_handler.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:motorassesmentapp/screens/login_screen.dart';
import '../database/db_helper.dart';
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
import 'package:gallery_saver/gallery_saver.dart';
import '../main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../main.dart';

class CreateReinspection extends StatefulWidget {
  int? custID;
  String? custName;
  CreateReinspection({Key? key, this.custID, this.custName}) : super(key: key);

  @override
  State<CreateReinspection> createState() => _CreateReinspectionState();
}

class _CreateReinspectionState extends State<CreateReinspection> {
  late User _loggedInUser;
  DBHelper dbHelper = DBHelper();
  String? reinspectionString;
  int? index;
  late Random random;
  int? _userid;
  int? _custid;
  int? _custId;
  int? _hrid;
  String? _username;
  String? _costcenter;
  String? loanofficerName;
  String? loanofficerEmail;
  String? loanofficerPhone;
  String? vehicleReg;
  String? chassisNo;
  String? carModel;
  int? _insuredvalue;
  String? _excess;
  String? _owner;
  String? _vehiclereg;
  String? vehicleType;
  String? vehicleColor;
  String? engineNo;
  String? custName;
  String? custPhone;
  bool _loggedIn = false;
  String? remarks;
  String? installationLocation;
  List<String>? filenames = [];
  int? customerid;
  String? customersString;
  String? assessmentsString;
  String? instructionsString;
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
  final _remarks = TextEditingController();
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
  final _deliveredby = TextEditingController();
  // final _owner = TextEditingController();
  // final _claimno = TextEditingController();
  // final _policyno = TextEditingController();
  // final _location = TextEditingController();
  // final _insuredvalue = TextEditingController();
  // final _excess = TextEditingController();
  CameraController? controller; //controller for camera
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;

  bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.max;

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String string = '';
  _checkNetwork() {
    _networkConnectivity.initialise();
    _networkConnectivity.myStream.listen((source) async {
      _source = source;
      print('source $_source');
      // 1.
      switch (_source.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          string =
              _source.values.toList()[0] ? 'Mobile: Online' : 'Mobile: Offline';
          break;
        case ConnectivityResult.wifi:
          string =
              _source.values.toList()[0] ? 'WiFi: Online' : 'WiFi: Offline';
          break;
        case ConnectivityResult.none:
        default:
          string = 'Offline';
      }
      // 2.
      setState(() {
        if (string.contains('Offline')) {
          Fluttertoast.showToast(
              msg:
                  'No internet,your assessment will be posted once you are connected to the internet!');
          // saveAssessments();
        } else {
          // _submit();
        }
      });
      // 3.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(
      //       string,
      //       style: TextStyle(fontSize: 30),
      //     ),
      //   ),
      // );
    });
    if (string.contains('Offline')) {
      Fluttertoast.showToast(
          msg:
              'No internet,your assessment will be posted once you are connected to the internet!');
    } else {
      _submit();
    }
  }

  void _toggle() {
    setState(() {
      isOther5 = !isOther6;
    });
  }

  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString('key') as String;
    List customerList = auth.split(",");
    print("customerlist");

    setState(() {
      customerList = customersJson;
      print(customersJson);
    });
  }

  Future<void> saveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', customersString!);
    print('user info:');
    // printWrapped(customersString!);
    getUserInfo();
  }

  getAssessments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString(assessmentlist) as String;
    List assessmentList = auth.split(",");
    print("assessmentList");

    setState(() {
      assessmentList = reinspassessmentJson;
      print(assessmentList);
    });
  }

  Future<void> saveAssessments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(assessmentlist, assessmentsString!);
    print('user info:');
    // printWrapped(customersString!);
    getAssessments();
  }

  getInstructions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString(instructionlist) as String;
    List instructionsList = auth.split(",");
    print("instructionsList");

    setState(() {
      instructionsList = reinspinstructionsJson;
      print(instructionsList);
    });
  }

  Future<void> saveInstructions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(instructionlist, instructionsString!);
    print('user info:');
    // printWrapped(customersString!);
    getInstructions();
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
          customersString = customersJson.join(",");
          saveUserInfo();
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

  Widget getListTile(val) {
    return ListTile(
      leading: Text(val['mobile'] ?? ''),
      title: Text(val['company'] ?? ''),
      trailing: Text(val['email'] ?? ''),
    );
  }

  _submit() async {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Submit?'),
            content: Text('Are you sure you want to submit'),
            actions: <Widget>[
              MaterialButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  }),
              MaterialButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    print(images.toString());
                    String year = _year.text.trim();
                    String dateinput = _dateinput.text;
                    String remarks = _remarks.text;
                    String pav = _pav.text.trim();
                    String color = _color.text.trim();
                    String salvage = _salvage.text.trim();
                    String brakes = _brakes.text.trim();
                    String model = _carmodel.text.trim();
                    String make = _make.text.trim();
                    String paintwork = _paintwork.text.trim();
                    String mileage = _mileage.text.trim();

                    String engineno = _engineno.text.trim();
                    String steering = _steering.text.trim();
                    String drivenby = _deliveredby.text.trim();
                    String RHF = _RHF.text.trim();
                    String LHR = _LHR.text;
                    String RHR = _RHR.text;
                    String LHF = _LHF.text.trim();
                    String spare = _spare.text.trim();
                    String transmissionspeed = _transmissionspeed.text.trim();
                    String damagesobserved = _damagesobserved.text.trim();
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);
                    dial.style(
                      message: 'Sending Reinspection',
                    );
                    dial.show();
                    setState(() {
                      reinspectionString = (jsonEncode(<String, dynamic>{
                        "userid": _userid,
                        "custid": _custId,
                        "revised": revised,
                        "instructionno": _instructionId,
                        "assessmentno": _assessmentId,
                        "make": make,
                        "model": model,
                        "year": year,
                        "mileage": mileage,
                        "color": color,
                        "engineno": engineno,
                        "chassisno": _chasisno,
                        "pav": pav != "null" ? pav : "0.00",
                        "salvage": salvage != "null" ? pav : "0.00",
                        "brakes": brakes,
                        "paintwork": paintwork,
                        "RHF": RHF,
                        "LHR": LHR,
                        "RHR": RHR,
                        "LHF": LHF,
                        "transmissionspeed": transmissionspeed,
                        "vehicletype": drivetypeid,
                        "transmissiontype": transmissionid,
                        "remarks": remarks,
                        "photolist": newImagesList,
                      }));
                    });

                    try {
                      final result = await InternetAddress.lookup('google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        String demoUrl = await Config.getBaseUrl();
                        Uri url =
                            Uri.parse(demoUrl + 'valuation/reinspection/');
                        print(url);

                        final response = await http.post(url,
                            headers: <String, String>{
                              'Content-Type': 'application/json',
                            },
                            body: jsonEncode(<String, dynamic>{
                              "userid": _userid,
                              "custid": widget.custID == null
                                  ? _custId
                                  : widget.custID,
                              "revised": revised,
                              "instructionno": _instructionId,
                              "assessmentno": _assessmentId,
                              "make": make,
                              "model": model,
                              "year": year,
                              "mileage": mileage,
                              "color": color,
                              "engineno": engineno,
                              "chassisno": _chasisno,
                              "transmissionspeed": transmissionspeed,
                              "vehicletype": drivetypeid,
                              "transmissiontype": transmissionid,
                              "pav": pav != "null" ? pav : "0.00",
                              "salvage": salvage != "null" ? pav : "0.00",
                              "brakes": brakes,
                              "paintwork": paintwork,
                              "RHF": RHF,
                              "LHR": LHR,
                              "RHR": RHR,
                              "LHF": LHF,
                              "remarks": remarks,
                              "photolist": newImagesList,
                            }));

                        if (response != null) {
                          dial.hide();
                          int statusCode = response.statusCode;
                          if (statusCode == 200) {
                            return _showDialog(this.context);
                          } else {
                            print("Submit Status code::" +
                                response.body.toString());
                            showAlertDialog(this.context, response.body);
                          }
                        } else {
                          dial.hide();
                          Fluttertoast.showToast(
                              msg: 'There was no response from the server');
                        }
                      }
                    } on SocketException catch (e) {
                      print('not connected2');

                      if (reinspectionString != null) {
                        dial.show();
                        dbHelper
                            .insertReinspection(
                          ReinspectionModel(
                            id: index,
                            reinspectionjson: reinspectionString,
                          ),
                        )
                            .then((value) {
                          print('reinspection saved');
                          print(index);
                          dial.hide();
                          Fluttertoast.showToast(msg: value.toString());
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaveReinspections()),
                          );
                        }).onError((error, stackTrace) {
                          print(error.toString());
                        });
                      } else {
                        showAlertDialog(
                            this.context, 'Valuation not saved,Try again');
                      }
                    }
                  },
                  child: Text('Yes'))
            ],
          );
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

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;

    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
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

  void _addDescription(String description) {
    setState(() {
      filenames!.add(description);
    });
  }

  int? _instructionId;
  int? _assessmentId;
  String? _policyno;
  String? _chasisno;
  TextEditingController _carmodel = TextEditingController();
  TextEditingController _make = TextEditingController();
  String? _location;
  String? _claimno;
  final String instructionlist = "instructionlist";
  final String assessmentlist = "assessmentlist";

  List<Customer> _customers = [];
  List<XFile>? imageslist = [];

//controller for camera
  XFile? image;
  List<Instruction> _instruction = [];
  List<Assesssment> _assessment = [];

  Images? images;
  List<Map<String, dynamic>>? newImagesList;
  List<Images>? newList = [];
  List<Images>? newimages = [];
  @override
  void initState() {
    random = new Random();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    loadCamera();
    // _checkNetwork();
    if (string.contains('Online')) {
      // saveAssessments();
      // saveInstructions();
      List reinspinstructionsJson = [];
      List reinspassessmentJson = [];
    } else {
      // getAssessments();
      // getInstructions();
      // getUserInfo();
    }
    print('custID');
    print(widget.custID != null);
    if ((widget.custID != 0) && (widget.custID != null)) {
      setState(() {
        SessionPreferences().getLoggedInUser().then((user) {
          setState(() {
            _fetchInstructions();
            _fetchAssessments();
            _fetchCustomers();
            _loggedInUser = user;
            // custId = user.custid;
            _userid = user.id;
            _hrid = user.hrid;
            print('userid');
            print(_hrid);
            _custId = widget.custID as int;
          });
        });

        print('cust id is');
        print(_custId);
      });
    } else {
      _fetchCustomers();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    onNewCameraSelected(cameras[0]);
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
        // _custid = user.custid;
        _costcenter = user.branchname;
        _username = user.fullname;
      });
    });

    super.initState();
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
    _currentExposureOffset = 0.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        cameraController
            .getMinExposureOffset()
            .then((value) => _minAvailableExposureOffset = value),
        cameraController
            .getMaxExposureOffset()
            .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _currentFlashMode = controller!.value.flashMode;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller!.setExposurePoint(offset);
    controller!.setFocusPoint(offset);
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      print('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
    } else {
      print('Camera Permission: DENIED');
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  loadCamera() async {
    cameras = await availableCameras();
    if (cameras != null) {
      controller = CameraController(cameras[0], ResolutionPreset.max);
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

  bool _searchmode = false;
  late BuildContext _context;

  // late User _loggedInUser;

  String? _searchString;
  final _userNameInput = TextEditingController();
  final _passWordInput = TextEditingController();
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _transmissionspeed = new TextEditingController();
  final _vehicletype = TextEditingController();
  final _vehiclecolor = TextEditingController();

  final _custname = TextEditingController();
  final _custphone = TextEditingController();
  final _custEmail = TextEditingController();
  // final _financierid = TextEditingController();
  // final _customerid = TextEditingController();
  final _customertypeid = TextEditingController();
  final _notracker = TextEditingController();
  final _fuelsensor = TextEditingController();

  final _installationdate = TextEditingController();

  TextEditingController _dateinput = TextEditingController();
// User? _loggedInUser;

  // List<Technician>? technicians;
  String _message = 'Search';

  // late final custID;
  // late final custName;
  // TextEditingController _searchController = TextEditingController();
  // TextEditingController _itemDescController = new TextEditingController();
  int? transmissionid;
  int? drivetypeid;
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
  bool isOther6 = true;
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
                        }
                      });
                    },
                    icon: Icon(
                      currentForm == 0 ? Icons.error : Icons.arrow_back,
                      color: Colors.blueAccent,
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
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                                  textColor: Colors.blue);
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
                                  .showSnackBar(SnackBar(
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
                                  .showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(
                                    "Make sure all required fields are filled"),
                                duration: Duration(seconds: 3),
                              ));
                            }
                            break;
                          case 3:
                            if (newImagesList == null) {
                              Fluttertoast.showToast(
                                  msg: 'Please upload images');
                            } else {
                              setState(() {
                                index = random.nextInt(1000000);
                                _submit();
                              });
                            }
                        }
                      });
                    },
                    icon: Icon(currentForm == 4
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
              iconTheme: IconThemeData(color: Colors.black),
              leading: Builder(
                builder: (BuildContext context) {
                  return RotatedBox(
                    quarterTurns: 0,
                    child: IconButton(
                      icon: Icon(
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
                        isLoading ? LinearProgressIndicator() : SizedBox(),
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
                              Text(
                                'Create Reinspection',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    [
                      Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                      SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                                  .copyWith(color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        SearchableDropdown(
                                          hint: Text(
                                            widget.custID != null &&
                                                    widget.custName != ''
                                                ? widget.custName!
                                                : 'Select Customer',
                                          ),

                                          isExpanded: true,
                                          onChanged: (value) {
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
                                            if (string.contains('Offline')) {
                                            } else {
                                              _fetchInstructions();
                                              _fetchAssessments();
                                            }

                                            print(_selectedValue);
                                            print(_custName);
                                            print(_custId);
                                            print(_custPhone);
                                            _dropdownError = null;
                                          },

                                          // isCaseSensitiveSearch: true,
                                          searchHint: Text(
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
                                        SizedBox(
                                          height: 20,
                                        ),
                                        // CheckboxListTile(
                                        //   controlAffinity:
                                        //       ListTileControlAffinity.trailing,
                                        //   title: Text(
                                        //     'Revised',
                                        //     overflow: TextOverflow.ellipsis,
                                        //     style: Theme.of(context)
                                        //         .textTheme
                                        //         .subtitle2!
                                        //         .copyWith(),
                                        //   ),
                                        //   value: revised,
                                        //   activeColor: Colors.blue,
                                        //   onChanged: (bool? value) {
                                        //     setState(() {
                                        //       if (_custId != null &&
                                        //           string.contains('Online')) {
                                        //         _fetchInstructions();
                                        //       } else {
                                        //         Fluttertoast.showToast(
                                        //             msg: 'Select Customer');
                                        //       }
                                        //
                                        //       revised = value!;
                                        //     });
                                        //   },
                                        // ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),
                                        SizedBox(
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
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    _dateinput, //editing controller of this TextField
                                                decoration: InputDecoration(
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
                                              color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Re-Insp Date:",
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller:
                                                    _dateinput, //editing controller of this TextField
                                                decoration: InputDecoration(
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
                                              color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Attach Instruction",
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
                                                  .copyWith(color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        SearchableDropdown(
                                          hint: Text(
                                            "Attach Instruction",
                                          ),
                                          isExpanded: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value;
                                              _assessmentId = 0;
                                              _instructionId = value != null
                                                  ? value['id']
                                                  : null;
                                              _make.text = value != null
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
                                              _carmodel.text = value != null
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

                                              _engineno.text = value != null
                                                  ? value['engineno']
                                                  : null;
                                              _color.text = value != null
                                                  ? value['color']
                                                  : null;
                                              _year.text = value != null
                                                  ? value['year']
                                                  : null;
                                              _paintwork.text = value != null
                                                  ? value['paintwork']
                                                  : null;
                                              _spare.text = value != null
                                                  ? value['spare']
                                                  : null;
                                              _pav.text = (value != null
                                                  ? value["pav"].toString()
                                                  : null)!;
                                              _pav.text = (value != null
                                                  ? value["pav"].toString()
                                                  : null)!;
                                              _salvage.text = (value != null
                                                  ? value["salvage"].toString()
                                                  : null)!;
                                              _RHR.text = value != null
                                                  ? value['rhr']
                                                  : null;
                                              _LHF.text = value != null
                                                  ? value['lhf']
                                                  : null;
                                              _LHR.text = value != null
                                                  ? value['lhr']
                                                  : null;
                                              _LHR.text = value != null
                                                  ? value['lhf']
                                                  : null;
                                              _RHF.text = value != null
                                                  ? value['rhf']
                                                  : null;
                                              _brakes.text = value != null
                                                  ? value['brakes']
                                                  : null;
                                              _steering.text = value != null
                                                  ? value['steering']
                                                  : null;
                                              _remarks.text = value != null
                                                  ? value['remarks']
                                                  : null;
                                            });

                                            _dropdownError = null;
                                          },
                                          searchHint: Text(
                                            'Attach Instruction',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          items:
                                              reinspinstructionsJson.map((val) {
                                            return DropdownMenuItem(
                                              child: getListTile1(val),
                                              value: val,
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Attach Assessment",
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
                                                  .copyWith(color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        SearchableDropdown(
                                          hint: Text(
                                            "Attach Assessment",
                                          ),
                                          isExpanded: true,
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedValue = value;
                                              _instructionId = 0;
                                              _assessmentId = value != null
                                                  ? value['id']
                                                  : null;
                                              _make.text = value != null
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
                                              _carmodel.text = value != null
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
                                              _engineno.text = value != null
                                                  ? value['engineno']
                                                  : null;
                                              _color.text = value != null
                                                  ? value['color']
                                                  : null;
                                              _year.text = value != null
                                                  ? value['year']
                                                  : null;
                                              _paintwork.text = value != null
                                                  ? value['paintwork']
                                                  : null;
                                              _spare.text = value != null
                                                  ? value['spare']
                                                  : null;
                                              _pav.text = (value != null
                                                  ? value["pav"].toString()
                                                  : null)!;
                                              _salvage.text = (value != null
                                                  ? value["salvage"].toString()
                                                  : null)!;
                                              _RHR.text = value != null
                                                  ? value['rhr']
                                                  : null;
                                              _LHF.text = value != null
                                                  ? value['lhf']
                                                  : null;
                                              _LHR.text = value != null
                                                  ? value['lhr']
                                                  : null;
                                              _LHR.text = value != null
                                                  ? value['lhf']
                                                  : null;
                                              _RHF.text = value != null
                                                  ? value['rhf']
                                                  : null;
                                              _brakes.text = value != null
                                                  ? value['brakes']
                                                  : null;
                                              _steering.text = value != null
                                                  ? value['steering']
                                                  : null;
                                              _remarks.text = value != null
                                                  ? value['remarks']
                                                  : null;
                                              print(_chasisno);
                                            });

                                            _dropdownError = null;
                                          },
                                          searchHint: Text(
                                            'Attach Assessment',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          items:
                                              reinspassessmentJson.map((val) {
                                            return DropdownMenuItem(
                                              child: getListTile1(val),
                                              value: val,
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
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
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                      SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 30, bottom: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Transmission type",
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      SearchableDropdown(
                                        hint: Text(
                                          "Transmission type",
                                        ),
                                        validator: (value) => value == null ? 'field required' : null,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            transmissionid = value.id;
                                          });
                                          print(_instructionId);
                                          _dropdownError = null;
                                        },

                                        // isCaseSensitiveSearch: true,
                                        searchHint: Text(
                                          'Transmission type',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        items: transmissiontype.map((val) {
                                          return DropdownMenuItem(
                                            child: Text(val.name),
                                            value: val,
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Drive type",
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      SearchableDropdown(
                                        hint: Text(
                                          "Drive type",
                                        ),
                                        validator: (value) => value == null ? 'field required' : null,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            drivetypeid = value.id;
                                          });
                                          print(_instructionId);
                                          _dropdownError = null;
                                        },

                                        // isCaseSensitiveSearch: true,
                                        searchHint: Text(
                                          'Drive type',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        items: drivetype.map((val) {
                                          return DropdownMenuItem(
                                            child: Text(val.name),
                                            value: val,
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Transimission speed",
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _transmissionspeed,
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {vehicleReg},
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            hintText: "Transimission speed"),
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: _owner,
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {vehicleReg},
                                        keyboardType: TextInputType.name,
                                        decoration: InputDecoration(
                                            hintText: "Insured/Owner"),
                                      ),
                                      SizedBox(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        style: TextStyle(color: Colors.blue),
                                        initialValue:
                                            _claimno != null ? _claimno : '',
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Claim No"),
                                      ),
                                      SizedBox(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: _policyno ?? '',
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {vehicleColor},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Policy No."),
                                      ),
                                      SizedBox(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        initialValue:
                                            _location != null ? _location : '',
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Enter Vehicle Location"),
                                      ),
                                      SizedBox(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: _insuredvalue != null
                                            ? _insuredvalue.toString()
                                            : "",
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Insured Value"),
                                      ),
                                      SizedBox(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: _excess,
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Enter Excess"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                          ])),
                      Form(
                          key: _formKey17,
                          child: Column(children: <Widget>[
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                      SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 30,
                                        bottom: 30),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _make,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Make"),
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _carmodel,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Type/Model	 By"),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _year,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "Year"),
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _mileage,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Mileage"),
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _color,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Color"),
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _engineno,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Engine No."),
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            initialValue: _chasisno,
                                            // controller: _chassisno,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Chassis No"),
                                          ),
                                          SizedBox(
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
                                                "*",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _pav,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "P.A.V"),
                                          ),
                                          SizedBox(
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
                                                "*",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _salvage,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                                hintText: "Salvage"),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Pre-Accident Condition",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
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
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _brakes,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Brakes"),
                                          ),
                                          SizedBox(
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
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _paintwork,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "PaintWork"),
                                          ),
                                          SizedBox(
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
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _steering,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Steering"),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Tyres",
                                                  style: TextStyle(
                                                    fontSize: 15.0,
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "This field is required"
                                                      : null,
                                                  controller: _RHF,
                                                  onSaved: (value) =>
                                                      {engineNo},
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText: "RHF"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "This field is required"
                                                      : null,
                                                  controller: _LHR,
                                                  onSaved: (value) =>
                                                      {engineNo},
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText: "LHR"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "This field is required"
                                                      : null,
                                                  controller: _RHR,
                                                  onSaved: (value) =>
                                                      {engineNo},
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText: "RHR"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  validator: (value) => value!
                                                          .isEmpty
                                                      ? "This field is required"
                                                      : null,
                                                  controller: _LHF,
                                                  onSaved: (value) =>
                                                      {engineNo},
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText: "LHF"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
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
                                                    .copyWith(
                                                        color: Colors.blue),
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                  controller: _spare,
                                                  onSaved: (value) =>
                                                      {engineNo},
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                      hintText: "Spare"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Remarks",
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2!
                                                    .copyWith(),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            validator: (value) => value!.isEmpty
                                                ? "This field is required"
                                                : null,
                                            controller: _remarks,
                                            onSaved: (value) => {engineNo},
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                                hintText: "Remarks"),
                                          ),
                                        ])))
                          ])),
                      Form(
                          key: _formKey18,
                          child: Column(children: <Widget>[
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                      SizedBox(
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                )),
                            Card(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                            SizedBox(
                                              width: 200,
                                            ),
                                            Icon(
                                              Icons.camera_enhance,
                                              color: Colors.blue,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      // Container(
                                      //   //show captured image
                                      //   padding: EdgeInsets.all(30),
                                      //   child: image == null
                                      //       ? Text("No image captured")
                                      //       : Image.file(
                                      //           File(image!.path),
                                      //           height: 300,
                                      //         ),
                                      //   //display captured image
                                      // ),
                                      // Container(
                                      //   child: imageslist != null
                                      //       ? ListView.builder(
                                      //           scrollDirection: Axis.vertical,
                                      //           shrinkWrap: true,
                                      //           itemCount: imageslist!.length,
                                      //           itemBuilder: (context, index) {
                                      //             return InkWell(
                                      //                 onTap: () {
                                      //                   return null;
                                      //                 },
                                      //                 child: Card(
                                      //                   child: Container(
                                      //                     child: Padding(
                                      //                       padding:
                                      //                            EdgeInsets
                                      //                               .all(8.0),
                                      //                       // child: Text(
                                      //                       //     imageslist![
                                      //                       //             index]
                                      //                       //         .path),
                                      //                       child: Image.file(
                                      //                         File(imageslist![
                                      //                                 index]
                                      //                             .path),
                                      //                         height: 50,
                                      //                         width: 50,
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 ));
                                      //           })
                                      //       : Text("No images captured"),
                                      // ),
                                      imageslist != null
                                          ? Container(
                                              child: GridView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
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
                                                              EdgeInsets.all(
                                                                  80),
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
                                                              style: TextStyle(
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
                                      SizedBox(
                                        height: 80,
                                      ),
                                    ],
                                  ),
                                ))
                          ])),
                      Column(children: <Widget>[
                        Card(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding: EdgeInsets.only(
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
                                  SizedBox(
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
            backgroundColor: Colors.transparent,
            body: _isCameraPermissionGranted
                ? _isCameraInitialized
                    ? Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SingleChildScrollView(
                              child: Column(
                                  children: [
                                AspectRatio(
                                  aspectRatio:
                                      MediaQuery.of(context).size.width /
                                          MediaQuery.of(context).size.height,
                                  child: Stack(
                                    children: [
                                      CameraPreview(
                                        controller!,
                                        // child: LayoutBuilder(builder:
                                        //     (BuildContext context,
                                        //         BoxConstraints constraints) {
                                        //   return GestureDetector(
                                        //     behavior: HitTestBehavior.translucent,
                                        //     onTapDown: (details) => onViewFinderTap(
                                        //         details, constraints),
                                        //   );
                                        // }),
                                      ),
                                      // TODO: Uncomment to preview the overlay
                                      // Center(
                                      //   child: Image.asset(
                                      //     'assets/camera_aim.png',
                                      //     color: Colors.greenAccent,
                                      //     width: 150,
                                      //     height: 150,
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          16.0,
                                          8.0,
                                          16.0,
                                          8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black87,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                  ),
                                                  child: DropdownButton<
                                                      ResolutionPreset>(
                                                    dropdownColor:
                                                        Colors.black87,
                                                    underline: Container(),
                                                    value:
                                                        currentResolutionPreset,
                                                    items: [
                                                      for (ResolutionPreset preset
                                                          in resolutionPresets)
                                                        DropdownMenuItem(
                                                          child: Text(
                                                            preset
                                                                .toString()
                                                                .split('.')[1]
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          value: preset,
                                                        )
                                                    ],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        currentResolutionPreset =
                                                            value!;
                                                        _isCameraInitialized =
                                                            false;
                                                      });
                                                      onNewCameraSelected(
                                                          controller!
                                                              .description);
                                                    },
                                                    hint: Text("Select item"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0, top: 16.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    _currentExposureOffset
                                                            .toStringAsFixed(
                                                                1) +
                                                        'x',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: RotatedBox(
                                                quarterTurns: 3,
                                                child: Container(
                                                  height: 30,
                                                  child: Slider(
                                                    value:
                                                        _currentExposureOffset,
                                                    min:
                                                        _minAvailableExposureOffset,
                                                    max:
                                                        _maxAvailableExposureOffset,
                                                    activeColor: Colors.white,
                                                    inactiveColor:
                                                        Colors.white30,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        _currentExposureOffset =
                                                            value;
                                                      });
                                                      await controller!
                                                          .setExposureOffset(
                                                              value);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Slider(
                                                    value: _currentZoomLevel,
                                                    min: _minAvailableZoom,
                                                    max: _maxAvailableZoom,
                                                    activeColor: Colors.white,
                                                    inactiveColor:
                                                        Colors.white30,
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        _currentZoomLevel =
                                                            value;
                                                      });
                                                      await controller!
                                                          .setZoomLevel(value);
                                                    },
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black87,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        _currentZoomLevel
                                                                .toStringAsFixed(
                                                                    1) +
                                                            'x',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.off;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.off,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.flash_off,
                                                      color: _currentFlashMode ==
                                                          FlashMode.off
                                                          ? Colors.amber
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.auto;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.auto,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.flash_auto,
                                                      color: _currentFlashMode ==
                                                          FlashMode.auto
                                                          ? Colors.amber
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.always;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.always,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.flash_on,
                                                      color: _currentFlashMode ==
                                                          FlashMode.always
                                                          ? Colors.amber
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: InkWell(
                                                    onTap: () async {
                                                      setState(() {
                                                        _currentFlashMode =
                                                            FlashMode.torch;
                                                      });
                                                      await controller!
                                                          .setFlashMode(
                                                        FlashMode.torch,
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.highlight,
                                                      color: _currentFlashMode ==
                                                          FlashMode.torch
                                                          ? Colors.amber
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    image = await takePicture();
                                                    File image1 =
                                                        File(image!.path);

                                                    int currentUnix = DateTime
                                                            .now()
                                                        .millisecondsSinceEpoch;

                                                    String fileFormat = image1
                                                        .path
                                                        .split('.')
                                                        .last;
                                                    setState(() {
                                                      iscameraopen = false;
                                                    });
                                                    iscameraopen = false;
                                                    // GallerySaver.saveImage(
                                                    //         image!.path)
                                                    //     .then((path) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return _SystemPadding(
                                                          child: AlertDialog(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            content: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _itemDescController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    autofocus:
                                                                        true,
                                                                    decoration: const InputDecoration(
                                                                        labelText:
                                                                            'Enter Description',
                                                                        hintText:
                                                                            'Description'),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                  child: const Text(
                                                                      'CANCEL'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                              TextButton(
                                                                  child:
                                                                      const Text(
                                                                          'OKAY'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {
                                                                      String?
                                                                          description =
                                                                          _itemDescController
                                                                              .text
                                                                              .trim();
                                                                      print(
                                                                          description);
                                                                      final bytes =
                                                                          Io.File(image!.path)
                                                                              .readAsBytesSync();

                                                                      String
                                                                          imageFile =
                                                                          base64Encode(
                                                                              bytes);
                                                                      images = Images(
                                                                          filename:
                                                                              description,
                                                                          attachment:
                                                                              imageFile);
                                                                      _addImage(
                                                                          image!);
                                                                      _addImages(
                                                                          images!);
                                                                      _addDescription(
                                                                          description);
                                                                    });
                                                                  })
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                    // });
                                                    print(fileFormat);
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            _isVideoCameraSelected
                                                                ? Colors.white
                                                                : Colors
                                                                    .white38,
                                                        size: 95,
                                                      ),
                                                      Icon(
                                                        Icons.circle,
                                                        color:
                                                            _isVideoCameraSelected
                                                                ? Colors.white
                                                                : Colors.blue,
                                                        size: 80,
                                                      ),
                                                      _isVideoCameraSelected &&
                                                              _isRecordingInProgress
                                                          ? Icon(
                                                              Icons
                                                                  .stop_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 32,
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          'LOADING',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(),
                      Text(
                        'Permission denied',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          getPermissionStatus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Give permission',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          );
  }

  void _showDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Home()));
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Success!",
        style: TextStyle(color: Colors.green),
      ),
      content: Text("Successful!"),
      actions: [
        okButton,
      ],
    );
    //   context: context,
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _fetchInstructions() async {
    String url = await Config.getBaseUrl();

    URLQueryParams urlQueryParams = new URLQueryParams();
    urlQueryParams.append('custid', _custId);
    urlQueryParams.append('hrid', _hrid);
    urlQueryParams.append('typeid', '1');
    urlQueryParams.append('revised', revised);
    String qParams = urlQueryParams.toString();
    final stringurl = widget.custID == null
        ? (url +
            'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=5&revised=$revised')
        : (url +
            'valuation/custinstruction/?custid=${widget.custID}&hrid=$_hrid&typeid=5&revised=$revised');
    HttpClientResponse response = await Config.getRequestObject(
      stringurl,
      Config.get,
    );
    if (response != null) {
      print(stringurl);
      print(response.compressionState);
      bool _validURL = Uri.parse(url +
              'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=5&revised=$revised')
          .isAbsolute;
      print(_validURL);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = jsonDecode(data);
        print(jsonResponse);
        setState(() {
          reinspinstructionsJson = jsonResponse;
          // instructionsString = reinspinstructionsJson.join(",");
          // saveInstructions();
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

                // print(_make);
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

  _fetchAssessments() async {
    String url = await Config.getBaseUrl();

    final stringurl = widget.custID == null
        ? (url + 'valuation/assessmentlist/?custid=$_custId')
        : (url + 'valuation/assessmentlist/?custid=${widget.custID}');

    HttpClientResponse response = await Config.getRequestObject(
      stringurl,
      Config.get,
    );
    if (response != null) {
      print(response);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        setState(() {
          reinspassessmentJson = jsonResponse;
          // assessmentsString = reinspassessmentJson.join(",");
          // saveAssessments();
        });
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Assesssment> result = list.map<Assesssment>((json) {
          return Assesssment.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          setState(() {
            result.sort((a, b) => a.chassisno!
                .toLowerCase()
                .compareTo(b.chassisno!.toLowerCase()));
            _assessment = result;
            if (_assessment != null && _assessment.isNotEmpty) {
              _assessment.forEach((_assessment) {
                setState(() {});

                // prins
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
      title: Text(val['customer'] ?? ''),
      trailing: Text(val['location'] ?? ''),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return AnimatedContainer(
        padding: mediaQuery.padding,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
