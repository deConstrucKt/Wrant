import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrant/database/secure_storage.dart';
import 'package:wrant/pin_reset.dart';

import 'home.dart';

class PinCheckPage extends StatefulWidget {
  const PinCheckPage({Key? key}) : super(key: key);

  @override
  State<PinCheckPage> createState() => _PinCheckPageState();
}

class _PinCheckPageState extends State<PinCheckPage> {

  final SecureStorage _secureStorage = SecureStorage();

  final PinInputController _pinInputController = PinInputController();
  final TextEditingController _keyInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome back",
                    style: GoogleFonts.sniglet(fontSize: 25, fontWeight: FontWeight.w600, letterSpacing: 1),
                  ),
                  SizedBox(height: 50,),
                  Text(
                    "Enter your PIN",
                    style: GoogleFonts.sniglet(fontSize: 15),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: MaterialPinField(
                      length: 6,
                      pinController: _pinInputController,
                      obscureText: true,
                      theme: MaterialPinTheme(
                          shape: MaterialPinShape.circle,
                          cellSize: Size(36, 36),
                          fillColor: Colors.grey.shade300,
                          focusedFillColor: Colors.grey.shade400,
                          completeFillColor: Colors.grey.shade300,
                          followingFillColor: Colors.grey.shade300,
                          focusedBorderColor: Colors.black54
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _forgotPIN,
                    child: Text(
                      "Forgot PIN?",
                      style: GoogleFonts.sniglet(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue
                      )
                    )
                  ),
                  SizedBox(height: 80,),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () async {
                            final String pin = _pinInputController.text;
                            final String? originalPin = await _secureStorage.getPIN();

                            if (originalPin == null) { return; }

                            if (originalPin == pin) {
                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute<void>(
                                      builder: (context) => HomePage(),
                                    ),
                                        (Route<dynamic> route) => false
                                );
                              }
                            }
                            else {
                              Fluttertoast.showToast(
                                msg: "Invalid PIN",
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            }
                          },
                          child: Text(
                            "Continue",
                            style: GoogleFonts.sniglet(fontSize: 15),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _forgotPIN() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Forgot PIN",
              style: GoogleFonts.sniglet(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            content: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the token key provided earlier to proceed further",
                    style: GoogleFonts.sniglet(fontSize: 15),
                  ),
                  SizedBox(height: 10,),
                  TextField(
                    controller: _keyInputController,
                    style: GoogleFonts.sniglet(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "Key.....",
                    ),
                    autofocus: true,
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
            actions: [
              FilledButton(
                onPressed: () async {
                  final String? key = await _secureStorage.getTokenKey();
                  final SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();


                  if (key == null) {
                    return;
                  }
                  final String userInputKey = _keyInputController.text;

                  if (key == userInputKey) {
                    print('ok');
                    _secureStorage.deletePIN();
                    _sharedPreferences.setBool("isPinSet", false);

                    if (mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => PinResetPage(),
                        ),
                      );
                    }
                  } else {
                    Fluttertoast.showToast(
                      msg: "Key authentication failed",
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                },
                child: Text(
                  "Authenticate",
                  style: GoogleFonts.sniglet(fontSize: 15),
                ),
              ),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.sniglet(fontSize: 15),
                  )
              )
            ],
          );
        }
    );
  }
}
