import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motorassesmentapp/screens/home.dart';

import '../database/db_helper.dart';
import '../provider/assessment_provider.dart';
import 'package:provider/provider.dart';
import 'create_instruction.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/db_helper.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../provider/assessment_provider.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;

class SaveAssessments extends StatefulWidget {
  const SaveAssessments({Key? key}) : super(key: key);

  @override
  State<SaveAssessments> createState() => _SaveAssessmentsState();
}

class _SaveAssessmentsState extends State<SaveAssessments> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];
  Map map = Map<String, dynamic>();
  @override
  void initState() {
    super.initState();
    context.read<AsessmentProvider>().getData();
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
          title: Text('Saved Assessments')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<AsessmentProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.assessment.isEmpty) {
                  return const Center(
                      child: Text(
                    'No Assessments Saved',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  ));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.assessment.length,
                      itemBuilder: (context, index) {
                        map = jsonDecode(
                            provider.assessment[index].assessmentjson!);
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
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Inst no: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      '${map['instructionno']}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ]),
                                      ),
                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: 'Regno no: ',
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
                                            text: 'Remarks: ',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 16.0),
                                            children: [
                                              TextSpan(
                                                  text: '${map['remarks']}\n',
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
                                                      try {
                                                        final result =
                                                            await InternetAddress
                                                                .lookup(
                                                                    'google.com');
                                                        if (result.isNotEmpty &&
                                                            result[0]
                                                                .rawAddress
                                                                .isNotEmpty) {
                                                          String demoUrl =
                                                              await Config
                                                                  .getBaseUrl();
                                                          Uri url = Uri.parse(
                                                              demoUrl +
                                                                  'valuation/assessment/');
                                                          print(url);

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
                                                                        "cashinlieu":
                                                                            map['cashinlieu'],
                                                                        "instructionno":
                                                                            map['instructionno'],
                                                                        "yardname":
                                                                            map['yardname'],
                                                                        "regno":
                                                                            map['regno'],
                                                                        "driven":
                                                                            map['driven'],
                                                                        "drivenby":
                                                                            map['drivenby'],
                                                                        "towed":
                                                                            map['towed'],
                                                                        "remarks":
                                                                            map['remarks'],
                                                                        "make":
                                                                            map['make'],
                                                                        "model":
                                                                            map['model'],
                                                                        "type":
                                                                            map['type'],
                                                                        "year":
                                                                            map['year'],
                                                                        "mileage":
                                                                            map['mileage'],
                                                                        "color":
                                                                            map['color'],
                                                                        "engineno":
                                                                            map['engineno'],
                                                                        "chassisno":
                                                                            map['chassisno'],
                                                                        "pav": map[
                                                                            'pav'],
                                                                        "salvage":
                                                                            map['salvage'],
                                                                        "brakes":
                                                                            map['brakes'],
                                                                        "paintwork":
                                                                            map['paintwork'],
                                                                        "steering":
                                                                            map['remarks'],
                                                                        "RHF": map[
                                                                            'RHF'],
                                                                        "LHR": map[
                                                                            'LHR'],
                                                                        "RHR": map[
                                                                            'RHR'],
                                                                        "LHF": map[
                                                                            'LHF'],
                                                                        "Spare":
                                                                            map['Spare'],
                                                                        "damagesobserved":
                                                                            map['damagesobserved'],
                                                                        "photolist":
                                                                            map['photolist'],
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
                                                                          'Sucessful!');
                                                              dbHelper!.deleteAssesssmentItem(
                                                                  provider
                                                                      .assessment[
                                                                          index]
                                                                      .id!);
                                                              provider.removeItem(
                                                                  provider
                                                                      .assessment[
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
                                                        print('not connected2');
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                'Failed!Ensure you have a stable internet connection');
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
                                                      dbHelper!.deleteAssesssmentItem(
                                                          provider.assessment[index].id!);
                                                      provider.removeItem(
                                                          provider.assessment[index].id!);
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
