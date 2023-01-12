import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:motorassesmentapp/models/assessmentmodels.dart';

import 'package:motorassesmentapp/utils/network_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
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
import 'package:gallery_saver/gallery_saver.dart';
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class CreateAssesment extends StatefulWidget {
  int? custID;
  String? custName;

  CreateAssesment({Key? key, this.custID, this.custName}) : super(key: key);

  @override
  State<CreateAssesment> createState() => _CreateAssesmentState();
}

class _CreateAssesmentState extends State<CreateAssesment>
    with WidgetsBindingObserver {
  User? _loggedInUser;

  int? _userid;
  var _custid;
  String? _custname;
  String? _custphone;
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
  bool _clicked = false;
  String? remarks;
  String? installationLocation;
  Images? images;
  List<Map<String, dynamic>>? newImagesList;
  List<Images>? newList = [];
  List<Images>? newimages = [];
  int? customerid;
  String? _policyno;
  String? _chasisno;
  // String? _make;
  TextEditingController _make = TextEditingController();
  TextEditingController _model = TextEditingController();
  TextEditingController _type = TextEditingController();
  TextEditingController _vehiclereg = TextEditingController();

  String? _carmodel;
  String? _location;
  String? _claimno;
  int? _insuredvalue;
  String? _excess;
  String? _owner;
  // String? _vehiclereg;
  List<Customer> _customers = [];
  List<Instruction> _instruction = [];
  final value = new NumberFormat("#,##0.00", "en_US");
  List<String> assessmentsJson = [];
  String? assessmentsString;
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
  var formatter = NumberFormat('#,##,000');
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

  createPdf() async {
    var bytes = base64Decode(_claimString!.replaceAll('\n', ''));
    printWrapped(_claimString!);
    final output = await getTemporaryDirectory();

    final file = File("${output.path}/${_instructionId}.pdf");

    output.create();
    await file.writeAsBytes(bytes.buffer.asUint8List());

    print("${output.path}/${_instructionId}.pdf");
    await OpenFile.open("${output.path}/${_instructionId}.pdf");
    // if (output.existsSync()) {
    //   output.deleteSync(recursive: true);
    // }
    setState(() {});
  }

  List<XFile>? imageslist = [];
  List<String>? filenames = [];

  CameraController? controller; //controller for camera
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;

  // bool _isRearCameraSelected = true;
  bool _isVideoCameraSelected = false;
  bool _isRecordingInProgress = false;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  // late SharedPreferences prefs;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.low;
  XFile? image; //for captured image
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
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
      onNewCameraSelected(cameras[0]);
    } else {
      log('Camera Permission: DENIED');
    }
  }

  Map _source = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;

  saveAssessments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // save
    prefs.setString("asessmentslist", assessmentsString!);
    // readAssessments();
  }

  readAssessments() async {
    //  read

    // prefs = await SharedPreferences.getInstance();
    // assessmentsString = prefs.getString("asessmentslist")!;
    // List<Assesssment> assesssments =
    //     assessmentsJson.map((json) => Assesssment.fromJson(json)).toList();
    print('asessmentspostlist is');
    // for (int i = 0; i < assessmentsJson.length; i++) {
    //   setState(() {
    //     assessmentsString = assessmentsJson[i];
    //     print(assessmentsJson[i]);
    //   });
    // }
    print('readassessment string  is');
    print(assessmentsString);
    if (ConnectivityResult.none == true || assessmentsString == null) {
    } else {
      _submitOffline();
    }
  }

  StreamSubscription? connection;
  bool isoffline = false;

  @override
  void initState() {
    print('custID');
    print(widget.custID != null);
    if ((widget.custID != 0) && (widget.custID != null)) {
      setState(() {
        SessionPreferences().getLoggedInUser().then((user) {
          setState(() {
            _fetchInstructions();
            // _fetchCustomers();
            _loggedInUser = user;
            custId = user.custid;
            _userid = user.id;
            _hrid = user.hrid;
            print('userid');
            print(_hrid);
            // _custId = widget.custID as int;
          });
        });

        print('cust id is');
        print(widget.custID);
      });
    } else {
      _fetchCustomers();
    }

    loadCamera();
    // saveUserInfo();

    // saveAssessmentInstructions();
    getAssessmentInstructions();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    onNewCameraSelected(cameras[0]);

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
    connection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      // if (result == ConnectivityResult.none) {
      //   //there is no any connection
      //   print('Not Connected');
      //   setState(() {
      //     isoffline = true;
      //   });
      // } else if (result == ConnectivityResult.mobile) {
      //   //connection is mobile data network
      //   if (assessmentsString != null || assessmentsString == "") {
      //     readAssessments();
      //   }
      //   print('Connected to mobile');
      //   setState(() {
      //     isoffline = false;
      //   });
      // } else if (result == ConnectivityResult.wifi) {
      //   //connection is from wifi
      //   print('Connected to wifi');
      //   print(assessmentsString);
      //   if (assessmentsString != null || assessmentsString == "") {
      //     readAssessments();
      //   }
      //   setState(() {
      //     isoffline = false;
      //   });
      // }
    });
    super.initState();
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

  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString('key') as String;
    List customerList = auth.split(",");
    print("customerlist");
    print(customersJson);
    setState(() {
      customerList = customersJson;
    });
  }

  Future<void> saveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', customersString!);
    print('user info:');
    printWrapped(customersString!);
    getUserInfo();
  }

  getAssessmentInstructions() async {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // String auth = prefs.getString('assessmentinstructions') as String;
    // List instructionList = auth.split(",");
    // print("instructionList");

    // setState(() {
    //   instructionList = instructionsJson;
    //   print(instructionsJson);
    // });
  }

  Future<void> saveAssessmentInstructions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('assessmentinstructions', instructionsString!);
    print('inst:');
    printWrapped(instructionsString!);
    // getUserInfo();
    getAssessmentInstructions();
  }

  @override
  void dispose() {
    controller?.dispose();
    connection!.cancel();
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

  bool _searchmode = false;
  late BuildContext _context;

  // late User _loggedInUser;
  String? customersString;
  String? instructionsString;
  String? _searchString;
  String? _claimString;
  final _drivenby = TextEditingController();
  // final _make = TextEditingController();
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _year = TextEditingController();
  final _color = TextEditingController();
  final _itemDescController = TextEditingController();
  final _loanofficeremail = TextEditingController();
  // final _vehiclereg = TextEditingController();
  TextEditingController _chassisno = TextEditingController();
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
  final _remarks = TextEditingController();
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
  String? filename;
  late String otherValue1;
  late String otherValue2;
  late String otherValue3;
  late String otherValue5;
  static final double containerHeight = 170.0;
  double clipHeight = containerHeight * 0.35;
  DiagonalPosition position = DiagonalPosition.BOTTOM_LEFT;
  final size = 200.0;

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

  Future uploadmultipleassessments() async {
    for (int i = 0; i < assessmentsJson.length; i++) {
      setState() {
        assessmentsString = assessmentsJson[i];
      }
    }
    // _submit();
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
                    // String chassisno = _chasisno.text.trim();
                    // String make = _make.text.trim();
                    String vehiclecolor = _color.text.trim();
                    String engineno = _engineno.text.trim();
                    String drivenby = _drivenby.text.trim();
                    String model = _model.text.trim();
                    String type = _type.text.trim();
                    String chasisno = _chassisno.text.trim();
                    String year = _year.text.trim();
                    String regno = _vehiclereg.text.trim();
                    String dateinput = _dateinput.text;
                    String pav = _pav.text.trim();
                    String remarks = _remarks.text.trim();
                    String salvage = _salvage.text.trim();
                    String brakes = _brakes.text.trim();
                    String paintwork = _paintwork.text.trim();
                    String mileage = _mileage.text.trim();
                    String steering = _steering.text.trim();
                    String make = _make.text.trim();
                    String RHF = _RHF.text.trim();
                    String LHR = _LHR.text;
                    String RHR = _RHR.text;
                    String LHF = _LHF.text.trim();
                    String spare = _spare.text.trim();
                    String damagesobserved = _damagesobserved.text.trim();

                    print(ConnectivityResult.none != true);
                    Navigator.pop(ctx);
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);

                    dial.show();
                    dial.style(
                      message: 'Sending Assessment',
                    );
                    String demoUrl = await Config.getBaseUrl();
                    Uri url = Uri.parse(demoUrl + 'valuation/assessment/');
                    print(url);
                    int timeout = 5;

                    try {
                      setState(() {
                        assessmentsString = (jsonEncode(<String, dynamic>{
                          "userid": _userid,
                          "custid":
                              widget.custID == null ? _custId : widget.custID,
                          "revised": revised,
                          "cashinlieu": revised2,
                          "instructionno": _instructionId,
                          "driven": isOther5,
                          "drivenby": drivenby,
                          "towed": isOther6,
                          "remarks": remarks,
                          "make": make,
                          "model": model,
                          "type": type,
                          "year": year,
                          "mileage": mileage,
                          "color": vehiclecolor,
                          "engineno": engineno,
                          "chasisno": chasisno,
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
                        _addAssessments(assessmentsString);
                        saveAssessments();
                        print('saved');
                      });
                      final response = await http.post(url,
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(<String, dynamic>{
                            "userid": _userid,
                            "custid":
                                widget.custID == null ? _custId : widget.custID,
                            "revised": revised,
                            "cashinlieu": revised2,
                            "instructionno": _instructionId,
                            "driven": isOther5,
                            "drivenby": drivenby,
                            "towed": isOther6,
                            "remarks": remarks,
                            "make": make,
                            "model": model,
                            "type": type,
                            "year": year,
                            "mileage": mileage,
                            "color": vehiclecolor,
                            "engineno": engineno,
                            "chassisno": chasisno,
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

                      // printWrapped(jsonEncode(<String, dynamic>{
                      //   "userid": assessmentsString,
                      //   "custid": _custId,
                      //   "revised": revised,
                      //   "cashinlieu": revised2,
                      //   "instructionno": _instructionId,
                      //   "driven": isOther5,
                      //   "drivenby": "null",
                      //   "towed": isOther6,
                      //   "make": _make,
                      //   "model": _carmodel,
                      //   "year": year,
                      //   "mileage": mileage,
                      //   "color": vehiclecolor,
                      //   "engineno": engineno,
                      //   "chasisno": _chasisno,
                      //   "pav": pav != "" ? pav : 1,
                      //   "salvage": salvage != "" ? salvage : "0",
                      //   "brakes": brakes,
                      //   "paintwork": paintwork,
                      //   "steering": steering,
                      //   "RHF": RHF,
                      //   "LHR": LHR,
                      //   "RHR": RHR,
                      //   "LHF": LHF,
                      //   "Spare": spare,
                      //   "damagesobserved": damagesobserved,
                      //   // "photolist": newImagesList,
                      // }));
                      print('assessment json is:');
                      print(assessmentsString);

                      if (response != null) {
                        dial.hide();
                        // prefs.clear();
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
                    } on TimeoutException catch (e) {
                      print('Timeout Error: $e');
                      showAlertDialog(this.context, '$e');
                    } on SocketException catch (e) {
                      print('Socket Error: $e');
                      dial.hide();
                      showAlertDialog(this.context, '$e');
                    } on Error catch (e) {
                      showAlertDialog(this.context, '$e');
                    }
                  },
                  child: Text('Yes'))
            ],
          );
        });
  }

  _submitOffline() async {
    showDialog(
        context: this.context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Submit saved assessments?'),
            content: Text('Are you sure you want to submit'),
            actions: <Widget>[
              MaterialButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  }),
              MaterialButton(
                  onPressed: () async {
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

                    Navigator.pop(ctx);
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);
                    dial.show();
                    dial.style(
                      message: 'Sending Assessment',
                    );

                    final response = await http.post(url,
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                        },
                        body: assessmentsString);

                    // print('assessment json is:');
                    print(assessmentsString);
                    if (response != null) {
                      dial.hide();

                      int statusCode = response.statusCode;
                      if (statusCode == 200) {
                        // await prefs.clear();
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
                  child: Text('Yes'))
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
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        setState(() {
          customersJson = jsonResponse;
          customersString = customersJson.join(",");
          // saveUserInfo();
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

    URLQueryParams urlQueryParams = new URLQueryParams();
    urlQueryParams.append('custid', _custId);
    urlQueryParams.append('hrid', _hrid);
    urlQueryParams.append('typeid', '1');
    urlQueryParams.append('revised', revised);
    String qParams = urlQueryParams.toString();
    final stringurl = widget.custID == null
        ? (url +
            'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=$revised')
        : (url +
            'valuation/custinstruction/?custid=${widget.custID}&hrid=$_hrid&typeid=1&revised=$revised');

    HttpClientResponse response = await Config.getRequestObject(
      stringurl,
      Config.get,
    ).timeout(Duration(minutes: 10));
    if (response != null) {
      print(stringurl);
      print(response.compressionState);
      bool _validURL = Uri.parse(url +
              'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=$revised')
          .isAbsolute;
      print(_validURL);
      response
          .take(5)
          .transform(utf8.decoder)
          .transform(LineSplitter())
          .listen((data) {
        print(response.take(5));
        var jsonResponse = jsonDecode(data);
        print(jsonResponse);
        setState(() {
          instructionsJson = jsonResponse;
          // instructionsString = instructionsJson.join(",");
          // saveAssessmentInstructions();
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

  _fetchClaimForm() async {
    String url = await Config.getBaseUrl();

    final stringurl = widget.custID == null
        ? (url + 'valuation/claimform/$_instructionId')
        : (url + 'valuation/claimform/$_instructionId');

    http.Response response = await await http.get(Uri.parse(stringurl));
    if (response != null) {
      var jsonResponse = json.decode(response.body.toString());

     print(jsonResponse[0]["claimform"].toString());
     setState(() {
       _claimString = jsonResponse[0]["claimform"].toString();
       print(_claimString);
     });
      // response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
      //   var jsonResponse = jsonDecode(data);

      // List<String> tags = jsonResponse != null ? List.from(jsonResponse) : null;
      // print(jsonResponse);
      // var list = jsonResponse as List;
      // List<Instruction> result = list.map<Instruction>((json) {
      //   return Instruction.fromJson(json);
      // }).toList();
      // if (result.isNotEmpty) {
      //   setState(() {
      //     result.sort((a, b) => a.chassisno!
      //         .toLowerCase()
      //         .compareTo(b.chassisno!.toLowerCase()));
      //     _instruction = result;
      //     if (_instruction != null && _instruction.isNotEmpty) {
      //       _instruction.forEach((instruction) {
      //         setState(() {});
      //
      //         print(_make);
      //       });
      //     }
      //   });
      // } else {
      //   setState(() {
      //     _message = 'You have not been assigned any customers';
      //   });
      // }
      // });
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
                              // _fetchInstructions();
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
                                    widget.custID != null ||
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
                                'Create Assessment',
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
                                            widget.custID != 0 &&
                                                    widget.custID != null &&
                                                    widget.custName != 'null'
                                                ? widget.custName!
                                                : 'Select Customer',
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
                                            print(_instructionId);
                                            print(_selectedValue);
                                            print(_custName);
                                            print(_custId);
                                            print(_custPhone);
                                            _dropdownError = null;
                                          },

                                          // isCaseSensitiveSearch: true,
                                          searchHint: Text(
                                            'Select Customer',
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
                                          activeColor: Colors.blue,
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
                                        SizedBox(
                                          height: 20,
                                        ),
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
                                              "Asmt Date:",
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
                                          height: 30,
                                        ),
                                        SearchableDropdown(
                                          hint: Text(
                                            "Attach Instruction",
                                          ),

                                          isExpanded: true,
                                          onChanged: (value) {
                                            // _location = (value != null
                                            //     ? ['location']
                                            //     : null);

                                            setState(() {
                                              _selectedValue = value;
                                              // _instructionId = value != null
                                              //     ? value['id']
                                              //     : null;
                                              // _make = value != null
                                              //     ? value['make']
                                              //     : null;
                                              // _chasisno = value != null
                                              //     ? value['chassisno']
                                              //     : null;
                                              // _policyno = value != null
                                              //     ? value['policyno']
                                              //     : null;
                                              // _claimno = value != null
                                              //     ? value['claimno']
                                              //     : null;

                                              // _location = value != null
                                              //     ? value['location']
                                              //     : null;
                                              // _owner = value != null
                                              //     ? value['owner']
                                              //     : null;
                                              // _insuredvalue = value != null
                                              //     ? value['insuredvalue']
                                              //     : null;

                                              _instructionId = value != null
                                                  ? value['id']
                                                  : null;
                                              _make.text = value != null
                                                  ? value['make']
                                                  : null;
                                              _chassisno.text = value != null
                                                  ? value['chassisno']
                                                  : null;
                                              _policyno = value != null
                                                  ? value['policyno']
                                                  : null;
                                              _claimno = value != null
                                                  ? value['claimno']
                                                  : null;
                                              _model.text = value != null
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
                                              _vehiclereg.text = value != null
                                                  ? value['regno']
                                                  : null;
                                              _excess = value != null
                                                  ? value['excess']
                                                  : null;
                                              _fetchClaimForm();
                                              // _claimString = value != null
                                              //     ? value['claimform']
                                              //     : null;
                                              // _claimString =
                                              //     "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Uxro0AW3rM6qSOfabScom3lT3LZDykSPgA6DrSMzK+aXiYJB+47n7VELZFOKF1ubajy+lJLspyyIFwJCk0bKYEBcmkzAmNu9LYHBBKqYUC0a/wAaUH//2QplbmRzdHJlYW0KZW5kb2JqCjExIDAgb2JqCjI3NTA1CmVuZG9iagoxMiAwIG9iago8PAovVHlwZSAvQW5ub3QKL1N1YnR5cGUgL0xpbmsKL1JlY3QgWzM5My42MDAwMDAgIDc1OC40MDAwMDAgIDU4Ni45NzE0MjggIDc2OS4zNzE0MjggXQovQm9yZGVyIFswIDAgMF0KL0EgPDwKL1R5cGUgL0FjdGlvbgovUyAvVVJJCi9VUkkgKG1haWx0bzpsaWxpYW5qZXJpa2FtYXVAZ21haWwuY29tKQo+Pgo+PgplbmRvYmoKMTMgMCBvYmoKPDwKL1R5cGUgL0Fubm90Ci9TdWJ0eXBlIC9MaW5rCi9SZWN0IFszOTMuNjAwMDAwICA2ODcuMDg1NzE0ICA1ODYuOTcxNDI4ICA2OTguMDU3MTQyIF0KL0JvcmRlciBbMCAwIDBdCi9BIDw8Ci9UeXBlIC9BY3Rpb24KL1MgL1VSSQovVVJJIChodHRwczovL2xpbGlhbmplcmlrYW1hdS5naXRodWIuaW8vKQo+Pgo+PgplbmRvYmoKMTQgMCBvYmoKPDwKL1R5cGUgL0Fubm90Ci9TdWJ0eXBlIC9MaW5rCi9SZWN0IFszOTMuNjAwMDAwICA2NjMuMDg1NzE0ICA1ODYuOTcxNDI4ICA2NzQuMDU3MTQyIF0KL0JvcmRlciBbMCAwIDBdCi9BIDw8Ci9UeXBlIC9BY3Rpb24KL1MgL1VSSQovVVJJIChodHRwczovL3d3dy5saW5rZWRpbi5jb20vaW4vbGlsaWFuLW5qZXJpLWE2N2E0OTE0OS8pCj4+Cj4+CmVuZG9iagoxNSAwIG9iago8PAovVHlwZSAvQW5ub3QKL1N1YnR5cGUgL0xpbmsKL1JlY3QgWzM5My42MDAwMDAgIDYzOS40Mjg1NzEgIDU4Ni45NzE0MjggIDY1MC4zOTk5OTkgXQovQm9yZGVyIFswIDAgMF0KL0EgPDwKL1R5cGUgL0FjdGlvbgovUyAvVVJJCi9VUkkgKGh0dHBzOi8vZ2l0aHViLmNvbS9saWxpYW5q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dCAvVWJ1bnR1LUJvbGQKL0NJRFN5c3RlbUluZm8gPDwgL1JlZ2lzdHJ5IChBZG9iZSkgL09yZGVyaW5nIChJZGVudGl0eSkgL1N1cHBsZW1lbnQgMCA+PgovRm9udERlc2NyaXB0b3IgMjEgMCBSCi9DSURUb0dJRE1hcCAvSWRlbnRpdHkKL1cgWzAgWzQ5NiA5NDEgNzg0IDY2MiA2NzkgMjM4IDYwMSA2NjkgNjM5IDMxMyA3NTAgNjQzIDU3MCAzMTMgNTg0IDQ0MCA1NzkgNDE5IDg5MCA2MDIgNTk5IDI4NyA3MzEgNTQ1IDU5OSAzMzcgNTc3IDU0OSA0OTYgNTc0IDcwMSA3MTUgNjA5IDY2NyA1ODQgNDgxIDU4OSA1ODQgNDE5IDg1NSA1NDMgNzc4IDU1OCA1MjUgNjk3IF0KXQo+PgplbmRvYmoKMjQgMCBvYmoKPDwgL0xlbmd0aCA2NzIgPj4Kc3RyZWFtCi9DSURJbml0IC9Qcm9jU2V0IGZpbmRyZXNvdXJjZSBiZWdpbgoxMiBkaWN0IGJlZ2luCmJlZ2luY21hcAovQ0lEU3lzdGVtSW5mbyA8PCAvUmVnaXN0cnkgKEFkb2JlKSAvT3JkZXJpbmcgKFVDUykgL1N1cHBsZW1lbnQgMCA+PiBkZWYKL0NNYXBOYW1lIC9BZG9iZS1JZGVudGl0eS1VQ1MgZGVmCi9DTWFwVHlwZSAyIGRlZgoxIGJlZ2luY29kZXNwYWNlcmFuZ2UKPDAwMDA+IDxGRkZGPgplbmRjb2Rlc3BhY2VyYW5nZQoyIGJlZ2luYmZyYW5nZQo8MDAwMD4gPDAwMDA+IDwwMDAwPgo8MDAwMT4gPDAwMkM+IFs8MDA1Nz4gPDAwNEY+IDwwMDUyPiA8MDA0Qj4gPDAwMjA+IDwwMDQ1PiA8MDA1OD4gPDAwNTA+IDwwMDQ5PiA8MDA0RT4gPDAwNDM+IDwwMDQ2PiA8MDA2Qz4gPDAwNzU+IDwwMDc0PiA8MDA2NT4gPDAwNzI+IDwwMDREPiA8MDA2Rj4gPDAwNjI+IDwwMDY5PiA8MDA0ND4gPDAwNzY+IDwwMDcwPiA8MDAyRD4gPDAwNTM+IDwwMDYxPiA8MDA2Mz4gPDAwNkI+IDwwMDU1PiA8MDA0MT4gPDAwNTQ+IDwwMDQyPiA8MDA2OD4gPDAw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Y1NldCBmaW5kcmVzb3VyY2UgYmVnaW4KMTIgZGljdCBiZWdpbgpiZWdpbmNtYXAKL0NJRFN5c3RlbUluZm8gPDwgL1JlZ2lzdHJ5IChBZG9iZSkgL09yZGVyaW5nIChVQ1MpIC9TdXBwbGVtZW50IDAgPj4gZGVmCi9DTWFwTmFtZSAvQWRvYmUtSWRlbnRpdHktVUNTIGRlZgovQ01hcFR5cGUgMiBkZWYKMSBiZWdpbmNvZGVzcGFjZXJhbmdlCjwwMDAwPiA8RkZGRj4KZW5kY29kZXNwYWNlcmFuZ2UKMiBiZWdpbmJmcmFuZ2UKPDAwMDA+IDwwMDAwPiA8MDAwMD4KPDAwMDE+IDwwMDJGPiBbPDAwMzA+IDwwMDMxPiA8MDAyRj4gPDAwMzI+IDwwMDIwPiA8MDAyRD4gPDAwNTA+IDwwMDcyPiA8MDA2NT4gPDAwNzM+IDwwMDZFPiA8MDA3ND4gPDAwNDM+IDwwMDZGPiA8MDA2MT4gPDAwNjM+IDwwMDNBPiA8MDA0QT4gPDAwNjQ+IDwwMDQ2PiA8MDA3Nz4gPDAwNzk+IDwwMDJCPiA8MDAzNT4gPDAwMzQ+IDwwMDM3PiA8MDAzOT4gPDAwNkQ+IDwwMDY5PiA8MDA2Qz4gPDAwNzU+IDwwMDQwPiA8MDA2Nz4gPDAwMkU+IDwwMDRGPiA8MDA2Mj4gPDAwNzA+IDwwMDY2PiA8MDAzNj4gPEZCMDE+IDwwMDRFPiA8MDA3Nj4gPDAwNDI+IDwwMDQxPiA8MDA2OD4gPDAwNTQ+IDwwMDZCPiBdCmVuZGJmcmFuZ2UKZW5kY21hcApDTWFwTmFtZSBjdXJyZW50ZGljdCAvQ01hcCBkZWZpbmVyZXNvdXJjZSBwb3AKZW5kCmVuZAoKZW5kc3RyZWFtCmVuZG9iago4IDAgb2JqCjw8IC9UeXBlIC9Gb250Ci9TdWJ0eXBlIC9UeXBlMAovQmFzZUZvbnQgL1VidW50dS1JdGFsaWMKL0VuY29kaW5nIC9JZGVudGl0eS1ICi9EZXNjZW5kYW50Rm9udHMgWzI4IDAgUl0KL1RvVW5pY29kZSAyOSAwIFI+PgplbmRvYmoKMzEgMCBvYmoKPDwgL1R5cGUgL0ZvbnREZXNjcmlwdG9yCi9Gb250TmFtZSAvUUZCQUFBK1VidW50dS1SZWd1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Pj4Kc3RyZWFtCi9DSURJbml0IC9Qcm9jU2V0IGZpbmRyZXNvdXJjZSBiZWdpbgoxMiBkaWN0IGJlZ2luCmJlZ2luY21hcAovQ0lEU3lzdGVtSW5mbyA8PCAvUmVnaXN0cnkgKEFkb2JlKSAvT3JkZXJpbmcgKFVDUykgL1N1cHBsZW1lbnQgMCA+PiBkZWYKL0NNYXBOYW1lIC9BZG9iZS1JZGVudGl0eS1VQ1MgZGVmCi9DTWFwVHlwZSAyIGRlZgoxIGJlZ2luY29kZXNwYWNlcmFuZ2UKPDAwMDA+IDxGRkZGPgplbmRjb2Rlc3BhY2VyYW5nZQoyIGJlZ2luYmZyYW5nZQo8MDAwMD4gPDAwMDA+IDwwMDAwPgo8MDAwMT4gPDAwNDI+IFs8MDA0Qz4gPDAwNjk+IDwwMDZDPiA8MDA2MT4gPDAwNkU+IDwwMDIwPiA8MDA0Qj4gPDAwNkQ+IDwwMDc1PiA8MDA1Mz4gPDAwNkY+IDwwMDY2PiA8MDA3ND4gPDAwNzc+IDwwMDcyPiA8MDA2NT4gPDAwNDU+IDwwMDY3PiA8MDA3Qz4gPDAwNDY+IDwwMDQxPiA8MDA2ND4gPDAwNTI+IDwwMDYzPiA8MDA1ND4gPDAwNzk+IDwwMDcwPiA8MDA3Mz4gPDAwNDg+IDwwMDY4PiA8MDAyQz4gPDAwNDk+IDwwMDMzPiA8MDA3OD4gPDAwNzY+IDwwMDYyPiA8MDA0RD4gPDAwNTc+IDwwMDUwPiA8MDA0ND4gPDAwNEY+IDwwMDJFPiA8MDAyRD4gPDAwNkE+IDwwMDZCPiA8MDA0MD4gPDAwMzA+IDwwMDM3PiA8MDAzMT4gPDAwMzQ+IDwwMDM1PiA8MDA0RT4gPDAwMkY+IDwwMDM2PiA8MDAzOT4gPDAwNDI+IDwwMDcxPiA8MDA1NT4gPDAwNDM+IDwwMDdBPiA8MDA0QT4gPEZCMDE+IDwwMDU4PiA8MDAyOD4gPDAwMzI+IDwwMDI5PiBdCmVuZGJmcmFuZ2UKZW5kY21hcApDTWFwTmFtZSBjdXJyZW50ZGljdCAvQ01hcCBkZWZpbmVyZXNvdXJjZSBwb3AKZW5kCmVuZAoKZW5kc3RyZWFtCmVuZG9iago2IDAgb2JqCjw8IC9UeXBlIC9Gb250Ci9TdWJ0eXBlIC9UeXBlMAovQmFzZUZvbnQgL1VidW50dS1SZWd1bGFyCi9FbmNvZGluZyAvSWRlbnRpdHktSAovRGVzY2VuZGFudEZvbnRzIFszMyAwIFJdCi9Ub1VuaWNvZGUgMzQgMCBSPj4KZW5kb2JqCjIgMCBvYmoKPDwKL1R5cGUgL1BhZ2VzCi9LaWRzIApbCjUgMCBSCl0KL0NvdW50IDEKL1Byb2NTZXQgWy9QREYgL1RleHQgL0ltYWdlQiAvSW1hZ2VDXQo+PgplbmRvYmoKeHJlZgowIDM2CjAwMDAwMDAwMDAgNjU1MzUgZiAKMDAwMDAwMDAwOSAwMDAwMCBuIAowMDAwMDc2NTk0IDAwMDAwIG4gCjAwMDAwMDAxNjMgMDAwMDAgbiAKMDAwMDAwMDI1OCAwMDAwMCBuIAowMDAwMDI4ODczIDAwMDAwIG4gCjAwMDAwNzY0NTQgMDAwMDAgbiAKMDAwMDA1OTU2MCAwMDAwMCBuIAowMDAwMDY3Mjk4IDAwMDAwIG4gCjAwMDAwMDAyOTUgMDAwMDAgbiAKMDAwMDAwMDMzMCAwMDAwMCBuIAowMDAwMDI4MDA2IDAwMDAwIG4gCjAwMDAwMjgwMjggMDAwMDAgbiAKMDAwMDAyODIyMSAwMDAwMCBuIAowMDAwMDI4NDE2IDAwMDAwIG4gCjAwMDAwMjg2MjggMDAwMDAgbiAKMDAwMDAyODgyMyAwMDAwMCBuIAowMDAwMDI5MjU2IDAwMDAwIG4gCjAwMDAwNTMwNTQgMDAwMDAgbiAKMDAwMDAyODk5NCAwMDAwMCBuIAowMDAwMDI5MjA4IDAwMDAwIG4gCjAwMDAwNTMwNzYgMDAwMDAgbiAKMDAwMDA1MzI4MiAwMDAwMCBuIAowMDAwMDU4NDQ1IDAwMDAwIG4gCjAwMDAwNTg4MzYgMDAwMDAgbiAKMDAwMDA1ODQyNCAwMDAwMCBuIAowMDAwMDU5Njk3IDAwMDAwIG4gCjAwMDAwNTk5MDQgMDAwMDAgbiAKMDAwMDA2NjE0OCAwMDAwMCBuIAowMDAwMDY2NTUzIDAwMDAwIG4gCjAwMDAwNjYxMjcgMDAwMDAgbiAKMDAwMDA2NzQzNyAwMDAwMCBuIAowMDAwMDY3NjQ1IDAwMDAwIG4gCjAwMDAwNzUwOTQgMDAwMDAgbiAKMDAwMDA3NTU3NiAwMDAwMCBuIAowMDAwMDc1MDczIDAwMDAwIG4gCnRyYWlsZXIKPDwKL1NpemUgMzYKL0luZm8gMSAwIFIKL1Jvb3QgMTYgMCBSCj4+CnN0YXJ0eHJlZgo3NjY5MgolJUVPRgo=";
                                              // print('claim form is');
                                              print(_claimString == String);
                                              // _fetchInstructions();
                                            });
                                            print(_instructionId);
                                            // print(_custName);
                                            // print(_custId);
                                            // print(_custPhone);
                                            _dropdownError = null;
                                          },

                                          // isCaseSensitiveSearch: true,
                                          searchHint: Text(
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
                                      InkWell(
                                        onTap: () {
                                          _claimString != ""
                                              ? createPdf()
                                              : Fluttertoast.showToast(
                                                  msg:
                                                      'No claim form attached');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Claim Form',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Icon(
                                              Icons.attach_file,
                                              color: Colors.blue,
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _vehiclereg,
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {vehicleColor},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Reg No."),
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
                                        initialValue: _insuredvalue.toString(),
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _chassisno,
                                        onSaved: (value) => {engineNo},
                                        style: TextStyle(color: Colors.blue),
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        style: TextStyle(color: Colors.blue),
                                        controller: _make,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            InputDecoration(hintText: "Make"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Model	",
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
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _model,
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            InputDecoration(hintText: "Model"),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Type",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _type,
                                        style: TextStyle(color: Colors.blue),
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            InputDecoration(hintText: "Type"),
                                      ),
                                      SizedBox(
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
                                        activeColor: Colors.blue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isOther5 = value!;
                                            isOther6 = !isOther6;
                                          });
                                        },
                                      ),
                                      SizedBox(
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
                                        activeColor: Colors.blue,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isOther6 = value!;
                                            isOther5 = !isOther5;
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
                                      left: 20, right: 20, top: 30, bottom: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Year of manufucture",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _year,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(hintText: "Year"),
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                                .copyWith(color: Colors.blue),
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
                                                .copyWith(color: Colors.blue),
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
                                        decoration:
                                            InputDecoration(hintText: "Color"),
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
                                                .copyWith(color: Colors.blue),
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
                                        decoration: InputDecoration(
                                            hintText: "Engine No."),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Driven By",
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _drivenby,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Driven By"),
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _pav,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(hintText: "P.A.V"),
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
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
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _brakes,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            InputDecoration(hintText: "Brakes"),
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
                                        height: 30,
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
                                                .copyWith(color: Colors.blue),
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
                                                .copyWith(color: Colors.blue),
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
                                                .copyWith(color: Colors.blue),
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
                                                .copyWith(color: Colors.blue),
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
                                                .copyWith(color: Colors.blue),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _spare,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: "Spare"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Remarks",
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
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: _remarks,
                                              onSaved: (value) => {engineNo},
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                  hintText: "Remarks"),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
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
                                            const SizedBox(
                                              width: 200,
                                            ),
                                            const Icon(
                                              Icons.camera_enhance,
                                              color: Colors.blue,
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
            backgroundColor: Colors.black,
            body: _isCameraPermissionGranted
                ? _isCameraInitialized
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SingleChildScrollView(
                              child: AspectRatio(
                                aspectRatio: 1 / controller!.value.aspectRatio,
                                child: Stack(
                                  children: [
                                    CameraPreview(
                                      controller!,
                                      child: LayoutBuilder(builder:
                                          (BuildContext context,
                                              BoxConstraints constraints) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTapDown: (details) =>
                                              onViewFinderTap(
                                                  details, constraints),
                                        );
                                      }),
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8.0,
                                                ),
                                                child: DropdownButton<
                                                    ResolutionPreset>(
                                                  dropdownColor: Colors.black87,
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
                                                              color:
                                                                  Colors.white),
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
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  _currentExposureOffset
                                                          .toStringAsFixed(1) +
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
                                                  value: _currentExposureOffset,
                                                  min:
                                                      _minAvailableExposureOffset,
                                                  max:
                                                      _maxAvailableExposureOffset,
                                                  activeColor: Colors.white,
                                                  inactiveColor: Colors.white30,
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
                                                  inactiveColor: Colors.white30,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      _currentZoomLevel = value;
                                                    });
                                                    await controller!
                                                        .setZoomLevel(value);
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
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
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
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
                                                    builder:
                                                        (BuildContext context) {
                                                      return _SystemPadding(
                                                        child: AlertDialog(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          content: Row(
                                                            children: <Widget>[
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
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                            TextButton(
                                                                child:
                                                                    const Text(
                                                                        'OKAY'),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(() {
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
                                                              : Colors.white38,
                                                      size: 80,
                                                    ),
                                                    Icon(
                                                      Icons.circle,
                                                      color:
                                                          _isVideoCameraSelected
                                                              ? Colors.blue
                                                              : Colors.white,
                                                      size: 65,
                                                    ),
                                                    _isVideoCameraSelected &&
                                                            _isRecordingInProgress
                                                        ? Icon(
                                                            Icons.stop_rounded,
                                                            color: Colors.white,
                                                            size: 32,
                                                          )
                                                        : Container(),
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: image != null
                                                    ? () {
                                                        // Navigator.of(context)
                                                        //     .push(
                                                        //   MaterialPageRoute(
                                                        //     builder: (context) =>
                                                        //         PreviewScreen(
                                                        //       image: image!,
                                                        //       fileList:
                                                        //           imageslist,
                                                        //     ),
                                                        //   ),
                                                        // );
                                                      }
                                                    : null,
                                                child: Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                    image: image != null
                                                        ? DecorationImage(
                                                            image: FileImage(
                                                              File(image!.path),
                                                            ),
                                                            fit: BoxFit.cover,
                                                          )
                                                        : null,
                                                  ),
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8.0, 16.0, 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

  void _addAssessments(String? assessmentsString) {
    assessmentsJson.add(assessmentsString!);
    saveAssessments();
  }
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
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
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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
