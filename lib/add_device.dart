import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

class AddDevice extends StatelessWidget {
  AddDevice() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(200, 201, 196, 1)));

    FlutterBlue flutterBlue = FlutterBlue.instance;
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });

    // Stop scanning
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
        backgroundColor: Colors.black,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        textStyle:
            const TextStyle(fontSize: 30, backgroundColor: Colors.black));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(209, 238, 106, 1),
        shadowColor: const Color.fromARGB(0, 244, 67, 54),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_circle_left)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Column(
                children: const <Widget>[
                  Text(
                    "Searching for Devices!",
                    textScaleFactor: 3,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: const <Widget>[],
              ),
            ),
            Expanded(
              flex: 0,
              child: Column(
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                        style: style,
                        icon: const Icon(
                          Icons.arrow_circle_right,
                          size: 60,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        label: const Text("Get Started")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(209, 238, 106, 1),
    );
  }
}
