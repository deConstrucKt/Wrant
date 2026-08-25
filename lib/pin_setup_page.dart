import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrant/database/secure_storage.dart';
import 'package:wrant/home.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({Key? key}) : super(key: key);

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {

  final PinInputController _pinInputController1 = PinInputController();
  final PinInputController _pinInputController2 = PinInputController();

  final SecureStorage _secureStorage = SecureStorage();

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
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style: GoogleFonts.sniglet(fontSize: 20),
                    ),
                    SizedBox(height: 10,),
                    Text("Wrant", style: GoogleFonts.windSong(fontSize: 60, fontWeight: FontWeight.bold),),
                    SizedBox(height: 25,),
                    Text(
                      "To proceed further, you have to setup a PIN first",
                      style: GoogleFonts.sniglet(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40,),
                    Center(
                      child: MaterialPinField(
                        length: 6,
                        pinController: _pinInputController1,
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
                    SizedBox(height: 40,),
                    Text(
                      "Confirm your PIN",
                      style: GoogleFonts.sniglet(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: MaterialPinField(
                        length: 6,
                        pinController: _pinInputController2,
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
                    SizedBox(height: 60,),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                              onPressed: _setupAndContinue,
                              child: Text(
                                "Continue",
                                style: GoogleFonts.sniglet(fontSize: 15),
                              )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setupAndContinue() async {
    final String pin = _pinInputController1.text;
    final String confirmedPin = _pinInputController2.text;

    if (pin != confirmedPin) {
      Fluttertoast.showToast(
        msg: "PIN mismatch",
        backgroundColor: Colors.red,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
      );

      return;
    }

    await _secureStorage.savePIN(pin);

    String tokenKey = "";
    String charList = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890&^#@!*";

    for (int i = 0; i <= 25; i++) {
      final int upperLimit = charList.length;
      final int randomNum = Random().nextInt(upperLimit);
      final String char = charList[randomNum];

      tokenKey += char;
    }

    await _secureStorage.saveTokenKey(tokenKey);

    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              spacing: 10,
              children: [
                Text(
                  "Here's your special token key which will be needed in case you forget your PIN. Keep it safely",
                  style: GoogleFonts.sniglet(fontSize: 15),
                ),
                SizedBox(height: 10,),
                Text(
                  tokenKey,
                  style: GoogleFonts.sniglet(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              await Clipboard.setData(ClipboardData(text: tokenKey));

                              Fluttertoast.showToast(
                                msg: "Token key copied successfully!",
                                backgroundColor: Colors.green,
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_SHORT,
                              );
                            },
                            child: Text(
                              "Copy token",
                              style: GoogleFonts.sniglet(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              final SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
                              _sharedPreferences.setBool("isPinSet", true);

                              if (mounted) {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute<void>(
                                      builder: (context) => HomePage(),
                                    ),
                                        (Route<dynamic> route) => false
                                );
                              }
                            },
                            child: Text(
                              "Ok",
                              style: GoogleFonts.sniglet(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        }
    );
  }
}
