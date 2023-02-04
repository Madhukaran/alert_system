import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDevice extends StatelessWidget {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  late Future __checkMyPermissions;

  AddDevice() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color.fromRGBO(200, 201, 196, 1)));
  }

  Future get initializationDone => __checkMyPermissions;

  _checkSetingsIsEnabled(context) async {
    var bluetoothStatus = await _checkDeviceBluetoothIsOn();
    var locationStatus = await _checkDeviceLocationIsOn();
    if (!bluetoothStatus) {
      _displaySnack(context, "Please Turn On the Bluetooth");
    }
    if (!locationStatus) {
      _displaySnack(context, "Please Turn On the Location");
    }
    if (bluetoothStatus && locationStatus) {
      // _scanAvailableDevices(context);
    }
  }

  _scanAvailableDevices(context) async {
    try {
      // Start scanning
      flutterBlue
          .startScan(
              timeout: const Duration(seconds: 10), scanMode: ScanMode.balanced)
          .onError((error, stackTrace) => debugPrint("madhu $error"));

      // Listen to scan results
      var subscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('${r.device.name} found! rssi: ${r.rssi}');
        }
      });
      _displaySnack(context, "Searching for Devices!");
    } catch (error) {
      debugPrint("madhu $error");
      _displaySnack(context, "Already scan is in progress");
    }
  }

  _displaySnack(context, String message) {
    var snackBar = SnackBar(
      padding: const EdgeInsets.all(15),
      backgroundColor: const Color.fromRGBO(36, 41, 45, 1),
      width: 250,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      content: Text(message, textAlign: TextAlign.center),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _checkDeviceBluetoothIsOn() async {
    return await flutterBlue.isOn;
  }

  _checkDeviceLocationIsOn() async {
    return await Permission.locationWhenInUse.serviceStatus.isEnabled;
  }

  @override
  Widget device(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const ListTile(
              // tileColor: Color.fromRGBO(209, 238, 106, 1),
              leading: Icon(Icons.album),
              title: Text('The Enchanted Nightingale'),
              subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('LISTEN'),
                  onPressed: () {/* ... */},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
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

    __checkMyPermissions = _checkSetingsIsEnabled(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(209, 238, 106, 1),
        shadowColor: const Color.fromARGB(0, 244, 67, 54),
        leading: IconButton(
            onPressed: () {}, icon: const Icon(Icons.arrow_circle_left)),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                _scanAvailableDevices(context);
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text(
          "Searching for Devices!",
          textScaleFactor: 1,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        // margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // Expanded(
            //   flex: 1,
            //   child: ListView(
            //     children: <Widget>[Lottie.asset('assets/images/gadgets.json')],
            //   ),
            // ),
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: Stream.periodic(Duration(seconds: 2))
                        .asyncMap((_) => FlutterBlue.instance.connectedDevices),
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data!
                          .map((d) => ListTile(
                                title: Text(d.name),
                                subtitle: Text(d.id.toString()),
                                trailing: StreamBuilder<BluetoothDeviceState>(
                                  stream: d.state,
                                  initialData:
                                      BluetoothDeviceState.disconnected,
                                  builder: (c, snapshot) {
                                    if (snapshot.data ==
                                        BluetoothDeviceState.connected) {
                                      return ElevatedButton(
                                          child: const Text('OPEN'),
                                          onPressed: () => {});
                                    }
                                    return Text(snapshot.data.toString());
                                  },
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  StreamBuilder<List<ScanResult>>(
                    stream: FlutterBlue.instance.scanResults,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children:
                          snapshot.data!.map((r) => device(context)).toList(),
                    ),
                  ),
                ],
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
                        label: const Text("next")),
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
