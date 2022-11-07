import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/gestures.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(6, 6, 0, 6),
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
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.widgets)),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
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
                    "Build your community around Health,Fitness, and Wellness.",
                    textScaleFactor: 3,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Lottie.asset('assets/images/alert_system.json')
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
                        label: const Text("Get Started")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                              text: "Already have an Account?",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                            text: "Sign In.",
                            style: const TextStyle(
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => print("Privacy Policy"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(5),
                  //   child: RichText(
                  //     textAlign: TextAlign.center,
                  //     text: TextSpan(
                  //       children: [
                  //         const TextSpan(
                  //             text: "By Clicking Sign up you are agree to the ",
                  //             style: TextStyle(color: Colors.black)),
                  //         TextSpan(
                  //           text: "Privacy Policy ",
                  //           style: const TextStyle(
                  //             color: Colors.black,
                  //           ),
                  //           recognizer: TapGestureRecognizer()
                  //             ..onTap = () => print("Privacy Policy"),
                  //         ),
                  //         const TextSpan(text: "and our "),
                  //         TextSpan(
                  //           text: "Terms and Conditions ",
                  //           style: const TextStyle(
                  //             color: Colors.black,
                  //           ),
                  //           recognizer: TapGestureRecognizer()
                  //             ..onTap = () => print("Terms and Conditions"),
                  //         ),
                  //         const TextSpan(text: "and "),
                  //         TextSpan(
                  //           text: "Cookie Statement .",
                  //           style: const TextStyle(
                  //             color: Colors.black,
                  //           ),
                  //           recognizer: TapGestureRecognizer()
                  //             ..onTap = () => print("Cookie Statement"),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
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
