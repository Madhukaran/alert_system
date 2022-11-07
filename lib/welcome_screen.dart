import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        alignment: Alignment.center,
        textStyle:
            const TextStyle(fontSize: 20, backgroundColor: Colors.black));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(209, 238, 106, 1),
        shadowColor: const Color.fromARGB(0, 244, 67, 54),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("images/alert_system.gif"),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                      icon: const Icon(Icons.more),
                      style: style,
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      label: const Text('Getting Started')))
            ],
          )
        ],
      ),
      backgroundColor: const Color.fromRGBO(209, 238, 106, 1),
    );
  }
}
