import 'package:flutter/material.dart';
import 'package:motorassesmentapp/database/sessionpreferences.dart';
import 'package:motorassesmentapp/models/usermodels.dart';
import 'package:motorassesmentapp/screens/create_assesment.dart';

import 'package:motorassesmentapp/screens/create_instruction.dart';
import 'package:motorassesmentapp/screens/create_reinspection.dart';
import 'package:motorassesmentapp/screens/create_supplementary.dart';
import 'package:motorassesmentapp/screens/create_valuationstd.dart';
import 'package:motorassesmentapp/screens/home.dart';
import 'package:motorassesmentapp/screens/login_screen.dart';
import 'package:motorassesmentapp/screens/newpass.dart';
import 'package:motorassesmentapp/utils/config.dart' as Config;
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatefulWidget {
  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  initState() {
    SessionPreferences().getLoggedInStatus().then((loggedIn) {
      if (loggedIn == null) {
        setState(() {
          _loggedIn = false;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          print("logged in is null");
        });
      } else {
        setState(() {
          _loggedIn = loggedIn;
          print("logged in not null");
        });
      }
    });
    SessionPreferences().getLoggedInUser().then((user) {
      setState(() {
        _loggedInUser = user;
        _username = user.username;
        _company = user.companyname;
      });
    });
    super.initState();
  }

  Future<void>? _launched;
  late User _loggedInUser;
  String? _username;
  String? _company;
  bool _loggedIn = false;

  BuildContext? _context;
  @override
  Widget build(BuildContext context) {
    final Uri toLaunch = Uri(
        scheme: 'https', host: 'www.anchorerp.co.ke', path: 'privacy-policy');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 100,
                            ),
                          ),
                          color: Theme.of(context).primaryColorDark),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                      child: _username != null
                          ? Text('User Name : ' + _loggedInUser.username!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16))
                          : Text("user",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(2, 1, 2, 1),
                      child: _company != null
                          ? Text('Company Name : ' + _company!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16))
                          : Text("Company Name",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorDark),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title: Text('Home', style: TextStyle(color: Colors.black)),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  )
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.assessment,
                  color: Colors.black,
                ),
                title: Text('Create Assessment',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAssesment()),
                  ),
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.check_circle,
                  color: Colors.black,
                ),
                title: Text('Create Valuation',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => CreateValuation()),
                  ),
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.inventory_sharp,
                  color: Colors.black,
                ),
                title: Text('Create Re-Inspection',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateReinspection()),
                  ),
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.work,
                  color: Colors.black,
                ),
                title: Text('Create Supplementary',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateSupplementary()),
                  ),
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.lock_open,
                  color: Colors.black,
                ),
                title: Text('Change Password',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewPass(Config.changePass)),
                  ),
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.document_scanner,
                  color: Colors.black,
                ),
                title: Text('Privacy Policy',
                    style: TextStyle(
                      color: Colors.blue,
                    )),
                onTap: () => {_launched = _launchInBrowser(toLaunch)},
              ),
              SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  hoverColor: Colors.black,
                  dense: true,
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                  ),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    setState(() {
                      SessionPreferences().setLoggedInStatus(false);
                      _loggedIn = false;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future<void> _launchInBrowser(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}
