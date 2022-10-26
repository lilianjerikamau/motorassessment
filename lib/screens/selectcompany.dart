import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/screens/login_screen.dart';
import 'package:motorassesmentapp/utils/config.dart';

class ChooseCompany extends StatefulWidget {
  void Function(String) companySelected;
  ChooseCompany(this.companySelected);

  @override
  _ChooseCompanyState createState() => _ChooseCompanyState();
}

class _ChooseCompanyState extends State<ChooseCompany> {
  final _companysettingurl = new TextEditingController();
  final _companyUrlKey = GlobalKey<FormState>();
  late String? _imgFromSettings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _companyUrlKey,
      appBar: AppBar(
          title: Text('Configure you current Company'),
          automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _companysettingurl,
                validator: (input) {
                  if (input!.isEmpty) {
                    return 'Enter Company URL';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide()),
                    labelText: 'Enter Company URL'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_companysettingurl.text.isEmpty) {
                  Fluttertoast.showToast(
                      msg: "Please enter company url....",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  'Enter Company URL';
                } else {
                  SessionPreferences()
                      .setCompanySettings(CompanySettings(
                          baseUrl: erpUrl + _companysettingurl.text + domainUrl,
                          imageName: 'logo.png'))
                      .then((value) {
                    widget.companySelected('logo.png');
                  });
                  _loadImageFromSettings();
                  Fluttertoast.showToast(
                      msg: "Company setting updated successfully....",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      textColor: Colors.amberAccent);
                  Navigator.pushReplacement<void, void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => LoginPage(),
                    ),
                  );
                }
              },
              child: Text('Update Company'),
            ),
          ],
        ),
      ),
    );
  }

  void _loadImageFromSettings() async {
    CompanySettings settings = await SessionPreferences().getCompanySettings();
    setState(() {
      _imgFromSettings = settings.imageName;
    });
  }
}
