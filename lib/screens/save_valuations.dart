import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/db_helper.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../provider/assessment_provider.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;

import 'create_instruction.dart';

class SaveValuations extends StatefulWidget {
  const SaveValuations({Key? key}) : super(key: key);

  @override
  State<SaveValuations> createState() => _SaveValuationsState();
}

class _SaveValuationsState extends State<SaveValuations> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  Map map = Map<String, dynamic>();
  @override
  void initState() {
    super.initState();
    context.read<AsessmentProvider>().getValData();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('Saved valuations')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AsessmentProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.valuation.isEmpty) {
                  return const Center(
                      child: Text(
                    'No valuations saved',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.valuation.length,
                      itemBuilder: (context, index) {
                        map = jsonDecode(
                            provider.valuation[index].valuationjson!);
                        return Card(
                          color: Colors.blueGrey.shade200,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // Image(
                                //   height: 80,
                                //   width: 80,
                                //   image:
                                //   AssetImage(provider.cart[index].remarks!),
                                // ),
                                SizedBox(
                                  width: 130,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      map['instructionno'] != 0
                                          ? RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                  text: 'Inst no: ',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .blueGrey.shade800,
                                                      fontSize: 16.0),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            '${map['instructionno']}\n',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ]),
                                            )
                                          : RichText(
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              text: TextSpan(
                                                  text: 'Fleet inst no: ',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .blueGrey.shade800,
                                                      fontSize: 16.0),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            '${map['fleetinstructionno']}\n',
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ]),
                                            ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Reg no: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text: '${map['regno']}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Location: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text: '${map['location']}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: this.context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text('Submit?'),
                                              content: Text(
                                                  'Are you sure you want to submit'),
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
                                                      ProgressDialog dial =
                                                          new ProgressDialog(
                                                              context,
                                                              type:
                                                                  ProgressDialogType
                                                                      .Normal);
                                                      dial.style(
                                                        message:
                                                            'Sending Valuation',
                                                      );
                                                      dial.show();

                                                      String demoUrl =
                                                          await Config
                                                              .getBaseUrl();
                                                      Uri url = Uri.parse(demoUrl +
                                                          'valuation/valuation/');
                                                      print(url);
                                                      try {
                                                        final result =
                                                            await InternetAddress
                                                                .lookup(
                                                                    'google.com');
                                                        if (result.isNotEmpty &&
                                                            result[0]
                                                                .rawAddress
                                                                .isNotEmpty) {
                                                          final response =
                                                              await http
                                                                  .post(url,
                                                                      headers: <
                                                                          String,
                                                                          String>{
                                                                        'Content-Type':
                                                                            'application/json',
                                                                      },
                                                                      body: jsonEncode(<
                                                                          String,
                                                                          dynamic>{
                                                                        "userid":
                                                                            map['userid'],
                                                                        "custid":
                                                                            map['custid'],
                                                                        "revised":
                                                                            map['revised'],
                                                                        "fleetinstructionno":
                                                                            map['fleetinstructionno'],
                                                                        "instructionno":
                                                                            map['instructionno'],
                                                                        "photolist":
                                                                            map['photolist'],
                                                                        "logbooklist":
                                                                            map['logbooklist'],
                                                                        "model":
                                                                            map['model'],
                                                                        "chassisno":
                                                                            map['chassisno'],
                                                                        "fuel":
                                                                            map['fuel'],
                                                                        "manufactureyear":
                                                                            map['manufactureyear'],
                                                                        "origin":
                                                                            map['origin'],
                                                                        "bodytype":
                                                                            map['bodytype'],
                                                                        "mileage":
                                                                            map['mileage'],
                                                                        "enginecapacity":
                                                                            map['enginecapacity'],
                                                                        "engineno":
                                                                            map['engineno'],
                                                                        "make":
                                                                            map['make'],
                                                                        "type":
                                                                            map['type'],
                                                                        "inspectionplace":
                                                                            map['inspectionplace'],
                                                                        "musicsystemvalue":
                                                                            map['musicsystemvalue'],
                                                                        "alloy":
                                                                            map['alloy'],
                                                                        "regno":
                                                                            map['regno'],
                                                                        "location":
                                                                            map['location'],
                                                                        "suspensionspacers":
                                                                            map['suspensionspacers'],
                                                                        "noofdiscs":
                                                                            map['noofdiscs'],
                                                                        "registrationdate":
                                                                            map['registrationdate'],
                                                                        "radiocassette":
                                                                            map['radiocassette'],
                                                                        "cdplayer":
                                                                            map['cdplayer'],
                                                                        "cdchanger":
                                                                            map['cdchanger'],
                                                                        "roadworthy":
                                                                            map['roadworthy'],
                                                                        // "alarm": alarm,
                                                                        "roadworthynotes":
                                                                            map['roadworthynotes'],
                                                                        // "alarmtype": alarmtype,
                                                                        // "discs": discs,
                                                                        "validinsurance":
                                                                            map['validinsurance'],
                                                                        "validinsurance":
                                                                            map['validinsurance'],
                                                                        "bodycondition":
                                                                            map['bodycondition'],
                                                                        "tyres":
                                                                            map['tyres'],
                                                                        "generalcondition":
                                                                            map['generalcondition'],
                                                                        "extras":
                                                                            map['extras'],
                                                                        "notes":
                                                                            map['notes'],
                                                                        "windscreenvalue":
                                                                            map['windscreenvalue'],
                                                                        "antitheftvalue":
                                                                            map['antitheftvalue'],
                                                                        "valuer":
                                                                            map['valuer'],
                                                                        "assessedvalue":
                                                                            map['assessedvalue'],
                                                                        "sparewheel":
                                                                            map['sparewheel'],
                                                                        "tyresize":
                                                                            map['tyresize'],
                                                                        "centrallocking":
                                                                            map['centrallocking'],
                                                                        "powerwindowsrhf":
                                                                            map['powerwindowsrhf'],
                                                                        "powerwindowslhf":
                                                                            map['powerwindowslhf'],
                                                                        "powerwindowsrhr":
                                                                            map['powerwindowsrhr'],
                                                                        "powerwindowslhr":
                                                                            map['powerwindowslhr'],
                                                                        "powermirrors":
                                                                            map['powermirrors'],
                                                                        "powersteering":
                                                                            map['powersteering'],
                                                                        "airconditioner":
                                                                            map['airconditioner'],
                                                                        "absbrakes":
                                                                            map['absbrakes'],
                                                                        "foglights":
                                                                            map['foglights'],
                                                                        "rearspoiler":
                                                                            map['rearspoiler'],
                                                                        "sidesteps":
                                                                            map['sidesteps'],
                                                                        "sunroof":
                                                                            map['sunroof'],
                                                                        "frontgrilleguard":
                                                                            map['frontgrilleguard'],
                                                                        "rearbumperguard":
                                                                            map['rearbumperguard'],
                                                                        "sparewheelcover":
                                                                            map['sparewheelcover'],
                                                                        "seatcovers":
                                                                            map['seatcovers'],
                                                                        "turbotimer":
                                                                            map['turbotimer'],
                                                                        "dashboardairbag":
                                                                            map['dashboardairbag'],
                                                                        "steeringairbag":
                                                                            map['steeringairbag'],
                                                                        "alloyrims":
                                                                            map['alloyrims'],
                                                                        "steelrims":
                                                                            map['steelrims'],
                                                                        "chromerims":
                                                                            map['chromerims'],
                                                                        "assessedvalue":
                                                                            map['assessedvalue'],
                                                                        "xenonheadlights":
                                                                            map['xenonheadlights'],
                                                                        "heightadjustmentsystem":
                                                                            map['heightadjustmentsystem'],
                                                                        "powerslidingrhfdoor":
                                                                            map['powerslidingrhfdoor'],
                                                                        "powerslidinglhfdoor":
                                                                            map['powerslidinglhfdoor'],
                                                                        "powerslidingrhrdoor":
                                                                            map['powerslidingrhrdoor'],
                                                                        "powerslidinglhrdoor":
                                                                            map['powerslidinglhrdoor'],
                                                                        "powerbootdoor":
                                                                            map['powerbootdoor'],
                                                                        "uphostryleatherseat":
                                                                            map['uphostryleatherseat'],
                                                                        "uphostryfabricseat":
                                                                            map['uphostryfabricseat'],
                                                                        "uphostrytwotoneseat":
                                                                            map['uphostrytwotoneseat'],
                                                                        "uphostrybucketseat":
                                                                            map['uphostrybucketseat'],
                                                                        "powerseatrhfadjustment":
                                                                            map['powerseatrhfadjustment'],
                                                                        "powerseatlhfadjustment":
                                                                            map['powerseatlhfadjustment'],
                                                                        "powerseatrhradjustment":
                                                                            map['powerseatrhradjustment'],
                                                                        "powersteeringadjustment":
                                                                            map['powersteeringadjustment'],
                                                                        "powersteeringadjustment":
                                                                            map['powersteeringadjustment'],
                                                                        "extralargerims":
                                                                            map['extralargerims'],
                                                                        "rimsize":
                                                                            map['rimsize'],
                                                                        "noofextracurtains":
                                                                            map['noofextracurtains'],
                                                                        "noofextraseats":
                                                                            map['noofextraseats'],
                                                                        "noofextrakneebags":
                                                                            map['noofextrakneebags'],
                                                                        "frontwindscreen":
                                                                            map['frontwindscreen'],
                                                                        "rearwindscreen":
                                                                            map['rearwindscreen'],
                                                                        "doors":
                                                                            map['doors'],
                                                                        "crackedrearwindscreen":
                                                                            map['crackedrearwindscreen'],
                                                                        "approxmatewindscreenvalue":
                                                                            map['approxmatewindscreenvalue'],
                                                                        "rearwindscreenvalue":
                                                                            map['rearwindscreenvalue'],
                                                                        "musicsystemmodel":
                                                                            map['musicsystemmodel'],
                                                                        "musicsystemmake":
                                                                            map['musicsystemmake'],
                                                                        "inbuiltcassette":
                                                                            map['inbuiltcassette'],
                                                                        "inbuiltcd":
                                                                            map['inbuiltcd'],
                                                                        "inbuiltdvd":
                                                                            map['inbuiltdvd'],
                                                                        "inbuiltmapreader":
                                                                            map['inbuiltmapreader'],
                                                                        "inbuilthddcardreader":
                                                                            map['inbuilthddcardreader'],
                                                                        "inbuiltminidisc":
                                                                            map['inbuiltminidisc'],
                                                                        "inbuiltusb":
                                                                            map['inbuiltusb'],
                                                                        "inbuiltbluetooth":
                                                                            map['inbuiltbluetooth'],
                                                                        "inbuilttvscreen":
                                                                            map['inbuilttvscreen'],
                                                                        "inbuiltcdchanger":
                                                                            map['inbuiltcdchanger'],
                                                                        "inbuiltsecuritydoorlock":
                                                                            map['inbuiltsecuritydoorlock'],
                                                                        "inbuiltalarm":
                                                                            map['inbuiltalarm'],
                                                                        "inbuiltimmobilizer":
                                                                            map['inbuiltimmobilizer'],
                                                                        "keylessignition":
                                                                            map['keylessignition'],
                                                                        "trackingdevice":
                                                                            map['trackingdevice'],
                                                                        "gearleverlock":
                                                                            map['gearleverlock'],
                                                                        "enginecutoff":
                                                                            map['enginecutoff'],
                                                                        "anyotherantitheftfeature":
                                                                            map['anyotherantitheftfeature'],
                                                                        "anyotherextrafeature":
                                                                            map['anyotherextrafeature'],
                                                                        "anyothervehiclefeature":
                                                                            map['anyothervehiclefeature'],
                                                                        "anyotheraddedfeature":
                                                                            map['anyotheraddedfeature'],
                                                                        "anyothermusicsystem":
                                                                            map['anyothermusicsystem'],
                                                                        "noofdoorairbags":
                                                                            map['noofdoorairbags'],
                                                                        "musicsystemdetachable":
                                                                            map['musicsystemdetachable'],
                                                                        "musicsysteminbuilt":
                                                                            map['musicsysteminbuilt'],
                                                                        "fittedwithamfmonly":
                                                                            map['fittedwithamfmonly'],
                                                                        "fittedwithreversecamera":
                                                                            map['fittedwithreversecamera'],
                                                                        "amfmonly":
                                                                            map['amfmonly'],
                                                                        "locallyfittedalarm":
                                                                            map['locallyfittedalarm'],
                                                                        "antitheftmake":
                                                                            map['antitheftmake'],
                                                                        "roofcarrier":
                                                                            map['roofcarrier'],
                                                                        "roofrails":
                                                                            map['roofrails'],
                                                                        "uphostryfabricleatherseat":
                                                                            map['uphostryfabricleatherseat'],
                                                                        "dutypaid":
                                                                            map['dutypaid'],
                                                                        "color":
                                                                            map['color'],
                                                                        "noofbattery":
                                                                            map['noofbattery'],
                                                                        "crawleeexcavator":
                                                                            map['crawleeexcavator'],
                                                                        "backhoewheelloader":
                                                                            map['backhoewheelloader'],
                                                                        "roller":
                                                                            map['roller'],
                                                                        "fixedcrane":
                                                                            map['fixedcrane'],
                                                                        "rollercrane":
                                                                            map['rollercrane'],
                                                                        "mobilecrane":
                                                                            map['mobilecrane'],
                                                                        "hiabfittedcranetruck":
                                                                            map['hiabfittedcranetruck'],
                                                                        "primemover":
                                                                            map['primemover'],
                                                                        "primemoverfilledwithrailercrane":
                                                                            map['primemoverfilledwithrailercrane'],
                                                                        "lowloadertrailer":
                                                                            map['lowloadertrailer'],
                                                                        "concretemixer":
                                                                            map['concretemixer'],
                                                                        "topmacrollers":
                                                                            map['topmacrollers'],
                                                                        "aircompressor":
                                                                            map['aircompressor'],
                                                                        "forklift":
                                                                            map['forklift'],
                                                                        "specialpurposeconstructionmachinery":
                                                                            map['specialpurposeconstructionmachinery'],
                                                                        "batterypoweredlift":
                                                                            map['batterypoweredlift'],
                                                                        "batterypoweredscissorlift":
                                                                            map['batterypoweredscissorlift'],
                                                                        "boomlift":
                                                                            map['boomlift'],
                                                                        "dumptruck":
                                                                            map['dumptruck'],
                                                                        "backheeloader":
                                                                            map['backheeloader'],
                                                                        "vaccumpumpsystem":
                                                                            map['vaccumpumpsystem'],
                                                                        "dryaircompressor":
                                                                            map['dryaircompressor'],
                                                                        "transformeroilpurifizatonplant":
                                                                            map['transformeroilpurifizatonplant'],
                                                                        "dieselgenerator":
                                                                            map['dieselgenerator'],
                                                                        "platecompactor":
                                                                            map['platecompactor'],
                                                                        "twindrumroller":
                                                                            map['twindrumroller'],
                                                                        "tractors":
                                                                            map['tractors'],
                                                                        "plaughs":
                                                                            map['plaughs'],
                                                                        "seeders":
                                                                            map['seeders'],
                                                                        "combineharvester":
                                                                            map['combineharvester'],
                                                                        "sprayers":
                                                                            map['sprayers'],
                                                                        "culters":
                                                                            map['culters'],
                                                                        "balers":
                                                                            map['balers'],
                                                                        "ordinaryfueltankers":
                                                                            map['ordinaryfueltankers'],
                                                                        "watertanker":
                                                                            map['watertanker'],
                                                                        "exhauster":
                                                                            map['exhauster'],
                                                                        "specializedfueltanker":
                                                                            map['specializedfueltanker'],
                                                                        "opensidebody":
                                                                            map['opensidebody'],
                                                                        "closedsidebody":
                                                                            map['closedsidebody'],
                                                                        "trailers":
                                                                            map['trailers'],
                                                                        "fuseboxbypassed":
                                                                            map['fuseboxbypassed'],

                                                                        //other
                                                                        "turbocharger":
                                                                            map['turbocharger'],
                                                                        "lightfitted":
                                                                            map['lightfitted'],
                                                                        "lightfittedok":
                                                                            map['lightfittedok'],
                                                                        "dipswitchok":
                                                                            map['dipswitchok'],
                                                                        "lightdipok":
                                                                            map['lightdipok'],
                                                                        "rearlightclean":
                                                                            map['rearlightclean'],
                                                                        "handbrakeok":
                                                                            map['handbrakeok'],
                                                                        "hydraulicsystemok":
                                                                            map['hydraulicsystemok'],
                                                                        "servook":
                                                                            map['servook'],
                                                                        "handbreakmarginok":
                                                                            map['handbreakmarginok'],
                                                                        "footbreakmarginok":
                                                                            map['footbreakmarginok'],
                                                                        "balljointsok":
                                                                            map['balljointsok'],
                                                                        "jointsstatus":
                                                                            map['jointsstatus'],
                                                                        "wheelalignment":
                                                                            map['wheelalignment'],
                                                                        "wheelbalanced":
                                                                            map['wheelbalanced'],
                                                                        "chassisok":
                                                                            map['chassisok'],
                                                                        "fuelpumptank":
                                                                            map['fuelpumptank'],
                                                                        "antitheftdevicefitted":
                                                                            map['antitheftdevicefitted'],
                                                                        "vehiclefit":
                                                                            map['vehiclefit'],
                                                                        "vehicleconformrules":
                                                                            map['vehicleconformrules'],
                                                                        "speedgovernorfitted":
                                                                            map['speedgovernorfitted'],

                                                                        //double
                                                                        "loadcapacity":
                                                                            map['loadcapacity'],
                                                                        //int
                                                                        "seatingcapacity":
                                                                            map['seatingcapacity'],
                                                                        //dtring
                                                                        "handdrivetype":
                                                                            map['handdrivetype'],
                                                                        "turbochargerdesc":
                                                                            map['turbochargerdesc'],
                                                                        "footbreakok":
                                                                            map['footbreakok'],
                                                                        "frontnearside1":
                                                                            map['frontnearside1'],
                                                                        "frontoffside1":
                                                                            map['frontoffside1'],
                                                                        "rearnearside1":
                                                                            map['rearnearside1'],
                                                                        "rearnearsideouter1":
                                                                            map['rearnearsideouter1'],
                                                                        "rearoffsideinner1":
                                                                            map['rearoffsideinner1'],
                                                                        "rearoffsideouter1":
                                                                            map['rearoffsideouter1'],
                                                                        "sparetyre1":
                                                                            map['sparetyre1'],
                                                                        "frontnearside2":
                                                                            map['frontnearside2'],
                                                                        "frontoffside2":
                                                                            map['frontoffside2'],
                                                                        "rearnearside2":
                                                                            map['rearnearside2'],
                                                                        "rearnearsideouter2":
                                                                            map['rearnearsideouter2'],
                                                                        "rearoffsideinner2":
                                                                            map['rearoffsideinner2'],
                                                                        "rearoffsideouter2":
                                                                            map['rearoffsideouter2'],
                                                                        "sparetyre2":
                                                                            map['sparetyre2'],
                                                                        "mechanicalcondition":
                                                                            map['mechanicalcondition'],
                                                                        "steeringboxstatus":
                                                                            map['steeringboxstatus'],
                                                                        "jointsdefect":
                                                                            map['jointsdefect'],
                                                                        "powerseatlhradjustment":
                                                                            map['powerseatlhradjustment'],
                                                                        "bodyworkok":
                                                                            map['bodyworkok'],
                                                                        "repairgoodstandard":
                                                                            map['repairgoodstandard'],
                                                                        "windscreendoor":
                                                                            map['windscreendoor'],
                                                                        "antitheftdevicedesc":
                                                                            map['antitheftdevicedesc'],
                                                                      }))
                                                                  .timeout(
                                                            Duration(
                                                                seconds: 5),
                                                            onTimeout: () {
                                                              // Time has run out, do what you wanted to do.
                                                              dial.hide();
                                                              return http.Response(
                                                                  'Error',
                                                                  408); // Request Timeout response status code
                                                            },
                                                          );
                                                          print(valuationsJson);
                                                          print(index);
                                                          if (response
                                                                  .statusCode !=
                                                              null) {
                                                            dial.hide();
                                                            int statusCode =
                                                                response
                                                                    .statusCode;
                                                            if (statusCode ==
                                                                200) {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Suucessful!');
                                                              dbHelper!.deleteValuationItem(
                                                                  provider
                                                                      .valuation[
                                                                          index]
                                                                      .id!);
                                                              provider.removeValItem(
                                                                  provider
                                                                      .valuation[
                                                                          index]
                                                                      .id!);
                                                              Navigator
                                                                  .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            Home()),
                                                              );
                                                            } else {
                                                              print("Submit Status code::" +
                                                                  response.body
                                                                      .toString());
                                                              showAlertDialog(
                                                                  this.context,
                                                                  response
                                                                      .body);
                                                            }
                                                          } else {
                                                            dial.hide();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'There was no response from the server');
                                                          }
                                                        }
                                                      } on SocketException catch (e) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Failed! Make sure you have stable internet');
                                                      }
                                                    },
                                                    child: Text('Yes'))
                                              ],
                                            );
                                          });
                                    },
                                    icon: Icon(
                                      Icons.send,
                                      color: Colors.blue,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: this.context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: Text('Delete?'),
                                              content: Text(
                                                  'Are you sure you want to delete'),
                                              actions: <Widget>[
                                                MaterialButton(
                                                    child: Text('No'),
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                    }),
                                                MaterialButton(
                                                    onPressed: () async {
                                                      dbHelper!.deleteValuationItem(
                                                          provider.valuation[index].id!);
                                                      provider.removeValItem(
                                                          provider.valuation[index].id!);
                                                      Navigator.pop(ctx);
                                                    },
                                                    child: Text('Yes'))
                                              ],
                                            );
                                          });

                                      // provider.removeCounter();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade800,
                                    )),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
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
