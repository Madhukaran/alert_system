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

    // try {

    //   // Stop scanning
    //   // flutterBlue.stopScan();
    // } catch (e) {
    //   print(e);
    // }
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
      _scanAvailableDevices(context);
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
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ListView(
                children: <Widget>[Lottie.asset('assets/images/gadgets.json')],
              ),
            ),
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
                      children: snapshot.data!
                          .map((r) => Text(r.device.name,
                              style: const TextStyle(fontSize: 20)))
                          .toList(),
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

// class DeviceScreen extends StatelessWidget {
//   const DeviceScreen({Key? key, required this.device}) : super(key: key);

//   final BluetoothDevice device;

//   List<int> _getRandomBytes() {
//     final math = Random();
//     return [
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255),
//       math.nextInt(255)
//     ];
//   }

//   List<Widget> _buildServiceTiles(List<BluetoothService> services) {
//     return services
//         .map(
//           (s) => ServiceTile(
//             service: s,
//             characteristicTiles: s.characteristics
//                 .map(
//                   (c) => CharacteristicTile(
//                     characteristic: c,
//                     onReadPressed: () => c.read(),
//                     onWritePressed: () async {
//                       await c.write(_getRandomBytes(), withoutResponse: true);
//                       await c.read();
//                     },
//                     onNotificationPressed: () async {
//                       await c.setNotifyValue(!c.isNotifying);
//                       await c.read();
//                     },
//                     descriptorTiles: c.descriptors
//                         .map(
//                           (d) => DescriptorTile(
//                             descriptor: d,
//                             onReadPressed: () => d.read(),
//                             onWritePressed: () => d.write(_getRandomBytes()),
//                           ),
//                         )
//                         .toList(),
//                   ),
//                 )
//                 .toList(),
//           ),
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(device.name),
//         actions: <Widget>[
//           StreamBuilder<BluetoothDeviceState>(
//             stream: device.state,
//             initialData: BluetoothDeviceState.connecting,
//             builder: (c, snapshot) {
//               VoidCallback? onPressed;
//               String text;
//               switch (snapshot.data) {
//                 case BluetoothDeviceState.connected:
//                   onPressed = () => device.disconnect();
//                   text = 'DISCONNECT';
//                   break;
//                 case BluetoothDeviceState.disconnected:
//                   onPressed = () => device.connect();
//                   text = 'CONNECT';
//                   break;
//                 default:
//                   onPressed = null;
//                   text = snapshot.data.toString().substring(21).toUpperCase();
//                   break;
//               }
//               return ElevatedButton(
//                   onPressed: onPressed,
//                   child: Text(
//                     text,
//                     style: Theme.of(context)
//                         .primaryTextTheme
//                         .button
//                         ?.copyWith(color: Colors.white),
//                   ));
//             },
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             StreamBuilder<BluetoothDeviceState>(
//               stream: device.state,
//               initialData: BluetoothDeviceState.connecting,
//               builder: (c, snapshot) => ListTile(
//                 leading: (snapshot.data == BluetoothDeviceState.connected)
//                     ? Icon(Icons.bluetooth_connected)
//                     : Icon(Icons.bluetooth_disabled),
//                 title: Text(
//                     'Device is ${snapshot.data.toString().split('.')[1]}.'),
//                 subtitle: Text('${device.id}'),
//                 trailing: StreamBuilder<bool>(
//                   stream: device.isDiscoveringServices,
//                   initialData: false,
//                   builder: (c, snapshot) => IndexedStack(
//                     index: snapshot.data! ? 1 : 0,
//                     children: <Widget>[
//                       IconButton(
//                         icon: Icon(Icons.refresh),
//                         onPressed: () => device.discoverServices(),
//                       ),
//                       IconButton(
//                         icon: SizedBox(
//                           child: CircularProgressIndicator(
//                             valueColor: AlwaysStoppedAnimation(Colors.grey),
//                           ),
//                           width: 18.0,
//                           height: 18.0,
//                         ),
//                         onPressed: null,
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             StreamBuilder<int>(
//               stream: device.mtu,
//               initialData: 0,
//               builder: (c, snapshot) => ListTile(
//                 title: Text('MTU Size'),
//                 subtitle: Text('${snapshot.data} bytes'),
//                 trailing: IconButton(
//                   icon: Icon(Icons.edit),
//                   onPressed: () => device.requestMtu(223),
//                 ),
//               ),
//             ),
//             StreamBuilder<List<BluetoothService>>(
//               stream: device.services,
//               initialData: [],
//               builder: (c, snapshot) {
//                 return Column(
//                   children: _buildServiceTiles(snapshot.data!),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
