import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:motorassesmentapp/screens/create_assesment.dart';
import 'package:motorassesmentapp/screens/save_valuations.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:motorassesmentapp/models/valuation_model.dart';
import '../database/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/imagesmodels.dart';
import 'package:motorassesmentapp/models/instructionmodels.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/screens/create_instruction.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:motorassesmentapp/utils/network_handler.dart';
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
import 'package:gallery_saver/gallery_saver.dart';
import '../main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CreateValuation extends StatefulWidget {
  int? custID;
  String? custName;

  CreateValuation({Key? key, this.custID, this.custName}) : super(key: key);

  @override
  State<CreateValuation> createState() => _CreateValuationState();
}

class _CreateValuationState extends State<CreateValuation> {
  late User _loggedInUser;
  DBHelper dbHelper = DBHelper();
  int? index;
 late Random random ;
  int? _userid;
  int? _custid;
  int? _custId;
  int? _hrid;
  int? _instructionId;
  int? _fleetId;
  int? transmissionid;
  int? drivetypeid;
  String? _policyno;
  String? _chasisno;
  String? _vehiclereg;
  String? _carmodel;
  String? _location;
  String? _claimno;
  int? _insuredvalue;
  String? _excess;
  String? _owner;
  String? valuationString;
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
  double? loadcapacity;
  bool isInstructionSelected = false;
  String? remarks;
  String? installationLocation;
  List<Customer> _customers = [];
  int? customerid;
  bool alloy = false;
  bool alarm = false;
  bool radiocassette = false;
  bool cdplayer = false;
  bool cdchanger = false;
  bool roadworthy = false;
  bool validinsurance = false;
  bool centrallocking = false;
  bool powerwindowsrhf = false;
  bool powerwindowslhf = false;
  bool powerwindowsrhr = false;
  bool powerwindowslhr = false;
  bool powermirrors = false;
  bool powersteering = false;
  bool airconditioner = false;
  bool absbrakes = false;
  bool foglights = false;
  bool roofrails = false;
  bool rearspoiler = false;
  bool sidesteps = false;
  bool sunroof = false;
  bool frontgrilleguard = false;
  bool rearbumperguard = false;
  bool sparewheelcover = false;
  bool seatcovers = false;
  bool turbotimer = false;
  bool dashboardairbag = false;
  bool steeringairbag = false;
  bool alloyrims = false;
  bool steelrims = false;
  bool chromerims = false;
  bool xenonheadlights = false;
  bool suspensionspacers = false;
  bool heightadjustmentsystem = false;
  bool powerslidingrhfdoor = false;
  bool powerslidinglhfdoor = false;
  bool powerslidingrhrdoor = false;
  bool powerslidinglhrdoor = false;
  bool powerbootdoor = false;
  bool uphostryleatherseat = false;
  bool uphostryfabricseat = false;
  bool uphostrytwotoneseat = false;
  bool uphostrybucketseat = false;
  bool powerseatrhfadjustment = false;
  bool powerseatlhfadjustment = false;
  bool powerseatrhradjustment = false;
  bool powerseatlhradjustment = false;
  bool powersteeringadjustment = false;
  bool extralargerims = false;
  bool crackedrearwindscreen = false;
  bool inbuiltcassette = false;
  bool inbuiltcd = false;
  bool inbuiltdvd = false;
  bool inbuiltmapreader = false;
  bool inbuilthddcardreader = false;
  bool inbuiltminidisc = false;
  bool inbuiltusb = false;
  bool inbuiltbluetooth = false;
  bool inbuilttvscreen = false;
  bool inbuiltcdchanger = false;
  bool inbuiltsecuritydoorlock = false;
  bool inbuiltalarm = false;
  bool inbuiltimmobilizer = false;
  bool keylessignition = false;
  bool trackingdevice = false;
  bool gearleverlock = false;
  bool enginecutoff = false;
  bool musicsystemdetachable = false;
  bool musicsysteminbuilt = false;
  bool fittedwithamfmonly = false;
  bool fittedwithreversecamera = false;
  bool amfmonly = false;
  bool locallyfittedalarm = false;
  bool roofcarrier = false;
  bool uphostryfabricleatherseat = false;
  bool dutypaid = false;
  bool crawleeexcavator = false;
  bool backhoewheelloader = false;
  bool roller = false;
  bool fixedcrane = false;
  bool rollercrane = false;
  bool mobilecrane = false;
  bool hiabfittedcranetruck = false;
  bool primemover = false;
  bool primemoverfilledwithrailercrane = false;
  bool lowloadertrailer = false;
  bool concretemixer = false;
  bool topmacrollers = false;
  bool aircompressor = false;
  bool forklift = false;
  bool specialpurposeconstructionmachinery = false;
  bool batterypoweredlift = false;
  bool batterypoweredscissorlift = false;
  bool boomlift = false;
  bool dumptruck = false;
  bool backheeloader = false;
  bool vaccumpumpsystem = false;
  bool dryaircompressor = false;
  bool transformeroilpurifizatonplant = false;
  bool dieselgenerator = false;
  bool platecompactor = false;
  bool twindrumroller = false;
  bool tractors = false;
  bool plaughs = false;
  bool seeders = false;
  bool combineharvester = false;
  bool sprayers = false;
  bool culters = false;
  bool balers = false;
  bool ordinaryfueltankers = false;
  bool watertanker = false;
  bool exhauster = false;
  bool specializedfueltanker = false;
  bool opensidebody = false;
  bool closedsidebody = false;
  bool trailers = false;
  bool fuseboxbypassed = false;
  bool turbocharger = false;
  bool lightfitted = false;
  bool lightfittedok = false;
  bool dipswitchok = false;
  bool lightdipok = false;
  bool rearlightclean = false;
  bool handbrakeok = false;
  bool hydraulicsystemok = false;
  bool servook = false;
  bool handbreakmarginok = false;
  bool footbreakmarginok = false;
  bool balljointsok = false;
  bool jointsstatus = false;
  bool wheelalignment = false;
  bool wheelbalanced = false;
  bool chassisok = false;
  bool fuelpumptank = false;
  bool antitheftdevicefitted = false;
  bool vehiclefit = false;
  bool vehicleconformrules = false;
  bool speedgovernorfitted = false;
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
  final _drivenby = TextEditingController();
  TextEditingController _searchController = new TextEditingController();
  TextEditingController _noofbatteries = new TextEditingController();
  TextEditingController _handdrivetype = new TextEditingController();
  TextEditingController _turbochargerdesc = new TextEditingController();
  TextEditingController _footbreakok = new TextEditingController();
  TextEditingController _frontnearside1 = new TextEditingController();
  TextEditingController _frontoffside1 = new TextEditingController();
  TextEditingController _rearnearside1 = new TextEditingController();
  TextEditingController _rearnearsideouter1 = new TextEditingController();
  TextEditingController _rearoffsideinner1 = new TextEditingController();
  TextEditingController _rearoffsideouter1 = new TextEditingController();
  TextEditingController _sparetyre1 = new TextEditingController();
  TextEditingController _frontnearside2 = new TextEditingController();
  TextEditingController _frontoffside2 = new TextEditingController();
  TextEditingController _rearnearside2 = new TextEditingController();
  TextEditingController _rearnearsideouter2 = new TextEditingController();
  TextEditingController _rearoffsideinner2 = new TextEditingController();
  TextEditingController _rearoffsideouter2 = new TextEditingController();
  TextEditingController _sparetyre2 = new TextEditingController();
  TextEditingController _steeringboxstatus = new TextEditingController();
  TextEditingController _jointsdefect = new TextEditingController();
  TextEditingController _bodyworkok = new TextEditingController();
  TextEditingController _repairgoodstandard = new TextEditingController();
  TextEditingController _windscreendoor = new TextEditingController();
  TextEditingController _antitheftdevicedesc = new TextEditingController();
  TextEditingController _seatingcapacity = new TextEditingController();
  final _year = TextEditingController();
  final _color = TextEditingController();
  final _itemDescController = TextEditingController();
  final _logBookDescController = TextEditingController();
  final _loanofficeremail = TextEditingController();
  // final _vehiclereg = TextEditingController();
  TextEditingController _chassisno = TextEditingController();
  final _transmission = TextEditingController();
  final _drivetype = TextEditingController();
  final _logbookno = TextEditingController();
  final _endorsement = TextEditingController();
  final _lbookowner = TextEditingController();
  final _loadcapacity = TextEditingController();
  final _noofowners = TextEditingController();
  final _bodytype = TextEditingController();
  final _enginecap = TextEditingController();
  final _poi = TextEditingController();
  final _fuelby = TextEditingController();
  final _country = TextEditingController();
  final _classofuse = TextEditingController();
  final _rimsize = TextEditingController();
  TextEditingController _model = TextEditingController();
  final _mileage = TextEditingController();
  final _engineno = TextEditingController();
  TextEditingController _make = TextEditingController();
  // final _chasisno = TextEditingController();
  final _pav = TextEditingController();
  final _salvage = TextEditingController();
  final _brakes = TextEditingController();
  final _roadworthynotes = TextEditingController();
  // final _customerid = TextEditingController();
  final _steering = TextEditingController();
  final _noofextracurtains = TextEditingController();
  final _noofextraseats = TextEditingController();
  final _frontwindscreen = TextEditingController();
  final _rearwindscreen = TextEditingController();
  final _doors = TextEditingController();
  final _crackedrearwindscreen = TextEditingController();
  final _approxmatewindscreenvalue = TextEditingController();
  final _rearwindscreenvalue = TextEditingController();
  final _musicsystemmodel = TextEditingController();
  final _musicsystemmake = TextEditingController();

  final _registrationdate = TextEditingController();
  final _anyothervehiclefeature = TextEditingController();
  final _noofdiscs = TextEditingController();
  final _anyothermusicsystem = TextEditingController();
  final _yombelts = TextEditingController();
  final _fromanyotherplace = TextEditingController();
  final _vinplatedetails = TextEditingController();
  final _anyotherextrafeature = TextEditingController();
  final _injectiontype = TextEditingController();
  final _noofcylinders = TextEditingController();
  final _musicsystemval = TextEditingController();
  final _RHF = TextEditingController();
  final _LHR = TextEditingController();
  final _LHF = TextEditingController();
  final _RHR = TextEditingController();
  final _paintwork = TextEditingController();
  final _spare = TextEditingController();
  final _damagesobserved = TextEditingController();
  final _deliveredby = TextEditingController();
  final _mechanicalcondition = TextEditingController();
  final _sparewheelsize = TextEditingController();
  final _origin = TextEditingController();
  final _bodycondition = TextEditingController();
  final _tyres = TextEditingController();
  final _generalcondition = TextEditingController();
  final _extras = TextEditingController();
  final _notes = TextEditingController();
  final _windscreenvalue = TextEditingController();
  final _antitheftvalue = TextEditingController();
  final _valuer = TextEditingController();
  TextEditingController _reg = TextEditingController();
  TextEditingController _transmissionspeed = TextEditingController();
  final _assessedvalue = TextEditingController();
  final _sparewheel = TextEditingController();
  final _tyresize = TextEditingController();
  final _antitheftmake = TextEditingController();
  final _anyotherantitheftfeature = TextEditingController();
  final _noofdoorairbags = TextEditingController();
  final _noofextrakneebags = TextEditingController();

  TextEditingController _dateinput = TextEditingController();
  Images? images;
  Images? logbooks;
  String? _claimString;
  List<Map<String, dynamic>>? newImagesList;
  List<Map<String, dynamic>>? newLogBookList;
  List<Images>? newList = [];
  List<Images>? newLogbookList = [];
  List<Images>? newimages = [];
  List<Instruction> _instruction = [];
  _checkIfInstructionIsSelected() {
    isInstructionSelected = !isInstructionSelected;
  }

  var items = [
    'LPG propelled',
    'LPG/liquid fuel',
    'electric/liquid fuel(hybrid)',
    'Fuel-petrol',
    'Fuel-disel',
  ];
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

  Future uploadmultipleimage() async {
    for (int i = 0; i < newList!.length; i++) {
      print(newList![i].filename);
      newImagesList = newList!.map((e) {
        return {"filename": e.filename, "attachment": e.attachment};
      }).toList();
      print(newImagesList);
    }
    for (int i = 0; i < newLogbookList!.length; i++) {
      print(newLogbookList![i].filename);
      newLogBookList = newLogbookList!.map((e) {
        return {"filename": e.filename, "attachment": e.attachment};
      }).toList();
      print(newImagesList);
    }
    // _submit();
  }

  createPdf() async {
    var bytes = base64Decode(_claimString!.replaceAll('\n', ''));

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

  void _addLogBookDescription(String description) {
    setState(() {
      logbooknames!.add(description);
    });
  }

  void _addLogBookImage(XFile image) {
    setState(() {
      logbooklist!.add(image);
    });
  }

  void _addLogBookImages(Images images) {
    setState(() {
      newLogbookList!.add(images);
      print(newLogbookList);
      uploadmultipleimage();
    });
  }

  void _addDescription(String description) {
    setState(() {
      filenames!.add(description);
    });
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
                    // log(images.toString());
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);
                    dial.style(
                      message: 'Sending Valuation',
                    );

                    String origin = _origin.text.trim();

                    String fuelby = _fuelby.text.trim();
                    String year = _year.text.trim();
                    String bodytype = _bodytype.text;
                    String mileage = _mileage.text.trim();
                    String model = _model.text.trim();
                    String enginecap = _enginecap.text.trim();
                    String chasisno = _chassisno.text.trim();
                    String windscreenvalue = _windscreenvalue.text.trim();
                    String antitheftvalue = _antitheftvalue.text.trim();
                    String mechanicalcondition =
                        _mechanicalcondition.text.trim();
                    String sparewheelsize =
                    _sparewheelsize.text.trim();
                    String valuer = _valuer.text;
                    int noofbatteries = int.parse(_noofbatteries.text.trim());


                    String assessedvalue = _assessedvalue.text.trim();
                    String rimsize = _rimsize.text.trim();
                    String sparewheel = _sparewheel.text.trim();
                    String tyresize = _tyresize.text.trim();
                    String reg = _reg.text.trim();
                    String engineno = _engineno.text.trim();

                    String remarks = _remarks.text.trim();
                    String inspectionplace = _poi.text.trim();
                    String dateinput = _dateinput.text;

                    String bodycondition = _bodycondition.text.trim();
                    String tyres = _tyres.text.trim();
                    String generalcondition = _generalcondition.text;
                    String extras = _extras.text.trim();
                    String musicsystemval = _musicsystemval.text.trim();
                    String notes = _notes.text.trim();
                    String make = _make.text.trim();
                    String noofextracurtains = _noofextracurtains.text.trim();
                    String noofextraseats = _noofextraseats.text.trim();
                    String noofextrakneebags = _noofextrakneebags.text.trim();
                    String frontwindscreen = _frontwindscreen.text;
                    String rearwindscreen = _rearwindscreen.text.trim();
                    String doors = _doors.text.trim();
                    String approxmatewindscreenvalue =
                        _approxmatewindscreenvalue.text.trim();
                    String rearwindscreenvalue =
                        _rearwindscreenvalue.text.trim();
                    String musicsystemmodel = _musicsystemmodel.text;
                    String musicsystemmake = _musicsystemmake.text.trim();
                    String antitheftmake = _antitheftmake.text.trim();
                    String color = _color.text.trim();
                    String anyotherantitheftfeature =
                        _anyotherantitheftfeature.text.trim();
                    String anyotherextrafeature =
                        _anyotherextrafeature.text.trim();
                    String roadworthynotes = _roadworthynotes.text.trim();
                    String noofdoorairbags = _noofdoorairbags.text.trim();
                    String anyothervehiclefeature =
                        _anyothervehiclefeature.text.trim();
                    String registrationdate = _registrationdate.text.trim();

                    String noofdiscs = _noofdiscs.text.trim();
                    String anyothermusicsystem = _anyothermusicsystem.text;
                    String yombelts = _yombelts.text.trim();
                    String fromanyotherplace = _fromanyotherplace.text.trim();
                    // String noofdiscs = _noofdiscs.text.trim();
                    String vinplatedetails = _vinplatedetails.text.trim();
                    String seatingcapacity = _seatingcapacity.text.trim();
                    var doubleseatingcapacity = double.parse(seatingcapacity);
                    String injectiontype = _injectiontype.text.trim();
                    String noofcylinders = _noofcylinders.text.trim();
                    String handdrivetype = _handdrivetype.text.trim();
                    String transmissionspeed =_transmissionspeed.text.trim();
                    String turbochargerdesc = _turbochargerdesc.text.trim();
                    String footbreakok = _footbreakok.text.trim();
                    String frontnearside1 = _frontnearside1.text.trim();
                    String frontoffside1 = _frontoffside1.text.trim();
                    String rearnearside1 = _rearnearside1.text.trim();
                    String rearnearsideouter1 = _rearnearsideouter1.text.trim();
                    String rearoffsideinner1 = _rearoffsideinner1.text.trim();
                    String rearoffsideouter1 = _rearoffsideouter1.text.trim();
                    String sparetyre1 = _sparetyre1.text.trim();
                    String frontnearside2 = _frontnearside2.text.trim();
                    String frontoffside2 = _frontoffside2.text.trim();
                    String rearnearside2 = _rearnearside2.text.trim();
                    String rearnearsideouter2 = _rearnearsideouter2.text.trim();
                    String rearoffsideinner2 = _rearoffsideinner2.text.trim();
                    String rearoffsideouter2 = _rearoffsideouter2.text.trim();
                    String sparetyre2 = _sparetyre2.text.trim();
                    String steeringboxstatus = _steeringboxstatus.text.trim();
                    String jointsdefect = _jointsdefect.text.trim();
                    String bodyworkok = _bodyworkok.text.trim();
                    String repairgoodstandard = _repairgoodstandard.text.trim();
                    String windscreendoor = _windscreendoor.text.trim();
                    String antitheftdevicedesc =
                        _antitheftdevicedesc.text.trim();
                    String loadcapacity = _loadcapacity.text.trim();
                    var intloadcapacity = int.parse(loadcapacity);
                    String demoUrl = await Config.getBaseUrl();
                    Uri url = Uri.parse(demoUrl + 'valuation/valuation/');
                    print(url);
                    setState(() {
                      valuationString = (jsonEncode(<String, dynamic>{
                        "userid": _userid,
                        "custid":
                        widget.custID == null ? _custId : widget.custID,
                        "revised": revised,
                        "fleetinstructionno": _fleetId,
                        "instructionno": _instructionId,
                        "photolist": newImagesList,
                        "logbooklist": newLogBookList,
                        "model": _carmodel != null ? _carmodel : model,
                        "chassisno": _chasisno != null ? _chasisno : chasisno,
                        "fuel": _selectedFuel,
                        "manufactureyear": year,
                        "origin": origin,
                        "bodytype": bodytype,
                        "mileage": mileage,
                        "enginecapacity": enginecap,
                        "engineno": engineno,
                        "make": make,
                        "type": "",
                        "sparewheelsize":sparewheelsize,
                        "inspectionplace": inspectionplace,
                        "musicsystemvalue":
                        musicsystemval != "" ? musicsystemval : "0",
                        "alloy": alloy,
                        "regno": _vehiclereg != null ? _vehiclereg : reg,
                        "location": _location,
                        "suspensionspacers": true,
                        "noofdiscs": "three",
                        "registrationdate": registrationdate,
                        "radiocassette": radiocassette,
                        "cdplayer": cdplayer,
                        "cdchanger": cdchanger,
                        "roadworthy": roadworthy,
                        "transmissionspeed":transmissionspeed,
                        "vehicletype":drivetypeid,
                        "transmissiontype":transmissionid,
                        // "alarm": alarm,
                        "roadworthynotes": roadworthynotes,
                        // "alarmtype": alarmtype,
                        // "discs": discs,
                        "validinsurance": validinsurance,
                        "mechanicalcondition": mechanicalcondition,
                        "bodycondition": bodycondition,
                        "tyres": tyres,
                        "generalcondition": generalcondition,
                        "extras": extras,
                        "notes": notes,
                        "windscreenvalue": windscreenvalue,
                        "antitheftvalue": antitheftvalue,
                        "valuer": valuer,
                        "assessedvalue": assessedvalue,
                        "sparewheel": sparewheel,
                        "tyresize": tyresize,
                        "centrallocking": centrallocking,
                        "powerwindowsrhf": powerwindowsrhf,
                        "powerwindowslhf": powerwindowslhf,
                        "powerwindowsrhr": powerwindowsrhr,
                        "powerwindowslhr": powerwindowslhr,
                        "powermirrors": powermirrors,
                        "powersteering": powersteering,
                        "airconditioner": airconditioner,
                        "absbrakes": absbrakes,
                        "foglights": foglights,
                        "rearspoiler": rearspoiler,
                        "sidesteps": sidesteps,
                        "sunroof": sunroof,
                        "frontgrilleguard": frontgrilleguard,
                        "rearbumperguard": rearbumperguard,
                        "sparewheelcover": sparewheelcover,
                        "seatcovers": seatcovers,
                        "turbotimer": turbotimer,
                        "dashboardairbag": dashboardairbag,
                        "steeringairbag": steeringairbag,
                        "alloyrims": alloyrims,
                        "steelrims": steelrims,
                        "chromerims": chromerims,
                        "assessedvalue": 1,
                        "xenonheadlights": xenonheadlights,
                        "heightadjustmentsystem": heightadjustmentsystem,
                        "powerslidingrhfdoor": powerslidingrhfdoor,
                        "powerslidinglhfdoor": powerslidinglhfdoor,
                        "powerslidingrhrdoor": powerslidingrhrdoor,
                        "powerslidinglhrdoor": powerslidinglhrdoor,
                        "powerbootdoor": powerbootdoor,
                        "uphostryleatherseat": uphostryleatherseat,
                        "uphostryfabricseat": uphostryfabricseat,
                        "uphostrytwotoneseat": uphostrytwotoneseat,
                        "uphostrybucketseat": uphostrybucketseat,
                        "powerseatrhfadjustment": powerseatrhfadjustment,
                        "powerseatlhfadjustment": powerseatlhfadjustment,
                        "powerseatrhradjustment": powerseatrhradjustment,
                        "powersteeringadjustment": powersteeringadjustment,
                        "powerseatlhradjustment": powerseatlhradjustment,
                        "extralargerims": extralargerims,
                        "rimsize": rimsize,
                        "noofextracurtains":
                        noofextracurtains != "" ? noofextracurtains : "0",
                        "noofextraseats":
                        noofextraseats != "" ? noofextraseats : "0",
                        "noofextrakneebags":
                        noofextrakneebags != "" ? noofextrakneebags : "0",
                        "frontwindscreen":
                        frontwindscreen != "" ? frontwindscreen : "none",
                        "rearwindscreen":
                        rearwindscreen != "" ? rearwindscreen : "none",
                        "doors": doors,
                        "crackedrearwindscreen": crackedrearwindscreen,
                        "approxmatewindscreenvalue": 878.08,
                        "rearwindscreenvalue": 878.08,
                        "musicsystemmodel": musicsystemmodel,
                        "musicsystemmake": musicsystemmake,
                        "inbuiltcassette": inbuiltcassette,
                        "inbuiltcd": inbuiltcd,
                        "inbuiltdvd": inbuiltdvd,
                        "inbuiltmapreader": inbuiltmapreader,
                        "inbuilthddcardreader": inbuilthddcardreader,
                        "inbuiltminidisc": inbuiltminidisc,
                        "inbuiltusb": inbuiltusb,
                        "inbuiltbluetooth": inbuiltbluetooth,
                        "inbuilttvscreen": inbuilttvscreen,
                        "inbuiltcdchanger": inbuiltcdchanger,
                        "inbuiltsecuritydoorlock": inbuiltsecuritydoorlock,
                        "inbuiltalarm": inbuiltalarm,
                        "inbuiltimmobilizer": inbuiltimmobilizer,
                        "keylessignition": keylessignition,
                        "trackingdevice": trackingdevice,
                        "gearleverlock": gearleverlock,
                        "enginecutoff": enginecutoff,
                        "anyotherantitheftfeature":
                        anyotherantitheftfeature != ""
                            ? anyotherantitheftfeature
                            : "none",
                        "anyotherextrafeature": anyotherextrafeature != ""
                            ? anyotherextrafeature
                            : "none",
                        "anyothervehiclefeature": anyothervehiclefeature,
                        "anyotheraddedfeature": "fcfccf",
                        "anyothermusicsystem": anyothermusicsystem != ""
                            ? anyothermusicsystem
                            : "none",
                        "noofdoorairbags":
                        noofdoorairbags != "" ? noofdoorairbags : "0",
                        "musicsystemdetachable": musicsystemdetachable,
                        "musicsysteminbuilt": musicsysteminbuilt,
                        "fittedwithamfmonly": fittedwithamfmonly,
                        "fittedwithreversecamera": fittedwithreversecamera,
                        "amfmonly": amfmonly,
                        "locallyfittedalarm": locallyfittedalarm,
                        "antitheftmake": antitheftmake,
                        "roofcarrier": roofcarrier,
                        "roofrails": true,
                        "uphostryfabricleatherseat":
                        uphostryfabricleatherseat,
                        "dutypaid": dutypaid,
                        "color": color,
                        // new features
                        "noofbattery": noofbatteries,
                        "crawleeexcavator": crawleeexcavator,
                        "backhoewheelloader": backhoewheelloader,
                        "roller": roller,
                        "fixedcrane": fixedcrane,
                        "rollercrane": rollercrane,
                        "mobilecrane": mobilecrane,
                        "hiabfittedcranetruck": hiabfittedcranetruck,
                        "primemover": primemover,
                        "primemoverfilledwithrailercrane":
                        primemoverfilledwithrailercrane,
                        "lowloadertrailer": lowloadertrailer,
                        "concretemixer": concretemixer,
                        "topmacrollers": topmacrollers,
                        "aircompressor": aircompressor,
                        "forklift": forklift,
                        "specialpurposeconstructionmachinery":
                        specialpurposeconstructionmachinery,
                        "batterypoweredlift": batterypoweredlift,
                        "batterypoweredscissorlift":
                        batterypoweredscissorlift,
                        "boomlift": boomlift,
                        "dumptruck": dumptruck,
                        "backheeloader": backheeloader,
                        "vaccumpumpsystem": vaccumpumpsystem,
                        "dryaircompressor": dryaircompressor,
                        "transformeroilpurifizatonplant":
                        transformeroilpurifizatonplant,
                        "dieselgenerator": dieselgenerator,
                        "platecompactor": platecompactor,
                        "twindrumroller": twindrumroller,
                        "tractors": tractors,
                        "plaughs": plaughs,
                        "seeders": seeders,
                        "combineharvester": combineharvester,
                        "sprayers": sprayers,
                        "culters": culters,
                        "balers": balers,
                        "ordinaryfueltankers": ordinaryfueltankers,
                        "watertanker": watertanker,
                        "exhauster": exhauster,
                        "specializedfueltanker": specializedfueltanker,
                        "opensidebody": opensidebody,
                        "closedsidebody": closedsidebody,
                        "trailers": trailers,
                        "fuseboxbypassed": fuseboxbypassed,

                        //other
                        "turbocharger": turbocharger,
                        "lightfitted": lightfitted,
                        "lightfittedok": lightfittedok,
                        "dipswitchok": dipswitchok,
                        "lightdipok": lightdipok,
                        "rearlightclean": rearlightclean,
                        "handbrakeok": handbrakeok,
                        "hydraulicsystemok": hydraulicsystemok,
                        "servook": servook,
                        "handbreakmarginok": handbreakmarginok,
                        "footbreakmarginok": footbreakmarginok,
                        "balljointsok": balljointsok,
                        "jointsstatus": jointsstatus,
                        "wheelalignment": wheelalignment,
                        "wheelbalanced": wheelbalanced,
                        "chassisok": chassisok,
                        "fuelpumptank": fuelpumptank,
                        "antitheftdevicefitted": antitheftdevicefitted,
                        "vehiclefit": vehiclefit,
                        "vehicleconformrules": vehicleconformrules,
                        "speedgovernorfitted": speedgovernorfitted,
                        //double
                        "loadcapacity": intloadcapacity,
                        //int
                        "seatingcapacity": doubleseatingcapacity,
                        //dtring
                        "handdrivetype": handdrivetype,
                        "turbochargerdesc": turbochargerdesc,
                        "footbreakok": footbreakok,
                        "frontnearside1": frontnearside1,
                        "frontoffside1": frontoffside1,
                        "rearnearside1": rearnearside1,
                        "rearnearsideouter1": rearnearsideouter1,
                        "rearoffsideinner1": rearoffsideinner1,
                        "rearoffsideouter1": rearoffsideouter1,
                        "sparetyre1": sparetyre1,
                        "frontnearside2": frontnearside2,
                        "frontoffside2": frontoffside2,
                        "rearnearside2": rearnearside2,
                        "rearnearsideouter2": rearnearsideouter2,
                        "rearoffsideinner2": rearoffsideinner2,
                        "rearoffsideouter2": rearoffsideouter2,
                        "sparetyre2": sparetyre2,
                        "steeringboxstatus": steeringboxstatus,
                        "jointsdefect": jointsdefect,
                        "bodyworkok": bodyworkok,
                        "repairgoodstandard": repairgoodstandard,
                        "windscreendoor": windscreendoor,
                        "antitheftdevicedesc": antitheftdevicedesc,
                      }));
                    });
                    print(valuationString);
                    try {

                      final result = await InternetAddress.lookup(
                          'google.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        // print('connected');
                        dial.show();
                        final response = await http
                            .post(url,
                                headers: <String, String>{
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode(<String, dynamic>{
                                  "userid": _userid,
                                  "custid": widget.custID == null
                                      ? _custId
                                      : widget.custID,
                                  "revised": revised,
                                  "fleetinstructionno": _fleetId,
                                  "instructionno": _instructionId,
                                  "photolist": newImagesList,
                                  "logbooklist": newLogBookList,
                                  "model":
                                      _carmodel != null ? _carmodel : model,
                                  "chassisno":
                                      _chasisno != null ? _chasisno : chasisno,
                                  "fuel": _selectedFuel,
                                  "manufactureyear": year,
                                  "sparewheelsize":sparewheelsize,
                                  "origin": origin,
                                  "bodytype": bodytype,
                                  "mileage": mileage,
                                  "enginecapacity": enginecap,
                                  "engineno": engineno,
                                  "make": make,
                                  "type": "",
                                  // "vehiclefit":"",
                                  "inspectionplace": inspectionplace,
                                  "musicsystemvalue": musicsystemval != ""
                                      ? musicsystemval
                                      : "0",
                                  "alloy": alloy,
                                  "regno":
                                      _vehiclereg != null ? _vehiclereg : reg,
                                  "location": _location,
                                  "suspensionspacers": true,
                                  "noofdiscs": "three",
                                  "registrationdate": registrationdate,
                                  "radiocassette": radiocassette,
                                  "cdplayer": cdplayer,
                                  "cdchanger": cdchanger,
                                  "roadworthy": roadworthy,
                                  // "alarm": alarm,
                                  "roadworthynotes": roadworthynotes,
                                  // "alarmtype": alarmtype,
                                  // "discs": discs,
                                  "validinsurance": validinsurance,
                                  "mechanicalcondition": mechanicalcondition,
                                  "bodycondition": bodycondition,
                                  "tyres": tyres,
                                  "generalcondition": generalcondition,
                                  "extras": extras,
                                  "notes": notes,
                                  "windscreenvalue": windscreenvalue,
                                  "antitheftvalue": antitheftvalue,
                                  "valuer": valuer,
                                  "assessedvalue": assessedvalue,
                                  "sparewheel": sparewheel,
                                  "tyresize": tyresize,
                                  "centrallocking": centrallocking,
                                  "powerwindowsrhf": powerwindowsrhf,
                                  "powerwindowslhf": powerwindowslhf,
                                  "powerwindowsrhr": powerwindowsrhr,
                                  "powerwindowslhr": powerwindowslhr,
                                  "powermirrors": powermirrors,
                                  "powersteering": powersteering,
                                  "airconditioner": airconditioner,
                                  "absbrakes": absbrakes,
                                  "foglights": foglights,
                                  "rearspoiler": rearspoiler,
                                  "sidesteps": sidesteps,
                                  "sunroof": sunroof,
                                  "frontgrilleguard": frontgrilleguard,
                                  "rearbumperguard": rearbumperguard,
                                  "sparewheelcover": sparewheelcover,
                                  "seatcovers": seatcovers,
                                  "turbotimer": turbotimer,
                                  "dashboardairbag": dashboardairbag,
                                  "steeringairbag": steeringairbag,
                                  "alloyrims": alloyrims,
                                  "steelrims": steelrims,
                                  "chromerims": chromerims,
                                  "assessedvalue": 1,
                                  "xenonheadlights": xenonheadlights,
                                  "heightadjustmentsystem":
                                      heightadjustmentsystem,
                                  "powerslidingrhfdoor": powerslidingrhfdoor,
                                  "powerslidinglhfdoor": powerslidinglhfdoor,
                                  "powerslidingrhrdoor": powerslidingrhrdoor,
                                  "powerslidinglhrdoor": powerslidinglhrdoor,
                                  "powerbootdoor": powerbootdoor,
                                  "uphostryleatherseat": uphostryleatherseat,
                                  "uphostryfabricseat": uphostryfabricseat,
                                  "uphostrytwotoneseat": uphostrytwotoneseat,
                                  "uphostrybucketseat": uphostrybucketseat,
                                  "powerseatrhfadjustment":
                                      powerseatrhfadjustment,
                                  "powerseatlhfadjustment":
                                      powerseatlhfadjustment,
                                  "powerseatrhradjustment":
                                      powerseatrhradjustment,
                                  "powersteeringadjustment":
                                      powersteeringadjustment,
                                  "powerseatlhradjustment":
                                      powerseatlhradjustment,
                                  "extralargerims": extralargerims,
                                  "rimsize": rimsize,
                                  "noofextracurtains": noofextracurtains != ""
                                      ? noofextracurtains
                                      : "0",
                                  "noofextraseats": noofextraseats != ""
                                      ? noofextraseats
                                      : "0",
                                  "noofextrakneebags": noofextrakneebags != ""
                                      ? noofextrakneebags
                                      : "0",
                                  "frontwindscreen": frontwindscreen != ""
                                      ? frontwindscreen
                                      : "none",
                                  "rearwindscreen": rearwindscreen != ""
                                      ? rearwindscreen
                                      : "none",
                                  "doors": doors,
                                  // "yombelts": "vgvgv",
                                  // "fromanyotherplace": "ggvgvhhh",
                                  // "vinplatedetails": "vinplatedetails",
                                  // "injectiontype": "injectiontype",
                                  // "noofcylinders": "noofcylinders",
                                  // "amfmonly": true,
                                  "crackedrearwindscreen":
                                      crackedrearwindscreen,
                                  "approxmatewindscreenvalue": 878.08,
                                  "rearwindscreenvalue": 878.08,
                                  "musicsystemmodel": musicsystemmodel,
                                  "musicsystemmake": musicsystemmake,
                                  "inbuiltcassette": inbuiltcassette,
                                  "inbuiltcd": inbuiltcd,
                                  "inbuiltdvd": inbuiltdvd,
                                  "inbuiltmapreader": inbuiltmapreader,
                                  "inbuilthddcardreader": inbuilthddcardreader,
                                  "inbuiltminidisc": inbuiltminidisc,
                                  "inbuiltusb": inbuiltusb,
                                  "inbuiltbluetooth": inbuiltbluetooth,
                                  "inbuilttvscreen": inbuilttvscreen,
                                  "inbuiltcdchanger": inbuiltcdchanger,
                                  "inbuiltsecuritydoorlock":
                                      inbuiltsecuritydoorlock,
                                  "inbuiltalarm": inbuiltalarm,
                                  "inbuiltimmobilizer": inbuiltimmobilizer,
                                  "keylessignition": keylessignition,
                                  "trackingdevice": trackingdevice,
                                  "gearleverlock": gearleverlock,
                                  "enginecutoff": enginecutoff,
                                  "anyotherantitheftfeature":
                                      anyotherantitheftfeature != ""
                                          ? anyotherantitheftfeature
                                          : "none",
                                  "anyotherextrafeature":
                                      anyotherextrafeature != ""
                                          ? anyotherextrafeature
                                          : "none",
                                  "anyothervehiclefeature":
                                      anyothervehiclefeature,
                                  "anyotheraddedfeature": "fcfccf",
                                  "anyothermusicsystem":
                                      anyothermusicsystem != ""
                                          ? anyothermusicsystem
                                          : "none",
                                  "noofdoorairbags": noofdoorairbags != ""
                                      ? noofdoorairbags
                                      : "0",
                                  "musicsystemdetachable":
                                      musicsystemdetachable,
                                  "musicsysteminbuilt": musicsysteminbuilt,
                                  "fittedwithamfmonly": fittedwithamfmonly,
                                  "fittedwithreversecamera":
                                      fittedwithreversecamera,
                                  "amfmonly": amfmonly,
                                  "locallyfittedalarm": locallyfittedalarm,
                                  "antitheftmake": antitheftmake,
                                  "roofcarrier": roofcarrier,
                                  "roofrails": true,
                                  "uphostryfabricleatherseat":
                                      uphostryfabricleatherseat,
                                  "dutypaid": dutypaid,
                                  "color": color,

                                  // new features
                                  "noofbattery": noofbatteries,
                                  "crawleeexcavator": crawleeexcavator,
                                  "backhoewheelloader": backhoewheelloader,
                                  "roller": roller,
                                  "fixedcrane": fixedcrane,
                                  "rollercrane": rollercrane,
                                  "mobilecrane": mobilecrane,
                                  "hiabfittedcranetruck": hiabfittedcranetruck,
                                  "primemover": primemover,
                                  "primemoverfilledwithrailercrane":
                                      primemoverfilledwithrailercrane,
                                  "lowloadertrailer": lowloadertrailer,
                                  "concretemixer": concretemixer,
                                  "topmacrollers": topmacrollers,
                                  "aircompressor": aircompressor,
                                  "forklift": forklift,
                                  "specialpurposeconstructionmachinery":
                                      specialpurposeconstructionmachinery,
                                  "batterypoweredlift": batterypoweredlift,
                                  "batterypoweredscissorlift":
                                      batterypoweredscissorlift,
                                  "boomlift": boomlift,
                                  "dumptruck": dumptruck,
                                  "backheeloader": backheeloader,
                                  "vaccumpumpsystem": vaccumpumpsystem,
                                  "dryaircompressor": dryaircompressor,
                                  "transformeroilpurifizatonplant":
                                      transformeroilpurifizatonplant,
                                  "dieselgenerator": dieselgenerator,
                                  "platecompactor": platecompactor,
                                  "twindrumroller": twindrumroller,
                                  "tractors": tractors,
                                  "plaughs": plaughs,
                                  "seeders": seeders,
                                  "combineharvester": combineharvester,
                                  "sprayers": sprayers,
                                  "culters": culters,
                                  "balers": balers,
                                  "ordinaryfueltankers": ordinaryfueltankers,
                                  "watertanker": watertanker,
                                  "exhauster": exhauster,
                                  "specializedfueltanker":
                                      specializedfueltanker,
                                  "opensidebody": opensidebody,
                                  "closedsidebody": closedsidebody,
                                  "trailers": trailers,
                                  "fuseboxbypassed": fuseboxbypassed,

                                  //other
                                  "turbocharger": turbocharger,
                                  "lightfitted": lightfitted,
                                  "lightfittedok": lightfittedok,
                                  "dipswitchok": dipswitchok,
                                  "lightdipok": lightdipok,
                                  "rearlightclean": rearlightclean,
                                  "handbrakeok": handbrakeok,
                                  "hydraulicsystemok": hydraulicsystemok,
                                  "servook": servook,
                                  "handbreakmarginok": handbreakmarginok,
                                  "footbreakmarginok": footbreakmarginok,
                                  "balljointsok": balljointsok,
                                  "jointsstatus": jointsstatus,
                                  "wheelalignment": wheelalignment,
                                  "wheelbalanced": wheelbalanced,
                                  "chassisok": chassisok,
                                  "fuelpumptank": fuelpumptank,
                                  "transmissionspeed": transmissionspeed,
                                  "vehicletype": drivetypeid,
                                  "transmissiontype": transmissionid,
                                  "antitheftdevicefitted":
                                      antitheftdevicefitted,
                                  "vehiclefit": vehiclefit,
                                  "vehicleconformrules": vehicleconformrules,
                                  "speedgovernorfitted": speedgovernorfitted,

                                  //double
                                  "loadcapacity": intloadcapacity,
                                  //int
                                  "seatingcapacity": doubleseatingcapacity,
                                  //dtring
                                  "handdrivetype": handdrivetype,
                                  "turbochargerdesc": turbochargerdesc,
                                  "footbreakok": footbreakok,
                                  "frontnearside1": frontnearside1,
                                  "frontoffside1": frontoffside1,
                                  "rearnearside1": rearnearside1,
                                  "rearnearsideouter1": rearnearsideouter1,
                                  "rearoffsideinner1": rearoffsideinner1,
                                  "rearoffsideouter1": rearoffsideouter1,
                                  "sparetyre1": sparetyre1,
                                  "frontnearside2": frontnearside2,
                                  "frontoffside2": frontoffside2,
                                  "rearnearside2": rearnearside2,
                                  "rearnearsideouter2": rearnearsideouter2,
                                  "rearoffsideinner2": rearoffsideinner2,
                                  "rearoffsideouter2": rearoffsideouter2,
                                  "sparetyre2": sparetyre2,
                                  "steeringboxstatus": steeringboxstatus,
                                  "jointsdefect": jointsdefect,
                                  "bodyworkok": bodyworkok,
                                  "repairgoodstandard": repairgoodstandard,
                                  "windscreendoor": windscreendoor,
                                  "antitheftdevicedesc": antitheftdevicedesc,
                                }))
                            .timeout(

                          Duration(seconds: 45),
                          onTimeout: () {
                            // Time has run out, do what you wanted to do
                            return http.Response(
                                'Your valuation has been saved,make sure your connection is stable and try again later!',
                                408); // Request Timeout response status code
                          },
                        );
                        printWrapped(jsonEncode(<String, dynamic>{
                          "userid": _userid,
                          "custid": widget.custID == null
                              ? _custId
                              : widget.custID,
                          "revised": revised,
                          "fleetinstructionno": _fleetId,
                          "instructionno": _instructionId,
                          // "photolist": newImagesList,
                          // "logbooklist": newLogBookList,
                          "model":
                          _carmodel != null ? _carmodel : model,
                          "chassisno":
                          _chasisno != null ? _chasisno : chasisno,
                          "fuel": _selectedFuel,
                          "manufactureyear": year,
                          "sparewheelsize":sparewheelsize,
                          "origin": origin,
                          "bodytype": bodytype,
                          "mileage": mileage,
                          "enginecapacity": enginecap,
                          "engineno": engineno,
                          "make": make,
                          "type": "",
                          // "vehiclefit":"",
                          "inspectionplace": inspectionplace,
                          "musicsystemvalue": musicsystemval != ""
                              ? musicsystemval
                              : "0",
                          "alloy": alloy,
                          "regno":
                          _vehiclereg != null ? _vehiclereg : reg,
                          "location": _location,
                          "suspensionspacers": true,
                          "noofdiscs": "three",
                          "registrationdate": registrationdate,
                          "radiocassette": radiocassette,
                          "cdplayer": cdplayer,
                          "cdchanger": cdchanger,
                          "roadworthy": roadworthy,
                          // "alarm": alarm,
                          "roadworthynotes": roadworthynotes,
                          // "alarmtype": alarmtype,
                          // "discs": discs,
                          "validinsurance": validinsurance,
                          "mechanicalcondition": mechanicalcondition,
                          "bodycondition": bodycondition,
                          "tyres": tyres,
                          "generalcondition": generalcondition,
                          "extras": extras,
                          "notes": notes,
                          "windscreenvalue": windscreenvalue,
                          "antitheftvalue": antitheftvalue,
                          "valuer": valuer,
                          "assessedvalue": assessedvalue,
                          "sparewheel": sparewheel,
                          "tyresize": tyresize,
                          "centrallocking": centrallocking,
                          "powerwindowsrhf": powerwindowsrhf,
                          "powerwindowslhf": powerwindowslhf,
                          "powerwindowsrhr": powerwindowsrhr,
                          "powerwindowslhr": powerwindowslhr,
                          "powermirrors": powermirrors,
                          "powersteering": powersteering,
                          "airconditioner": airconditioner,
                          "absbrakes": absbrakes,
                          "foglights": foglights,
                          "rearspoiler": rearspoiler,
                          "sidesteps": sidesteps,
                          "sunroof": sunroof,
                          "frontgrilleguard": frontgrilleguard,
                          "rearbumperguard": rearbumperguard,
                          "sparewheelcover": sparewheelcover,
                          "seatcovers": seatcovers,
                          "turbotimer": turbotimer,
                          "dashboardairbag": dashboardairbag,
                          "steeringairbag": steeringairbag,
                          "alloyrims": alloyrims,
                          "steelrims": steelrims,
                          "chromerims": chromerims,
                          "assessedvalue": 1,
                          "xenonheadlights": xenonheadlights,
                          "heightadjustmentsystem":
                          heightadjustmentsystem,
                          "powerslidingrhfdoor": powerslidingrhfdoor,
                          "powerslidinglhfdoor": powerslidinglhfdoor,
                          "powerslidingrhrdoor": powerslidingrhrdoor,
                          "powerslidinglhrdoor": powerslidinglhrdoor,
                          "powerbootdoor": powerbootdoor,
                          "uphostryleatherseat": uphostryleatherseat,
                          "uphostryfabricseat": uphostryfabricseat,
                          "uphostrytwotoneseat": uphostrytwotoneseat,
                          "uphostrybucketseat": uphostrybucketseat,
                          "powerseatrhfadjustment":
                          powerseatrhfadjustment,
                          "powerseatlhfadjustment":
                          powerseatlhfadjustment,
                          "powerseatrhradjustment":
                          powerseatrhradjustment,
                          "powersteeringadjustment":
                          powersteeringadjustment,
                          "powerseatlhradjustment":
                          powerseatlhradjustment,
                          "extralargerims": extralargerims,
                          "rimsize": rimsize,
                          "noofextracurtains": noofextracurtains != ""
                              ? noofextracurtains
                              : "0",
                          "noofextraseats": noofextraseats != ""
                              ? noofextraseats
                              : "0",
                          "noofextrakneebags": noofextrakneebags != ""
                              ? noofextrakneebags
                              : "0",
                          "frontwindscreen": frontwindscreen != ""
                              ? frontwindscreen
                              : "none",
                          "rearwindscreen": rearwindscreen != ""
                              ? rearwindscreen
                              : "none",
                          "doors": doors,
                          // "yombelts": "vgvgv",
                          // "fromanyotherplace": "ggvgvhhh",
                          // "vinplatedetails": "vinplatedetails",
                          // "injectiontype": "injectiontype",
                          // "noofcylinders": "noofcylinders",
                          // "amfmonly": true,
                          "crackedrearwindscreen":
                          crackedrearwindscreen,
                          "approxmatewindscreenvalue": 878.08,
                          "rearwindscreenvalue": 878.08,
                          "musicsystemmodel": musicsystemmodel,
                          "musicsystemmake": musicsystemmake,
                          "inbuiltcassette": inbuiltcassette,
                          "inbuiltcd": inbuiltcd,
                          "inbuiltdvd": inbuiltdvd,
                          "inbuiltmapreader": inbuiltmapreader,
                          "inbuilthddcardreader": inbuilthddcardreader,
                          "inbuiltminidisc": inbuiltminidisc,
                          "inbuiltusb": inbuiltusb,
                          "inbuiltbluetooth": inbuiltbluetooth,
                          "inbuilttvscreen": inbuilttvscreen,
                          "inbuiltcdchanger": inbuiltcdchanger,
                          "inbuiltsecuritydoorlock":
                          inbuiltsecuritydoorlock,
                          "inbuiltalarm": inbuiltalarm,
                          "inbuiltimmobilizer": inbuiltimmobilizer,
                          "keylessignition": keylessignition,
                          "trackingdevice": trackingdevice,
                          "gearleverlock": gearleverlock,
                          "enginecutoff": enginecutoff,
                          "anyotherantitheftfeature":
                          anyotherantitheftfeature != ""
                              ? anyotherantitheftfeature
                              : "none",
                          "anyotherextrafeature":
                          anyotherextrafeature != ""
                              ? anyotherextrafeature
                              : "none",
                          "anyothervehiclefeature":
                          anyothervehiclefeature,
                          "anyotheraddedfeature": "fcfccf",
                          "anyothermusicsystem":
                          anyothermusicsystem != ""
                              ? anyothermusicsystem
                              : "none",
                          "noofdoorairbags": noofdoorairbags != ""
                              ? noofdoorairbags
                              : "0",
                          "musicsystemdetachable":
                          musicsystemdetachable,
                          "musicsysteminbuilt": musicsysteminbuilt,
                          "fittedwithamfmonly": fittedwithamfmonly,
                          "fittedwithreversecamera":
                          fittedwithreversecamera,
                          "amfmonly": amfmonly,
                          "locallyfittedalarm": locallyfittedalarm,
                          "antitheftmake": antitheftmake,
                          "roofcarrier": roofcarrier,
                          "roofrails": true,
                          "uphostryfabricleatherseat":
                          uphostryfabricleatherseat,
                          "dutypaid": dutypaid,
                          "color": color,

                          // new features
                          "noofbattery": noofbatteries,
                          "crawleeexcavator": crawleeexcavator,
                          "backhoewheelloader": backhoewheelloader,
                          "roller": roller,
                          "fixedcrane": fixedcrane,
                          "rollercrane": rollercrane,
                          "mobilecrane": mobilecrane,
                          "hiabfittedcranetruck": hiabfittedcranetruck,
                          "primemover": primemover,
                          "primemoverfilledwithrailercrane":
                          primemoverfilledwithrailercrane,
                          "lowloadertrailer": lowloadertrailer,
                          "concretemixer": concretemixer,
                          "topmacrollers": topmacrollers,
                          "aircompressor": aircompressor,
                          "forklift": forklift,
                          "specialpurposeconstructionmachinery":
                          specialpurposeconstructionmachinery,
                          "batterypoweredlift": batterypoweredlift,
                          "batterypoweredscissorlift":
                          batterypoweredscissorlift,
                          "boomlift": boomlift,
                          "dumptruck": dumptruck,
                          "backheeloader": backheeloader,
                          "vaccumpumpsystem": vaccumpumpsystem,
                          "dryaircompressor": dryaircompressor,
                          "transformeroilpurifizatonplant":
                          transformeroilpurifizatonplant,
                          "dieselgenerator": dieselgenerator,
                          "platecompactor": platecompactor,
                          "twindrumroller": twindrumroller,
                          "tractors": tractors,
                          "plaughs": plaughs,
                          "seeders": seeders,
                          "combineharvester": combineharvester,
                          "sprayers": sprayers,
                          "culters": culters,
                          "balers": balers,
                          "ordinaryfueltankers": ordinaryfueltankers,
                          "watertanker": watertanker,
                          "exhauster": exhauster,
                          "specializedfueltanker":
                          specializedfueltanker,
                          "opensidebody": opensidebody,
                          "closedsidebody": closedsidebody,
                          "trailers": trailers,
                          "fuseboxbypassed": fuseboxbypassed,

                          //other
                          "turbocharger": turbocharger,
                          "lightfitted": lightfitted,
                          "lightfittedok": lightfittedok,
                          "dipswitchok": dipswitchok,
                          "lightdipok": lightdipok,
                          "rearlightclean": rearlightclean,
                          "handbrakeok": handbrakeok,
                          "hydraulicsystemok": hydraulicsystemok,
                          "servook": servook,
                          "handbreakmarginok": handbreakmarginok,
                          "footbreakmarginok": footbreakmarginok,
                          "balljointsok": balljointsok,
                          "jointsstatus": jointsstatus,
                          "wheelalignment": wheelalignment,
                          "wheelbalanced": wheelbalanced,
                          "chassisok": chassisok,
                          "fuelpumptank": fuelpumptank,
                          "transmissionspeed": transmissionspeed,
                          "vehicletype": drivetypeid,
                          "transmissiontype": transmissionid,
                          "antitheftdevicefitted":
                          antitheftdevicefitted,
                          "vehiclefit": vehiclefit,
                          "vehicleconformrules": vehicleconformrules,
                          "speedgovernorfitted": speedgovernorfitted,

                          //double
                          "loadcapacity": intloadcapacity,
                          //int
                          "seatingcapacity": doubleseatingcapacity,
                          //dtring
                          "handdrivetype": handdrivetype,
                          "turbochargerdesc": turbochargerdesc,
                          "footbreakok": footbreakok,
                          "frontnearside1": frontnearside1,
                          "frontoffside1": frontoffside1,
                          "rearnearside1": rearnearside1,
                          "rearnearsideouter1": rearnearsideouter1,
                          "rearoffsideinner1": rearoffsideinner1,
                          "rearoffsideouter1": rearoffsideouter1,
                          "sparetyre1": sparetyre1,
                          "frontnearside2": frontnearside2,
                          "frontoffside2": frontoffside2,
                          "rearnearside2": rearnearside2,
                          "rearnearsideouter2": rearnearsideouter2,
                          "rearoffsideinner2": rearoffsideinner2,
                          "rearoffsideouter2": rearoffsideouter2,
                          "sparetyre2": sparetyre2,
                          "steeringboxstatus": steeringboxstatus,
                          "jointsdefect": jointsdefect,
                          "bodyworkok": bodyworkok,
                          "repairgoodstandard": repairgoodstandard,
                          "windscreendoor": windscreendoor,
                          "antitheftdevicedesc": antitheftdevicedesc,
                        }));
                        if (response != null) {

                          int statusCode = response.statusCode;
                          if (statusCode == 200) {
                            dial.hide();
                            return _showDialog(this.context);
                          } else {
                            dial.hide();
                            print("Submit Status code::" +
                                response.body.toString());
                            showAlertDialog(this.context, response.body);
                          }
                        } else {
                          print('no response');
                          dial.hide();
                          Fluttertoast.showToast(
                              msg: 'There was no response from the server');
                        }
                      } else {
                        // print('not connected1');
                        // dbHelper
                        //     .insertValuation(
                        //   ValuationModel(
                        //     id: index,
                        //     valuationjson: valuationString,
                        //   ),
                        // )
                        //     .then((value) {
                        //   print('valuation saved');
                        //   Navigator.pop(context);
                        //   showAlertDialog(this.context,
                        //       'Your valuation has been saved, Try later when your connection is stable');
                        // }).onError((error, stackTrace) {
                        //   print(error.toString());
                        // });
                      }
                    } on SocketException catch (_) {
                      print('not connected2');
                      print(valuationString !=null);
                      if(valuationString !=null) {
                        dial.show();
                        dbHelper
                            .insertValuation(
                          ValuationModel(
                            id: index,
                            valuationjson: valuationString,
                          ),
                        )
                            .then((value) {
                          print('valuation saved');
                          print(index);
                          dial.hide();
                              Fluttertoast.showToast(
                                  msg:
                                      value.toString());
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SaveValuations()),
                          );
                        }).onError((error, stackTrace) {
                          print(error.toString());
                        });
                      }else{
                        showAlertDialog(this.context,
                            'Valuation not saved,Try again');
                      }
                    }
                  },
                  child: Text('Yes'))
            ],
          );
        });
  }

  void _showDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
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

  List<XFile>? imageslist = [];
  List<XFile>? logbooklist = [];

  CameraController? controller; //controller for camera
  XFile? image;
  XFile? logbbok;
  String? customersString;
  String? instructionsString;
  String? fleetString;
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

    });
    if (string.contains('Offline')) {
      Fluttertoast.showToast(
          msg:
              'No internet,your assessment will be posted once you are connected to the internet!');
    } else {
      // _submit();
    }
  }

  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString('key') as String;
    List customerList = auth.split(",");
    print("customerlist");
    print(customerList);
    setState(() {
      customerList = customersJson;
    });
  }

  Future<void> saveUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('key', customersString!);
    print('user info:');
    // printWrapped(customersString!);
    getUserInfo();
  }

  getInstructions() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String auth = prefs.getString(instructionlist) as String;
    List assessmentList = auth.split(",");
    print("getInstructions");

    setState(() {
      assessmentList = valuationsJson;
      print(valuationsJson);
    });
  }

  Future<void> saveAssessments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(instructionlist, instructionsString!);
    print('instructionlist:');
    print(instructionsString!);
    if(instructionsString !=null || instructionsString !=""){
      getInstructions();
    }

  }
  // getFleet() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String auth = prefs.getString(fleetlist) as String;
  //   List fleetList = auth.split(",");
  //   print("getInstructions");
  //
  //   setState(() {
  //     fleettList = fleetJson;
  //     print(valuationsJson);
  //   });
  // }
  //
  // Future<void> saveFleet() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString(fleetlist, fleetString!);
  //   print('instructionlist:');
  //   print(instructionsString!);
  //   if(instructionsString !=null || instructionsString !=""){
  //     getInstructions();
  //   }
  //
  // }

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

  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  final String instructionlist = "instructionlist";
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
  //for captured image
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
  void initState() {
     random = new Random();
    _checkNetwork();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    // if (string.contains('Online')) {
    //   // _fetchInstructions();
    //   List valuationsJson = [];
    // } else {
    //   getInstructions();
    //   getUserInfo();
    // }
    print('custID');
    print(widget.custID != null);
    print('custID');
    print(widget.custID != null);
    if ((widget.custID != 0) && (widget.custID != null)) {
      setState(() {
        SessionPreferences().getLoggedInUser().then((user) {
          setState(() {
            _fetchInstructions();
            _fetchCustomers();
            _fetchFleet();
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
    loadCamera();
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
    islogbookcameraopen = false;
    // isExistingClient = true;
    // print(customerid);

    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        _loggedInUser = user;
        _userid = user.id;
        _hrid = user.hrid;
        _custid = user.custid;
        _costcenter = user.branchname;
        _username = user.fullname;
      });
    });

    super.initState();
    _fetchCustomers();
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
  List<String>? filenames = [];
  List<String>? logbooknames = [];
  // late User _loggedInUser;

  String? _searchString;
  final _userNameInput = TextEditingController();
  final _passWordInput = TextEditingController();

  final _loanofficername = TextEditingController();
  final _loanofficerphone = TextEditingController();

  // final _carmodel = TextEditingController();
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
  // final _location = TextEditingController();
  final _installationdate = TextEditingController();
  final _remarks = TextEditingController();

// User? _loggedInUser;

  // List<Technician>? technicians;
  String _message = 'Search';

  // late final custID;
  // late final custName;
  // TextEditingController _searchController = TextEditingController();
  // TextEditingController _itemDescController = new TextEditingController();

  bool _isEnable = false;
  var _selectedValue = null;
  var _selectedFleet = null;
  var _selectedInstruction = null;
  var _selectedCustomer = null;
  var _selectedFuel = null;
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
  final _formKey19 = GlobalKey<FormState>();
  bool isLoading = false;
  bool revised = false;
  bool revised2 = false;
  bool revised3 = false;
  bool? isBankSelected;
  bool? isFinancierSelected;
  bool? iscameraopen;
  bool? islogbookcameraopen;
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
  List<String> listOfCustomers4 = [
    'AIG INSURANCE',
    'KENYAN ALLIANCE INSURANCE',
    'SAHAM ASSURANCE',
    "TAUSI ASSURANCE"
  ];
  List<String> listOfDepartments = [
    "DEPARTMENT1",
    "DEPARTMENT2",
    "DEPARTMENT3",
    "DEPARTMENT4",
  ];
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
    return iscameraopen == false && islogbookcameraopen == false
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
                              currentForm = 1;
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Select customer and attach instruction',
                                  textColor: Colors.blue);
                            }

                            // if (form.validate() &&
                            //     _instructionId != null &&
                            //     _custId != null) {
                            //   form.save();

                            //   percentageComplete = 25;
                            // } else {
                            //   Fluttertoast.showToast(
                            //       msg: 'Select customer and attach instruction',
                            //       textColor: Colors.blue);
                            // }

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
                            form = _formKey19.currentState;
                            if (form.validate()) {
                              form.save();
                              currentForm = 4;
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
                          case 4:
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
                                'Create Valuation',
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
                                            _selectedCustomer = value;
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
                                            if (string.contains('Online')) {
                                              _fetchInstructions();
                                              _fetchFleet();
                                            }

                                            setState(() {
                                              // _selectedValue = value!;
                                            });
                                            // print(_selectedValue);
                                            print(_instructionId);
                                            print(_custid);
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
                                              "Val Date:",
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
                                          height: 20,
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
                                              "*",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(color: Colors.blue),
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _checkIfInstructionIsSelected();
                                          },
                                          child: SearchableDropdown(
                                            hint: Text(
                                              "Attach Instruction",
                                            ),

                                            isExpanded: true,
                                            onChanged: (value) {
                                              // _location = (value != null
                                              //     ? ['location']
                                              //     : null);
                                              // _chasisno = (value != null
                                              //     ? ['chassisno']
                                              //     : null) as String?;
                                              setState(() {
                                                _selectedInstruction = value;
                                                _selectedFleet = null;
                                                _fleetId = 0;
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
                                                _reg.text = value != null
                                                    ? value['regno']
                                                    : null;
                                                _excess = value != null
                                                    ? value['excess']
                                                    : null;
                                                _claimString = value != null
                                                    ? value['claimform']
                                                    : null;
                                              });
                                              // print(_selectedValue);
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
                                            items: valuationsJson.map((val) {
                                              return DropdownMenuItem(
                                                child: getListTile1(val),
                                                value: val,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "Attach Fleet",
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
                                        InkWell(
                                          onTap: () {
                                            _checkIfInstructionIsSelected();
                                          },
                                          child: SearchableDropdown(
                                            hint: Text(
                                              "Attach Fleet",
                                            ),
                                            // readOnly: isInstructionSelected ==true?true:false,
                                            isExpanded: true,
                                            onChanged: (value) {
                                              // _location = (value != null
                                              //     ? ['location']
                                              //     : null);
                                              // _chasisno = (value != null
                                              //     ? ['chassisno']
                                              //     : null) as String?;
                                              setState(() {
                                                _selectedFleet = value;
                                                _selectedInstruction = null;
                                                _instructionId = 0;
                                                _reg.clear();
                                                _make.clear();
                                                _model.clear();
                                                _excess = "";

                                                _fleetId = value != null
                                                    ? value['id']
                                                    : null;

                                                _chassisno.clear();
                                                _policyno = "";
                                                _claimno = "";

                                                _location = value != null
                                                    ? value['location']
                                                    : null;
                                                _owner = "";
                                                _insuredvalue = null;
                                              });
                                              // print(_selectedValue);
                                              // print(_custName);
                                              // print(_custId);
                                              // print(_custPhone);
                                              _dropdownError = null;
                                            },

                                            // isCaseSensitiveSearch: true,
                                            searchHint: Text(
                                              'Attach Fleet',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            items: fleetJson.map((val) {
                                              return DropdownMenuItem(
                                                child: getListTile2(val),
                                                value: val,
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        SizedBox(
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
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        style: TextStyle(color: Colors.blue),
                                        // initialValue: _vehiclereg != null
                                        //     ? _vehiclereg
                                        //     : '',
                                        controller: _reg,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration:
                                            InputDecoration(hintText: "Reg No"),
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        // initialValue: _chasisno,
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
                                        // initialValue:
                                        //     _make != null ? _make : '',
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
                                            "Type/Model	",
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
                                        // initialValue:
                                        //     _carmodel != null ? _carmodel : '',
                                        controller: _model,
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
                                            "Handdrive Type",
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
                                        controller: _handdrivetype,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Handdrive Type"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Turbo Charger Description",
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
                                        controller: _turbochargerdesc,
                                        onSaved: (value) => {vehicleColor},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText:
                                                "Turbo Charger Description"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Foot Break ok",
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
                                        controller: _footbreakok,
                                        onSaved: (value) => {},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Foot Break ok"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Frontnearside1",
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
                                        controller: _frontnearside1,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Frontnearside1"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Frontoffside1",
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
                                        controller: _frontoffside1,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Frontoffside1"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Rearnearside1",
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
                                        controller: _rearnearside1,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Rearnearside1"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Rearnearsideouter1",
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
                                        controller: _rearnearsideouter1,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText:
                                                "Enter Rearnearsideouter1"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Rearoffsideinner1",
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
                                        controller: _rearoffsideinner1,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Rearoffsideinner1"),
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
                                            "rearoffsideouter1 ",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _rearoffsideouter1,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "rearoffsideouter1"),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "sparetyre1",
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
                                        controller: _sparetyre1,
                                        onSaved: (value) => {},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "sparetyre1"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "frontnearside2",
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
                                        controller: _frontnearside2,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "frontnearside2"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "frontoffside2",
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
                                        controller: _frontoffside2,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "frontoffside2"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "rearnearside2",
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
                                        controller: _rearnearside2,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "rearnearside2"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "rearnearsideouter2",
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
                                        controller: _rearnearsideouter2,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "rearnearsideouter2"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "rearoffsideinner2",
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
                                        controller: _rearoffsideinner2,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "rearoffsideinner2"),
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
                                            "rearoffsideouter2",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                      TextFormField(
                                        controller: _rearoffsideouter2,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "rearoffsideouter2"),
                                      ),

                                      //new
                                      Row(
                                        children: [
                                          Text(
                                            "sparetyre2",
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
                                        controller: _sparetyre2,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "sparetyre2"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "steeringboxstatus",
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
                                        controller: _steeringboxstatus,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "steeringboxstatus"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "jointsdefect",
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
                                        controller: _jointsdefect,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "jointsdefect"),
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
                                            "bodyworkok",
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
                                        controller: _bodyworkok,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "bodyworkok"),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "repairgoodstandard",
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
                                        controller: _repairgoodstandard,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "repairgoodstandard"),
                                      ),

                                      //new
                                      Row(
                                        children: [
                                          Text(
                                            "windscreendoor",
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
                                        controller: _windscreendoor,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "windscreendoor"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "antitheftdevicedesc",
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
                                        controller: _antitheftdevicedesc,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "antitheftdevicedesc"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "loadcapacity",
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
                                          inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                        ],
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _loadcapacity,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "loadcapacity"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "seatingcapacity",
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
                                          inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                                        ],
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _seatingcapacity,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "seatingcapacity"),
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
                                                .copyWith(color: Colors.blue),
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
                                        decoration:
                                            InputDecoration(hintText: "Year"),
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
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
                                            "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2!
                                                .copyWith(color: Colors.blue),
                                          )
                                        ],
                                      ),
                                      TextFormField(
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
                                            "Body Type",
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
                                        controller: _bodytype,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Body Type"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Engine Capacity",
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
                                        controller: _enginecap,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Engine Capacity"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Place of inspection",
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
                                        controller: _poi,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Place of inspection"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Fuel by",
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
                                          'Select Fuel ',
                                        ),
                                        validator: (value) => value == null ? 'field required' : null,
                                        isExpanded: true,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedFuel = value!;
                                          });

                                          _dropdownError = null;
                                        },

                                        // isCaseSensitiveSearch: true,
                                        searchHint: Text(
                                          'Select Fuel ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        items: items.map((String items) {
                                          return DropdownMenuItem(
                                            child: Text(items),
                                            value: items,
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Country of origin",
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
                                        controller: _origin,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                            hintText: "Country of origin"),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "No.of Batteries",
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
                                        controller: _noofbatteries,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            hintText: "Country of origin"),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: CheckboxListTile(
                                              title: Text('Road Worthy?'),
                                              selected: roadworthy,
                                              value: roadworthy,
                                              activeColor: Colors.blue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  roadworthy = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Flexible(
                                            child: CheckboxListTile(
                                              title: Text('Duty Paid?'),
                                              selected: dutypaid,
                                              value: dutypaid,
                                              activeColor: Colors.blue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  dutypaid = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ))
                          ])),
                      Form(
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey19,
                        child: Column(children: <Widget>[
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Common Features",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Central Locking'),
                                            selected: centrallocking,
                                            value: centrallocking,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                centrallocking = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Windows RHF'),
                                            selected: powerwindowsrhf,
                                            value: powerwindowsrhf,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowsrhf = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Windows LHF'),
                                            selected: powerwindowslhf,
                                            value: powerwindowslhf,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowslhf = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Windows RHR'),
                                            selected: powerwindowsrhr,
                                            value: powerwindowsrhr,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowsrhr = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Windows LHR'),
                                            selected: powerwindowslhr,
                                            value: powerwindowslhr,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowslhr = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Mirrors'),
                                            selected: powermirrors,
                                            value: powermirrors,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powermirrors = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Steering'),
                                            selected: powersteering,
                                            value: powersteering,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powersteering = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('A/Conditioner'),
                                            selected: airconditioner,
                                            value: airconditioner,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                airconditioner = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('ABS Brakes'),
                                            selected: absbrakes,
                                            value: absbrakes,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                absbrakes = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Fog Lights'),
                                            selected: foglights,
                                            value: foglights,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                foglights = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Roof Rails'),
                                            selected: roofrails,
                                            value: roofrails,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                roofrails = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Rear Spoiler'),
                                            selected: rearspoiler,
                                            value: rearspoiler,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                rearspoiler = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Side Steps'),
                                            selected: sidesteps,
                                            value: sidesteps,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sidesteps = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Fabric Seats'),
                                            selected: uphostryfabricseat,
                                            value: uphostryfabricseat,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                uphostryfabricseat = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Spare Wheel Cover'),
                                            selected: sparewheelcover,
                                            value: sparewheelcover,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sparewheelcover = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Dashboard A/Bag'),
                                            selected: dashboardairbag,
                                            value: dashboardairbag,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                dashboardairbag = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Steering Airbag'),
                                            selected: steeringairbag,
                                            value: steeringairbag,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                steeringairbag = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Alloy Rims'),
                                            selected: alloyrims,
                                            value: alloyrims,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                alloyrims = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: CheckboxListTile(
                                              title: Text('Chrome Rims'),
                                              selected: chromerims,
                                              value: chromerims,
                                              activeColor: Colors.blue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  chromerims = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                    Row(
                                      children: [
                                        Text(
                                          "Any Other Feature",
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
                                      // controller: _anyothermusicsystem,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Any Other Feature"),
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Common Features",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Turbo charger'),
                                            selected: turbocharger,
                                            value: turbocharger,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                turbocharger = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Light Fitted'),
                                            selected: lightfitted,
                                            value: lightfitted,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                lightfitted = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Light fitted ok'),
                                            selected: lightfittedok,
                                            value: lightfittedok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                lightfittedok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Dipswitch ok'),
                                            selected: dipswitchok,
                                            value: dipswitchok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                dipswitchok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Lightdip ok'),
                                            selected: lightdipok,
                                            value: lightdipok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                lightdipok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Rear light clean'),
                                            selected: rearlightclean,
                                            value: rearlightclean,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                rearlightclean = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('handbrake ok'),
                                            selected: handbrakeok,
                                            value: handbrakeok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                handbrakeok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('hydraulic system ok'),
                                            selected: hydraulicsystemok,
                                            value: hydraulicsystemok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                hydraulicsystemok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('servo ok'),
                                            selected: servook,
                                            value: servook,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                servook = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('handbreak margin ok'),
                                            selected: handbreakmarginok,
                                            value: handbreakmarginok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                handbreakmarginok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('foot break margin ok'),
                                            selected: footbreakmarginok,
                                            value: footbreakmarginok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                footbreakmarginok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('balljointsok'),
                                            selected: balljointsok,
                                            value: balljointsok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                balljointsok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('joint status'),
                                            selected: jointsstatus,
                                            value: jointsstatus,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                jointsstatus = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('wheel alignment'),
                                            selected: wheelalignment,
                                            value: wheelalignment,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                wheelalignment = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('wheel balanced'),
                                            selected: wheelbalanced,
                                            value: wheelbalanced,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                wheelbalanced = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('chassis ok'),
                                            selected: chassisok,
                                            value: chassisok,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                chassisok = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('fuel pump tank'),
                                            selected: fuelpumptank,
                                            value: fuelpumptank,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                fuelpumptank = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('antitheft device fitted'),
                                            selected: antitheftdevicefitted,
                                            value: antitheftdevicefitted,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                antitheftdevicefitted = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: CheckboxListTile(
                                              title: Text('vehicle fit'),
                                              selected: vehiclefit,
                                              value: vehiclefit,
                                              activeColor: Colors.blue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  vehiclefit = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Flexible(
                                            child: CheckboxListTile(
                                              title:
                                                  Text('vehicle conform rules'),
                                              selected: vehicleconformrules,
                                              value: vehicleconformrules,
                                              activeColor: Colors.blue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  vehicleconformrules = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: CheckboxListTile(
                                              title:
                                                  Text('speed governor fitted'),
                                              selected: speedgovernorfitted,
                                              value: speedgovernorfitted,
                                              activeColor: Colors.blue,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  speedgovernorfitted = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Uncommon Features",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Xenon Headlights'),
                                            selected: xenonheadlights,
                                            value: xenonheadlights,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                xenonheadlights = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text(
                                                'Height Adjustment System'),
                                            selected: heightadjustmentsystem,
                                            value: heightadjustmentsystem,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                heightadjustmentsystem = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Power Sliding Door RHF'),
                                            selected: powerslidingrhfdoor,
                                            value: powerslidingrhfdoor,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerslidingrhfdoor = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Power Sliding Door LHF'),
                                            selected: powerslidinglhfdoor,
                                            value: powerslidinglhfdoor,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerslidinglhfdoor = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Power Sliding Door RHR'),
                                            selected: powerslidingrhrdoor,
                                            value: powerslidingrhrdoor,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerslidingrhrdoor = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Power Sliding Door LHR'),
                                            selected: powerslidinglhrdoor,
                                            value: powerslidinglhrdoor,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerslidinglhrdoor = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Leather Seats'),
                                            selected: uphostryleatherseat,
                                            value: uphostryleatherseat,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                uphostryleatherseat = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('	Sunroof'),
                                            selected: sunroof,
                                            value: sunroof,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sunroof = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Bucket Seats'),
                                            selected: uphostrybucketseat,
                                            value: uphostrybucketseat,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                uphostrybucketseat = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text(
                                                'Power Seat Adjustment RHF'),
                                            selected: powerseatrhfadjustment,
                                            value: powerseatrhfadjustment,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerseatrhfadjustment = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text(
                                                'Power Seat Adjustment LHF'),
                                            selected: powerseatlhfadjustment,
                                            value: powerseatlhfadjustment,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerseatlhfadjustment = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Power Boot Door'),
                                            selected: powerbootdoor,
                                            value: powerbootdoor,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerbootdoor = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "No. of Curtains A/bags",
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
                                      controller: _noofextracurtains,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "No. of Curtains A/bags"),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "No. of Seats A/bags",
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
                                      controller: _noofextraseats,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "No. of Seats A/bags"),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "No. of Knee A/bags",
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
                                      controller: _noofextrakneebags,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "No. of Knee A/bags"),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "No of Door Airbags",
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
                                      controller: _noofdoorairbags,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          hintText: "No of Door Airbags"),
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "FARM MACHINERY",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Tractors'),
                                            selected: tractors,
                                            value: tractors,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                tractors = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Plaughs'),
                                            selected: plaughs,
                                            value: plaughs,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                plaughs = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Seeders'),
                                            selected: seeders,
                                            value: seeders,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                seeders = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Combine Harvester'),
                                            selected: combineharvester,
                                            value: combineharvester,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                combineharvester = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Sprayers'),
                                            selected: sprayers,
                                            value: sprayers,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sprayers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Culters'),
                                            selected: culters,
                                            value: culters,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                culters = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Balers'),
                                            selected: balers,
                                            value: balers,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                balers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Tankers",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Ordinary fuel tankers'),
                                            selected: ordinaryfueltankers,
                                            value: ordinaryfueltankers,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                ordinaryfueltankers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Water tanker'),
                                            selected: watertanker,
                                            value: watertanker,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                watertanker = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Exhauster'),
                                            selected: exhauster,
                                            value: exhauster,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                exhauster = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Specialized fuel tanker'),
                                            selected: specializedfueltanker,
                                            value: specializedfueltanker,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                specializedfueltanker = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Articulated Trucks",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Open side body'),
                                            selected: opensidebody,
                                            value: opensidebody,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                opensidebody = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Closed side body'),
                                            selected: closedsidebody,
                                            value: closedsidebody,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                closedsidebody = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Trailers'),
                                            selected: trailers,
                                            value: trailers,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                trailers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            elevation: 0.9,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.blueAccent, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, top: 30, bottom: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "CPM",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Divider(color: Colors.blue),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Crawlee excavator'),
                                          selected: crawleeexcavator,
                                          value: crawleeexcavator,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              crawleeexcavator = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Backhoe Wheel loader'),
                                          selected: backhoewheelloader,
                                          value: backhoewheelloader,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              backhoewheelloader = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Roller'),
                                          selected: roller,
                                          value: roller,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              roller = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Fixed Crane'),
                                          selected: fixedcrane,
                                          value: fixedcrane,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              fixedcrane = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Roller Crane'),
                                          selected: rollercrane,
                                          value: rollercrane,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              rollercrane = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Mobile Crane'),
                                          selected: mobilecrane,
                                          value: mobilecrane,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              mobilecrane = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title:
                                              Text('Hiab fitted crane truck'),
                                          selected: hiabfittedcranetruck,
                                          value: hiabfittedcranetruck,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              hiabfittedcranetruck = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Prime Mover'),
                                          selected: primemover,
                                          value: primemover,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              primemover = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text(
                                              'Prime mover filled with railer crane'),
                                          selected:
                                              primemoverfilledwithrailercrane,
                                          value:
                                              primemoverfilledwithrailercrane,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              primemoverfilledwithrailercrane =
                                                  value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Low loader trailer'),
                                          selected: lowloadertrailer,
                                          value: lowloadertrailer,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              lowloadertrailer = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Concrete Mixer'),
                                          selected: concretemixer,
                                          value: concretemixer,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              concretemixer = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Top Mac Rollers'),
                                          selected: topmacrollers,
                                          value: topmacrollers,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              topmacrollers = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Air Compressor'),
                                          selected: aircompressor,
                                          value: aircompressor,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              aircompressor = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text(
                                              'Special purpose construction machinery'),
                                          selected:
                                              specialpurposeconstructionmachinery,
                                          value:
                                              specialpurposeconstructionmachinery,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              specialpurposeconstructionmachinery =
                                                  value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Battery Powered Lift'),
                                          selected: batterypoweredlift,
                                          value: batterypoweredlift,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              batterypoweredlift = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text(
                                              'Battery Powered Scissor lift'),
                                          selected: batterypoweredscissorlift,
                                          value: batterypoweredscissorlift,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              batterypoweredscissorlift =
                                                  value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Boom lift'),
                                          selected: boomlift,
                                          value: boomlift,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              boomlift = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Dump truck'),
                                          selected: dumptruck,
                                          value: dumptruck,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              dumptruck = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Backhee loader'),
                                          selected: backheeloader,
                                          value: backheeloader,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              backheeloader = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text(
                                              'Special purpose construction machinery'),
                                          selected:
                                              specialpurposeconstructionmachinery,
                                          value:
                                              specialpurposeconstructionmachinery,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              specialpurposeconstructionmachinery =
                                                  value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Battery Powered Lift'),
                                          selected: batterypoweredlift,
                                          value: batterypoweredlift,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              batterypoweredlift = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Vaccum pump system'),
                                          selected: vaccumpumpsystem,
                                          value: vaccumpumpsystem,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              vaccumpumpsystem = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Dry air compressor'),
                                          selected: dryaircompressor,
                                          value: dryaircompressor,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              dryaircompressor = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text(
                                              'Transformer oil purifizaton plant'),
                                          selected:
                                              transformeroilpurifizatonplant,
                                          value: transformeroilpurifizatonplant,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              transformeroilpurifizatonplant =
                                                  value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Diesel Generator'),
                                          selected: dieselgenerator,
                                          value: dieselgenerator,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              dieselgenerator = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Plate Compactor'),
                                          selected: platecompactor,
                                          value: platecompactor,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              platecompactor = value!;
                                            });
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        child: CheckboxListTile(
                                          title: Text('Twin Drum Roller'),
                                          selected: twindrumroller,
                                          value: twindrumroller,
                                          activeColor: Colors.blue,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              twindrumroller = value!;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Radio/Music Systems",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Detachable'),
                                            selected: musicsystemdetachable,
                                            value: musicsystemdetachable,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                musicsystemdetachable = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Inbuilt CD/DVD'),
                                            selected: inbuiltcd,
                                            value: inbuiltcd,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltcd = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                Text('Fitted with AM/FM only'),
                                            selected: fittedwithamfmonly,
                                            value: fittedwithamfmonly,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                fittedwithamfmonly = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Cassette player'),
                                            selected: radiocassette,
                                            value: radiocassette,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                radiocassette = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Mini Disc player'),
                                            selected: inbuiltminidisc,
                                            value: inbuiltminidisc,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltminidisc = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Map Reader'),
                                            selected: inbuiltmapreader,
                                            value: inbuiltmapreader,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltmapreader = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('HDD Card Reader'),
                                            selected: inbuilthddcardreader,
                                            value: inbuilthddcardreader,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuilthddcardreader = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('USB Reader'),
                                            selected: inbuiltusb,
                                            value: inbuiltusb,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltusb = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Bluetooth'),
                                            selected: inbuiltbluetooth,
                                            value: inbuiltbluetooth,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltbluetooth = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('TV/LCD Screen'),
                                            selected: inbuilttvscreen,
                                            value: inbuilttvscreen,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuilttvscreen = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('CD Changer'),
                                            selected: cdchanger,
                                            value: cdchanger,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                cdchanger = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Reverse Camera'),
                                            selected: fittedwithreversecamera,
                                            value: fittedwithreversecamera,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                fittedwithreversecamera =
                                                    value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('FuseBox Bypassed'),
                                            selected: fuseboxbypassed,
                                            value: fuseboxbypassed,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                fuseboxbypassed = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Make/Model",
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
                                      controller: _musicsystemmodel,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Make/Model"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "No. of Discs",
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
                                      controller: _noofdiscs,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "No. of Discs"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Any Other Feature",
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
                                      controller: _anyothermusicsystem,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Any Other Feature"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Music System Approx Value",
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
                                      controller: _musicsystemval,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Enter Music System Approx Value"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Anti-Theft Type",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Locally Fitted Alarm'),
                                            selected: locallyfittedalarm,
                                            value: locallyfittedalarm,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                locallyfittedalarm = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text(
                                                'Inbuilt Security Door Locks'),
                                            selected: inbuiltsecuritydoorlock,
                                            value: inbuiltsecuritydoorlock,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltsecuritydoorlock =
                                                    value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Inbuilt Alarm'),
                                            selected: inbuiltalarm,
                                            value: inbuiltalarm,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltalarm = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Inbuilt Immobilizer'),
                                            selected: inbuiltimmobilizer,
                                            value: inbuiltimmobilizer,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltimmobilizer = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            selected: keylessignition,
                                            title: Text('Keyless Ignition'),
                                            value: keylessignition,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                keylessignition = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Tracking Device'),
                                            selected: trackingdevice,
                                            value: trackingdevice,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                trackingdevice = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Gear Lever Lock'),
                                            selected: gearleverlock,
                                            value: gearleverlock,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                gearleverlock = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Engine Cut Off'),
                                            selected: enginecutoff,
                                            value: enginecutoff,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                enginecutoff = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
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
                                              .copyWith(color: Colors.blue),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _antitheftmake,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Make"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Any Other Anti-Theft Feature",
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
                                      controller: _anyotherantitheftfeature,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Enter Any Other Anti-Theft Feature"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Windscreens",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Front",
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
                                      controller: _frontwindscreen,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Front"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rear",
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
                                      controller: _rearwindscreen,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Rear"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Doors",
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
                                      controller: _doors,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Doors"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Approxmate Value",
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
                                      controller: _approxmatewindscreenvalue,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Approxmate Value"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Added Features",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Seat Covers'),
                                            selected: seatcovers,
                                            value: seatcovers,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                seatcovers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Turbo Timer'),
                                            selected: turbotimer,
                                            value: turbotimer,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                turbotimer = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Front Grill/Bull Bar'),
                                            selected: frontgrilleguard,
                                            value: frontgrilleguard,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                frontgrilleguard = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Roof Carrier'),
                                            selected: roofcarrier,
                                            value: roofcarrier,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                roofcarrier = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Rear Bumper Guard'),
                                            selected: rearbumperguard,
                                            value: rearbumperguard,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                rearbumperguard = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text('Suspension Spacers'),
                                            selected: suspensionspacers,
                                            value: suspensionspacers,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                suspensionspacers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: Text(
                                                'Special/Extra Large Rims'),
                                            selected: extralargerims,
                                            value: extralargerims,
                                            activeColor: Colors.blue,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                extralargerims = value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rims Size",
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
                                      controller: _rimsize,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Rims Size"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Any Other Feature",
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
                                      controller: _anyothervehiclefeature,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Any Other Feature"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 30, bottom: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Findings",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Divider(color: Colors.blue),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Mechanical Condition",
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
                                      controller: _mechanicalcondition,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Mechanical Condition"),
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
                                          "Spare wheel size",
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
                                      controller: _sparewheelsize,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Body Condition"),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Body Condition",
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
                                      controller: _bodycondition,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Body Condition"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Tyres",
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
                                      controller: _tyres,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Tyres Findings"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "General Condition ",
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
                                      controller: _generalcondition,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Enter Genral Condition Findings"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Notes",
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
                                      controller: _notes,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Notes"),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Any Other Feature",
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
                                      controller: _anyotherextrafeature,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          hintText: "Enter Any Other Feature"),
                                    ),
                                  ],
                                ),
                              )),
                        ]),
                      ),
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
                                      Container(
                                          child: imageslist != null
                                              ? GridView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
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
                                                          FadeInImage(
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
                                                          Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            height: 30,
                                                            width:
                                                                double.infinity,
                                                            child: Center(
                                                              child: Text(
                                                                filenames![
                                                                    index],
                                                                maxLines: 8,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Regular'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container()),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            islogbookcameraopen = true;
                                            logbbok = null;
                                            _logBookDescController.clear();
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              "Add LogBook photos",
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
                                      Container(
                                          child: logbooklist != null
                                              ? GridView.builder(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                  ),
                                                  itemCount:
                                                      logbooklist!.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Container(
                                                      child: Stack(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        children: <Widget>[
                                                          FadeInImage(
                                                            image: FileImage(
                                                              File(logbooklist![
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
                                                          Container(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.7),
                                                            height: 30,
                                                            width:
                                                                double.infinity,
                                                            child: Center(
                                                              child: Text(
                                                                logbooknames![
                                                                    index],
                                                                maxLines: 8,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        'Regular'),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container()),
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
        : iscameraopen == true
            ? Scaffold(
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
    )
            : islogbookcameraopen == true
                ? Scaffold(
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
                                        logbbok =
                                        await takePicture();
                                        File image1 = File(
                                            logbbok!.path);
                                        int currentUnix =
                                            DateTime.now()
                                                .millisecondsSinceEpoch;

                                        String fileFormat =
                                            image1.path
                                                .split('.')
                                                .last;
                                        setState(() {
                                          islogbookcameraopen =
                                          false;
                                        });
                                        islogbookcameraopen =
                                        false;
                                        // GallerySaver.saveImage(
                                        //         logbbok!.path)
                                        //     .then((path) {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext
                                          context) {
                                            return _SystemPadding(
                                              child:
                                              AlertDialog(
                                                contentPadding:
                                                const EdgeInsets.all(
                                                    16.0),
                                                content:
                                                Row(
                                                  children: <
                                                      Widget>[
                                                    Expanded(
                                                      child:
                                                      TextFormField(
                                                        controller:
                                                        _logBookDescController,
                                                        keyboardType:
                                                        TextInputType.text,
                                                        autofocus:
                                                        true,
                                                        decoration:
                                                        const InputDecoration(labelText: 'Enter Description', hintText: 'Description'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                actions: <
                                                    Widget>[
                                                  TextButton(
                                                      child: const Text(
                                                          'CANCEL'),
                                                      onPressed:
                                                          () {
                                                        Navigator.pop(context);
                                                      }),
                                                  TextButton(
                                                      child: const Text(
                                                          'OKAY'),
                                                      onPressed:
                                                          () {
                                                        Navigator.pop(context);
                                                        setState(() {
                                                          String? description = _logBookDescController.text.trim();
                                                          print(description);
                                                          final bytes = Io.File(logbbok!.path).readAsBytesSync();

                                                          String imageFile = base64Encode(bytes);
                                                          logbooks = Images(filename: description, attachment: imageFile);
                                                          _addLogBookImage(logbbok!);
                                                          _addLogBookImages(logbooks!);
                                                          _addLogBookDescription(description);
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
    )
                : Container();
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
            'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=3&revised=$revised')
        : (url +
            'valuation/custinstruction/?custid=${widget.custID}&hrid=$_hrid&typeid=3&revised=$revised');
    HttpClientResponse response = await Config.getRequestObject(
      stringurl,
      Config.get,
    );
    if (response != null) {
      print(stringurl);
      print(response.compressionState);
      bool _validURL = Uri.parse(url +
              'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=3&revised=$revised')
          .isAbsolute;
      print(_validURL);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = jsonDecode(data);
        print(jsonResponse);
        setState(() {
          valuationsJson = jsonResponse;
          // instructionsString = valuationsJson.join(",");
          // saveAssessments();
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

  _fetchFleet() async {
    String url = await Config.getBaseUrl();
    HttpClientResponse response = await Config.getRequestObject(
        url +
            'valuation/fleetinstruction/?custid=$_custId&hrid=$_hrid&typeid=3',
        Config.get);
    if (response != null) {
      // print(url +
      //     'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=1&revised=$revised');
      print(response);
      response.transform(utf8.decoder).transform(LineSplitter()).listen((data) {
        var jsonResponse = json.decode(data);
        setState(() {
          fleetJson = jsonResponse;
          // fleetString = valuationsJson.join(",");
          // saveAssessments();
        });
        print(jsonResponse);
        var list = jsonResponse as List;
        List<Instruction> result = list.map<Instruction>((json) {
          return Instruction.fromJson(json);
        }).toList();
        if (result.isNotEmpty) {
          // setState(() {
          //   result.sort((a, b) => a.chassisno!
          //       .toLowerCase()
          //       .compareTo(b.chassisno!.toLowerCase()));
          //   _instruction = result;
          //   if (_instruction != null && _instruction.isNotEmpty) {
          //     _instruction.forEach((instruction) {
          //       setState(() {});

          //       print(_owner);
          //     });
          //   }
          // });
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

Widget getListTile2(val) {
  return ListTile(
    leading: Text(val['noofveh'].toString()),
    title: Text(val['custname'] ?? ''),
    trailing: Text(val['location'] ?? ''),
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
