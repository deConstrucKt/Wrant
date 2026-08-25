import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrant/database/secure_storage.dart';

import 'home.dart';

class PinResetPage extends StatefulWidget {
  const PinResetPage({Key? key}) : super(key: key);

  @override
  State<PinResetPage> createState() => _PinResetPageState();
}

class _PinResetPageState extends State<PinResetPage> {

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
            padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Reset PIN",
                      style: GoogleFonts.sniglet(fontSize: 22),
                    ),
                    SizedBox(height: 30,),
                    MaterialPinField(
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
                    SizedBox(height: 30,),
                    Text(
                      "Confirm PIN",
                      style: GoogleFonts.sniglet(fontSize: 15),
                    ),
                    SizedBox(height: 10,),
                    MaterialPinField(
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
                    SizedBox(height: 60,),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: _checkAndSetup,
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
      ),
    );
  }

  void _checkAndSetup() async {
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

    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await _secureStorage.savePIN(pin);
    sharedPreferences.setBool("isPinSet", true);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(
            builder: (context) => HomePage(),
          ),
              (Route<dynamic> route) => false
      );
    }

  }
}
