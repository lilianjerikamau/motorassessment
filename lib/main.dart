import 'package:flutter/material.dart';
import 'package:motorassesmentapp/provider/assessment_provider.dart';
import 'package:motorassesmentapp/screens/create_instruction.dart';
import 'package:motorassesmentapp/screens/login_screen.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(MyApp());
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
    ChangeNotifierProvider(
      create: (_) => AsessmentProvider(),

      child: Builder(builder: (context) {
        WidgetsFlutterBinding.ensureInitialized();
        return MaterialApp(
          // theme: ThemeData(
          //     scaffoldBackgroundColor: Colors.white, primaryColor: Colors.white),
          home:  LoginPage(),
        );
      }),
    );
  }
}
