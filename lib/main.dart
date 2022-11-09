import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'welcome_screen.dart';
import 'home_page.dart';
import 'add_device.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var c = MyApp();
  await c.initializationDone;
  runApp(c);
}

class MyApp extends StatelessWidget {
  late Future _mypermissions;

  MyApp() {
    _mypermissions = _init();
    print("hello");
  }

  Future _init() async {
    if (await Permission.location.status.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.bluetoothScan.status.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetooth.status.isDenied) {
      await Permission.bluetooth.request();
    }
    if (await Permission.bluetoothConnect.status.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    if (await Permission.bluetooth.status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future get initializationDone => _mypermissions;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(209, 238, 106, 1)));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: const Color.fromRGBO(209, 238, 106, 1),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/addDevice': (context) => AddDevice(),
      },
    );
  }
}
