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

  late User _loggedInUser;
  String? _username;
  String? _company;
  bool _loggedIn = false;

  BuildContext? _context;
  @override
  Widget build(BuildContext context) {
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
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 100,
                            ),
                          ),
                          color: Theme.of(context).primaryColorDark),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
                      child: _username != null
                          ? Text('User Name : ' + _loggedInUser.username!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16))
                          : const Text("user",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 1, 2, 1),
                      child: _company != null
                          ? Text('Company Name : ' + _company!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16))
                          : const Text("Company Name",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColorDark),
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                title:
                    const Text('Home', style: TextStyle(color: Colors.black)),
                onTap: () => {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  )
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.assessment,
                  color: Colors.black,
                ),
                title: const Text('Create Assessment',
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
                leading: const Icon(
                  Icons.check_circle,
                  color: Colors.black,
                ),
                title: const Text('Create Valuation',
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
                leading: const Icon(
                  Icons.inventory_sharp,
                  color: Colors.black,
                ),
                title: const Text('Create Re-Inspection',
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
                leading: const Icon(
                  Icons.work,
                  color: Colors.black,
                ),
                title: const Text('Create Supplementary',
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
              const SizedBox(
                height: 150,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  hoverColor: Colors.black,
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -4),
                  leading: const Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                  ),
                  title: const Text('Logout'),
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
