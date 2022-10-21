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

class CreateValuation extends StatefulWidget {
  const CreateValuation({Key? key}) : super(key: key);

  @override
  State<CreateValuation> createState() => _CreateValuationState();
}

class _CreateValuationState extends State<CreateValuation> {
  late User _loggedInUser;

  int? _userid;
  int? _custid;
  int? _custId;
  int? _hrid;
  int? _instructionId;
  String? _policyno;
  String? _chasisno;
  String? _vehiclereg;
  String? _make;
  String? _carmodel;
  String? _location;
  String? _claimno;

  int? _insuredvalue;
  String? _excess;
  String? _owner;

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
  // final _make = TextEditingController();
  TextEditingController _searchController = new TextEditingController();
  final _year = TextEditingController();
  final _color = TextEditingController();
  final _itemDescController = TextEditingController();
  final _logBookDescController = TextEditingController();
  final _loanofficeremail = TextEditingController();
  // final _vehiclereg = TextEditingController();
  final _chassisno = TextEditingController();
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
  // final _carmodel = TextEditingController();
  final _mileage = TextEditingController();
  final _engineno = TextEditingController();
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
  // final _owner = TextEditingController();
  final _mechanicalcondition = TextEditingController();
  final _origin = TextEditingController();
  final _bodycondition = TextEditingController();
  final _tyres = TextEditingController();
  final _generalcondition = TextEditingController();
  final _extras = TextEditingController();
  final _notes = TextEditingController();
  final _windscreenvalue = TextEditingController();
  final _antitheftvalue = TextEditingController();
  final _valuer = TextEditingController();

  final _assessedvalue = TextEditingController();
  final _sparewheel = TextEditingController();
  final _tyresize = TextEditingController();
  final _antitheftmake = TextEditingController();

  final _anyotherantitheftfeature = TextEditingController();

  final _noofdoorairbags = TextEditingController();

  // final _claimno = TextEditingController();
  // final _policyno = TextEditingController();
  // final _location = TextEditingController();
  // final _insuredvalue = TextEditingController();
  // final _excess = TextEditingController();
  final _noofextrakneebags = TextEditingController();

  TextEditingController _dateinput = TextEditingController();
  Images? images;
  Images? logbooks;
  List<Map<String, dynamic>>? newImagesList;
  List<Map<String, dynamic>>? newLogBookList;
  List<Images>? newList = [];
  List<Images>? newLogbookList = [];
  List<Images>? newimages = [];
  List<Instruction> _instruction = [];
  List instructionsJson = [];
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
                    // log(images.toString());
                    ProgressDialog dial = new ProgressDialog(context,
                        type: ProgressDialogType.Normal);
                    dial.style(
                      message: 'Sending Valuation',
                    );
                    dial.show();
                    String origin = _origin.text.trim();

                    String fuelby = _fuelby.text.trim();
                    String year = _year.text.trim();
                    String bodytype = _bodytype.text;
                    String mileage = _mileage.text.trim();

                    String enginecap = _enginecap.text.trim();

                    String windscreenvalue = _windscreenvalue.text.trim();
                    String antitheftvalue = _antitheftvalue.text.trim();
                    String mechanicalcondition =
                        _mechanicalcondition.text.trim();
                    String valuer = _valuer.text;
                    String assessedvalue = _assessedvalue.text.trim();
                    String rimsize = _rimsize.text.trim();
                    String sparewheel = _sparewheel.text.trim();
                    String tyresize = _tyresize.text.trim();

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

                    String injectiontype = _injectiontype.text.trim();
                    String noofcylinders = _noofcylinders.text.trim();
                    String demoUrl = await Config.getBaseUrl();
                    Uri url = Uri.parse(demoUrl + 'valuation/valuation/');
                    print(url);

                    final response = await http.post(url,
                        headers: <String, String>{
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode(<String, dynamic>{
                          "userid": _userid,
                          "custid": _custId,
                          "revised": revised,
                          "instructionno": _instructionId,
                          "photolist": newImagesList,
                          "logbooklist": newLogBookList,
                          "model": _carmodel,
                          "chassis": _chasisno,
                          "fuel": fuelby,
                          "manufactureyear": year,
                          "origin": origin,
                          "bodytype": bodytype,
                          "mileage": mileage,
                          "enginecapacity": enginecap,
                          "engineno": engineno,
                          "make": _make,
                          "inspectionplace": inspectionplace,
                          "musicsystemvalue":
                              musicsystemval != "" ? musicsystemval : "0",
                          "alloy": alloy,
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
                          // "yombelts": "vgvgv",
                          // "fromanyotherplace": "ggvgvhhh",
                          // "vinplatedetails": "vinplatedetails",
                          // "injectiontype": "injectiontype",
                          // "noofcylinders": "noofcylinders",
                          // "amfmonly": true,
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
                        }));

                    log(jsonEncode(<String, dynamic>{
                      // "userid": _userid,
                      // "custid": _custId,
                      // "revised": _isEnable,
                      // "instructionno": 1,
                      // "photolist": newImagesList,
                      "logbooklist": newLogBookList,
                      // "model": _carmodel,
                      // "chassis": _chasisno,
                      // "fuel": fuelby,
                      // "manufactureyear": year,
                      // "origin": origin,
                      // "bodytype": bodytype,
                      // "mileage": mileage,
                      // "enginecapacity": enginecap,
                      // "engineno": engineno,
                      // "make": _make,
                      // "inspectionplace": inspectionplace,
                      // "musicsystemvalue": musicsystemval,
                      // "alloy": alloy,
                      // "suspensionspacers": true,
                      // "noofdiscs": "three",
                      // "registrationdate": registrationdate,
                      // "radiocassette": radiocassette,
                      // "cdplayer": cdplayer,
                      // "cdchanger": cdchanger,
                      // "roadworthy": roadworthy,
                      // // "alarm": alarm,
                      // "roadworthynotes": roadworthynotes,
                      // // "alarmtype": alarmtype,
                      // // "discs": discs,
                      // "validinsurance": validinsurance,
                      // "mechanicalcondition": mechanicalcondition,
                      // "bodycondition": bodycondition,
                      // "tyres": tyres,
                      // "generalcondition": generalcondition,
                      // "extras": extras,
                      // "notes": notes,
                      // "windscreenvalue": windscreenvalue,
                      // "antitheftvalue": antitheftvalue,
                      // "valuer": valuer,
                      // "assessedvalue": assessedvalue,
                      // "sparewheel": sparewheel,
                      // "tyresize": tyresize,
                      // "centrallocking": centrallocking,
                      // "powerwindowsrhf": powerwindowsrhf,
                      // "powerwindowslhf": powerwindowslhf,
                      // "powerwindowsrhr": powerwindowsrhr,
                      // "powerwindowslhr": powerwindowslhr,
                      // "powermirrors": powermirrors,
                      // "powersteering": powersteering,
                      // "airconditioner": airconditioner,
                      // "absbrakes": absbrakes,
                      // "foglights": foglights,
                      // "rearspoiler": rearspoiler,
                      // "sidesteps": sidesteps,
                      // "sunroof": sunroof,
                      // "frontgrilleguard": frontgrilleguard,
                      // "rearbumperguard": rearbumperguard,
                      // "sparewheelcover": sparewheelcover,
                      // "seatcovers": seatcovers,
                      // "turbotimer": turbotimer,
                      // "dashboardairbag": dashboardairbag,
                      // "steeringairbag": steeringairbag,
                      // "alloyrims": alloyrims,
                      // "steelrims": steelrims,
                      // "chromerims": chromerims,
                      // "assessedvalue": 1,
                      // "xenonheadlights": xenonheadlights,
                      // "heightadjustmentsystem": heightadjustmentsystem,
                      // "powerslidingrhfdoor": powerslidingrhfdoor,
                      // "powerslidinglhfdoor": powerslidinglhfdoor,
                      // "powerslidingrhrdoor": powerslidingrhrdoor,
                      // "powerslidinglhrdoor": powerslidinglhrdoor,
                      // "powerbootdoor": powerbootdoor,
                      // "uphostryleatherseat": uphostryleatherseat,
                      // "uphostryfabricseat": uphostryfabricseat,
                      // "uphostrytwotoneseat": uphostrytwotoneseat,
                      // "uphostrybucketseat": uphostrybucketseat,
                      // "powerseatrhfadjustment": powerseatrhfadjustment,
                      // "powerseatlhfadjustment": powerseatlhfadjustment,
                      // "powerseatrhradjustment": powerseatrhradjustment,
                      // "powersteeringadjustment": powersteeringadjustment,
                      // "powerseatlhradjustment": powerseatlhradjustment,
                      // "extralargerims": extralargerims,
                      // "rimsize": rimsize,
                      // "noofextracurtains": noofextracurtains,
                      // "noofextraseats": noofextraseats,
                      // "noofextrakneebags": noofextrakneebags,
                      // "frontwindscreen": frontwindscreen,
                      // "rearwindscreen": rearwindscreen,
                      // "doors": doors,
                      // // "yombelts": "vgvgv",
                      // // "fromanyotherplace": "ggvgvhhh",
                      // // "vinplatedetails": "vinplatedetails",
                      // // "injectiontype": "injectiontype",
                      // // "noofcylinders": "noofcylinders",
                      // // "amfmonly": true,
                      // "crackedrearwindscreen": crackedrearwindscreen,
                      // "approxmatewindscreenvalue": 878.08,
                      // "rearwindscreenvalue": 878.08,
                      // "musicsystemmodel": musicsystemmodel,
                      // "musicsystemmake": musicsystemmake,
                      // "inbuiltcassette": inbuiltcassette,
                      // "inbuiltcd": inbuiltcd,
                      // "inbuiltdvd": inbuiltdvd,
                      // "inbuiltmapreader": inbuiltmapreader,
                      // "inbuilthddcardreader": inbuilthddcardreader,
                      // "inbuiltminidisc": inbuiltminidisc,
                      // "inbuiltusb": inbuiltusb,
                      // "inbuiltbluetooth": inbuiltbluetooth,
                      // "inbuilttvscreen": inbuilttvscreen,
                      // "inbuiltcdchanger": inbuiltcdchanger,
                      // "inbuiltsecuritydoorlock": inbuiltsecuritydoorlock,
                      // "inbuiltalarm": inbuiltalarm,
                      // "inbuiltimmobilizer": inbuiltimmobilizer,
                      // "keylessignition": keylessignition,
                      // "trackingdevice": trackingdevice,
                      // "gearleverlock": gearleverlock,
                      // "enginecutoff": enginecutoff,
                      // "anyotherantitheftfeature": anyotherantitheftfeature,
                      // "anyotherextrafeature": anyotherextrafeature,
                      // "anyothervehiclefeature": anyothervehiclefeature,
                      // "anyotheraddedfeature": "fcfccf",
                      // "anyothermusicsystem": "fffffffffffcf",
                      // "noofdoorairbags": noofdoorairbags,
                      // "musicsystemdetachable": musicsystemdetachable,
                      // "musicsysteminbuilt": musicsysteminbuilt,
                      // "fittedwithamfmonly": fittedwithamfmonly,
                      // "fittedwithreversecamera": fittedwithreversecamera,
                      // "amfmonly": amfmonly,
                      // "locallyfittedalarm": locallyfittedalarm,
                      // "antitheftmake": antitheftmake,
                      // "roofcarrier": roofcarrier,
                      // "roofrails": true,
                      // "uphostryfabricleatherseat": uphostryfabricleatherseat,
                      // "dutypaid": dutypaid,
                      // "color": color,
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

  List<XFile>? imageslist = [];
  List<XFile>? logbooklist = [];
  List<CameraDescription>? cameras; //list out the camera available
  CameraController? controller; //controller for camera
  XFile? image;
  XFile? logbbok;
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

  Widget getListTile(val) {
    return ListTile(
      leading: Text(val['mobile'] ?? ''),
      title: Text(val['company'] ?? ''),
      trailing: Text(val['email'] ?? ''),
    );
  }

  @override
  void initState() {
    loadCamera();
    DateTime dateTime = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(dateTime);
    _dateinput.text = formattedDate; //set the initial value of text field
    _instructionId = 2;
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
                            form = _formKey19.currentState;
                            if (form.validate()) {
                              form.save();
                              currentForm = 4;
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
                                'Create Valuation',
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
                                            setState(() {
                                              // _selectedValue = value!;
                                            });
                                            print(_selectedValue);
                                            print(_custName);
                                            print(_custid);
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
                                              "Val Date:",
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
                                                  .copyWith(color: Colors.red),
                                            )
                                          ],
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
                                            // _chasisno = (value != null
                                            //     ? ['chassisno']
                                            //     : null) as String?;
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
                                            });
                                            // print(_selectedValue);
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
                                      TextFormField(
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _drivetype,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Drive Type"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Transmission	",
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
                                        controller: _transmission,
                                        onSaved: (value) => {vehicleColor},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Transmission	"),
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
                                        controller: _classofuse,
                                        onSaved: (value) => {},
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
                                        controller: _logbookno,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Log Book No"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Endorsement",
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
                                        controller: _endorsement,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Endorsement"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "LBook Owner",
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
                                        controller: _lbookowner,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter LBook Owner"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Load Capacity",
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
                                        controller: _loadcapacity,
                                        onSaved: (value) => {remarks},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Load Capacity"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "No of Owners",
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
                                        controller: _noofowners,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "No of Owners"),
                                      ),
                                      CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        title: Text(
                                          'Insurance Valid?',
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Road Worthy Notes ",
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
                                        controller: _roadworthynotes,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "No of Owners"),
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
                                            "Body Type",
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
                                        controller: _bodytype,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Body Type"),
                                      ),
                                      const SizedBox(
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
                                        controller: _enginecap,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Engine Capacity"),
                                      ),
                                      const SizedBox(
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
                                        controller: _poi,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Place of inspection"),
                                      ),
                                      const SizedBox(
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
                                                .copyWith(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      TextFormField(
                                        validator: (value) => value!.isEmpty
                                            ? "This field is required"
                                            : null,
                                        controller: _fuelby,
                                        onSaved: (value) => {engineNo},
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                            hintText: "Fuel by"),
                                      ),
                                      const SizedBox(
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
                                                .copyWith(color: Colors.red),
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
                                        decoration: const InputDecoration(
                                            hintText: "Country of origin"),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: CheckboxListTile(
                                              title: const Text('Road Worthy?'),
                                              selected: roadworthy,
                                              value: roadworthy,
                                              activeColor: Colors.red,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  roadworthy = value!;
                                                });
                                              },
                                            ),
                                          ),
                                          Flexible(
                                            child: CheckboxListTile(
                                              title: const Text('Duty Paid?'),
                                              selected: dutypaid,
                                              value: dutypaid,
                                              activeColor: Colors.red,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  dutypaid = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
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
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Central Locking'),
                                            selected: centrallocking,
                                            value: centrallocking,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                centrallocking = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Power Windows RHF'),
                                            selected: powerwindowsrhf,
                                            value: powerwindowsrhf,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Power Windows LHF'),
                                            selected: powerwindowslhf,
                                            value: powerwindowslhf,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowslhf = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Power Windows RHR'),
                                            selected: powerwindowsrhr,
                                            value: powerwindowsrhr,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Power Windows LHR'),
                                            selected: powerwindowslhr,
                                            value: powerwindowslhr,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowslhr = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Power Mirrors'),
                                            selected: powermirrors,
                                            value: powermirrors,
                                            activeColor: Colors.red,
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
                                            title: const Text('Power Steering'),
                                            selected: powersteering,
                                            value: powersteering,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powersteering = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('A/Conditioner'),
                                            selected: airconditioner,
                                            value: airconditioner,
                                            activeColor: Colors.red,
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
                                            title: const Text('ABS Brakes'),
                                            selected: absbrakes,
                                            value: absbrakes,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                absbrakes = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Fog Lights'),
                                            selected: foglights,
                                            value: foglights,
                                            activeColor: Colors.red,
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
                                            title: const Text('Roof Rails'),
                                            selected: roofrails,
                                            value: roofrails,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                roofrails = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Rear Spoiler'),
                                            selected: rearspoiler,
                                            value: rearspoiler,
                                            activeColor: Colors.red,
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
                                            title: const Text('Side Steps'),
                                            selected: sidesteps,
                                            value: sidesteps,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sidesteps = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Fabric Seats'),
                                            selected: uphostryfabricseat,
                                            value: uphostryfabricseat,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Spare Wheel Cover'),
                                            selected: sparewheelcover,
                                            value: sparewheelcover,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sparewheelcover = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Dashboard A/Bag'),
                                            selected: dashboardairbag,
                                            value: dashboardairbag,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Steering Airbag'),
                                            selected: steeringairbag,
                                            value: steeringairbag,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                steeringairbag = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Alloy Rims'),
                                            selected: alloyrims,
                                            value: alloyrims,
                                            activeColor: Colors.red,
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
                                              title: const Text('Chrome Rims'),
                                              selected: chromerims,
                                              value: chromerims,
                                              activeColor: Colors.red,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  chromerims = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ]),
                                  ],
                                ),
                              )),
                          Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Xenon Headlights'),
                                            selected: xenonheadlights,
                                            value: xenonheadlights,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                xenonheadlights = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Height Adjustment System'),
                                            selected: heightadjustmentsystem,
                                            value: heightadjustmentsystem,
                                            activeColor: Colors.red,
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
                                            title: const Text(
                                                'Power Sliding Door RHF'),
                                            selected: powerslidingrhfdoor,
                                            value: powerslidinglhfdoor,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerslidinglhrdoor = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Power Sliding Door LHF'),
                                            selected: powerwindowsrhr,
                                            value: powerwindowsrhr,
                                            activeColor: Colors.red,
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
                                            title: const Text(
                                                'Power Sliding Door RHR'),
                                            selected: powerwindowslhr,
                                            value: powerwindowslhr,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                powerwindowslhr = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Power Sliding Door LHR'),
                                            selected: powermirrors,
                                            value: powermirrors,
                                            activeColor: Colors.red,
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
                                            title: const Text('Leather Seats'),
                                            selected: uphostryleatherseat,
                                            value: uphostryleatherseat,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                uphostryleatherseat = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('	Sunroof'),
                                            selected: sunroof,
                                            value: sunroof,
                                            activeColor: Colors.red,
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
                                            title: const Text('Bucket Seats'),
                                            selected: roofrails,
                                            value: roofrails,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                roofrails = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Power Seat Adjustment RHF'),
                                            selected: rearspoiler,
                                            value: rearspoiler,
                                            activeColor: Colors.red,
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
                                            title: const Text(
                                                'Power Seat Adjustment LHF'),
                                            selected: sidesteps,
                                            value: sidesteps,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                sidesteps = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Power Boot Door'),
                                            selected: powerbootdoor,
                                            value: powerbootdoor,
                                            activeColor: Colors.red,
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _noofextracurtains,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _noofextraseats,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _noofextrakneebags,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _noofdoorairbags,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          hintText: "No of Door Airbags"),
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Detachable'),
                                            selected: musicsystemdetachable,
                                            value: musicsystemdetachable,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                musicsystemdetachable = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Inbuilt'),
                                            selected: inbuiltcd,
                                            value: inbuiltcd,
                                            activeColor: Colors.red,
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
                                            title: const Text(
                                                'Fitted with AM/FM only'),
                                            selected: fittedwithamfmonly,
                                            value: fittedwithamfmonly,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                fittedwithamfmonly = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Cassette player'),
                                            selected: radiocassette,
                                            value: radiocassette,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Mini Disc player'),
                                            selected: inbuiltminidisc,
                                            value: inbuiltminidisc,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltminidisc = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Map Reader'),
                                            selected: inbuiltmapreader,
                                            value: inbuiltmapreader,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('HDD Card Reader'),
                                            selected: inbuilthddcardreader,
                                            value: inbuilthddcardreader,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuilthddcardreader = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('USB Reader'),
                                            selected: inbuiltusb,
                                            value: inbuiltusb,
                                            activeColor: Colors.red,
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
                                            title: const Text('Bluetooth'),
                                            selected: inbuiltbluetooth,
                                            value: inbuiltbluetooth,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltbluetooth = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('TV/LCD Screen'),
                                            selected: inbuilttvscreen,
                                            value: inbuilttvscreen,
                                            activeColor: Colors.red,
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
                                            title: const Text('CD Changer'),
                                            selected: cdchanger,
                                            value: cdchanger,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                cdchanger = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Reverse Camera'),
                                            selected: fittedwithreversecamera,
                                            value: fittedwithreversecamera,
                                            activeColor: Colors.red,
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
                                            title: const Text('CD/DVD Player'),
                                            selected: inbuiltcd,
                                            value: inbuiltcd,
                                            activeColor: Colors.red,
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _musicsystemmodel,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Make/Model"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _noofdiscs,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "No. of Discs"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _anyothermusicsystem,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Any Other Feature"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _musicsystemval,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Enter Music System Approx Value"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Locally Fitted Alarm'),
                                            selected: locallyfittedalarm,
                                            value: locallyfittedalarm,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                locallyfittedalarm = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Inbuilt Security Door Locks'),
                                            selected: inbuiltsecuritydoorlock,
                                            value: inbuiltsecuritydoorlock,
                                            activeColor: Colors.red,
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
                                            title: const Text('Inbuilt Alarm'),
                                            selected: inbuiltalarm,
                                            value: inbuiltalarm,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                inbuiltalarm = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Inbuilt Immobilizer'),
                                            selected: inbuiltimmobilizer,
                                            value: inbuiltimmobilizer,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Keyless Ignition'),
                                            value: keylessignition,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                keylessignition = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title:
                                                const Text('Tracking Device'),
                                            selected: trackingdevice,
                                            value: trackingdevice,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Geer Lever Lock'),
                                            selected: gearleverlock,
                                            value: gearleverlock,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                gearleverlock = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Engine Cut Off'),
                                            selected: enginecutoff,
                                            value: enginecutoff,
                                            activeColor: Colors.red,
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _antitheftmake,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Make"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _anyotherantitheftfeature,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Enter Any Other Anti-Theft Feature"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _frontwindscreen,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Front"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _rearwindscreen,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Rear"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _doors,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Doors"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _approxmatewindscreenvalue,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Approxmate Value"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Seat Covers'),
                                            selected: seatcovers,
                                            value: seatcovers,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                seatcovers = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Turbo Timer'),
                                            selected: turbotimer,
                                            value: turbotimer,
                                            activeColor: Colors.red,
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
                                            title: const Text(
                                                'Front Grill/Bull Bar'),
                                            selected: frontgrilleguard,
                                            value: frontgrilleguard,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                frontgrilleguard = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text('Roof Carrier'),
                                            selected: roofcarrier,
                                            value: roofcarrier,
                                            activeColor: Colors.red,
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
                                            title:
                                                const Text('Rear Bumper Guard'),
                                            selected: rearbumperguard,
                                            value: rearbumperguard,
                                            activeColor: Colors.red,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                rearbumperguard = value!;
                                              });
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: CheckboxListTile(
                                            title: const Text(
                                                'Suspension Spacers'),
                                            selected: suspensionspacers,
                                            value: suspensionspacers,
                                            activeColor: Colors.red,
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
                                            title: const Text(
                                                'Special/Extra Large Rims'),
                                            selected: extralargerims,
                                            value: extralargerims,
                                            activeColor: Colors.red,
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _rimsize,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Rims Size"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _anyothervehiclefeature,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Any Other Feature"),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )),
                          Card(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              elevation: 0.9,
                              shape: const RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.redAccent, width: 1),
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.only(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Divider(color: Colors.red),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _mechanicalcondition,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Mechanical Condition"),
                                    ),
                                    const SizedBox(
                                      height: 10,
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _bodycondition,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Body Condition"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _tyres,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Tyres Findings"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _generalcondition,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText:
                                              "Enter Genral Condition Findings"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _notes,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Enter Notes"),
                                    ),
                                    const SizedBox(
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
                                              .copyWith(color: Colors.red),
                                        )
                                      ],
                                    ),
                                    TextFormField(
                                      controller: _anyotherextrafeature,
                                      onSaved: (value) => {vehicleReg},
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
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
                                            SizedBox(
                                              width: 200,
                                            ),
                                            Icon(
                                              Icons.camera_enhance,
                                              color: Colors.red,
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
                                              color: Colors.red,
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
        : iscameraopen == true
            ? Scaffold(
                appBar: AppBar(
                  title: const Text("Capture Image from Camera"),
                  backgroundColor: Colors.red,
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
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Text(
                          "Image Description",
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _itemDescController,
                      onSaved: (value) => {engineNo},
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                          hintText: "Enter Image Description"),
                    ),
                    SizedBox(
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
                                image = await controller!
                                    .takePicture(); //capture image
                                setState(() {
                                  String? description =
                                      _itemDescController.text.trim();
                                  print(description);
                                  final bytes =
                                      Io.File(image!.path).readAsBytesSync();

                                  String imageFile = base64Encode(bytes);
                                  images = Images(
                                      filename: description,
                                      attachment: imageFile);
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
                              msg:
                                  'Please fill the description to capture image');
                        }
                      },
                      icon: const Icon(Icons.camera),
                      label: const Text("Capture"),
                    ),
                  ])),
                ),
              )
            : islogbookcameraopen == true
                ? Scaffold(
                    appBar: AppBar(
                      title: const Text("Capture Logbook from Camera"),
                      backgroundColor: Colors.red,
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
                        SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Text(
                              "Image Description",
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _logBookDescController,
                          onSaved: (value) => {engineNo},
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: "Enter Image Description"),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton.icon(
                          //image capture button
                          onPressed: () async {
                            try {
                              if (controller != null) {
                                //check if contrller is not null
                                if (controller!.value.isInitialized) {
                                  //check if controller is initialized
                                  image = await controller!.takePicture();
                                  String? description =
                                      _logBookDescController.text.trim();
                                  final bytes =
                                      Io.File(image!.path).readAsBytesSync();

                                  String imageFile = base64Encode(bytes);
                                  logbooks = Images(
                                      filename: description,
                                      attachment: imageFile); //capture image
                                  setState(() {
                                    String? description =
                                        _logBookDescController.text.trim();
                                    print(description);
                                    _addLogBookImage(image!);
                                    _addLogBookImages(logbooks!);
                                    _addLogBookDescription(description);
                                  });
                                }
                              }
                            } catch (e) {
                              print(e); //show error
                            }

                            if (_itemDescController != null) {
                              setState(() {
                                islogbookcameraopen = false;
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please fill description');
                            }
                          },
                          icon: const Icon(Icons.camera),
                          label: const Text("Capture"),
                        ),
                      ])),
                    ),
                  )
                : Container();
  }

  _fetchInstructions() async {
    String url = await Config.getBaseUrl();

    HttpClientResponse response = await Config.getRequestObject(
        url +
            'valuation/custinstruction/?custid=$_custId&hrid=$_hrid&typeid=3&revised=$revised',
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

                print(_owner);
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
}
