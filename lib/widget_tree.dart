import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrant/pin_check.dart';
import 'package:wrant/pin_setup_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isPinSet(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return PinCheckPage();
            }
            return PinSetupPage();
          }
          return const CircularProgressIndicator();
        });
  }

  Future<bool> _isPinSet() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    bool? isPinSet = sharedPreferences.getBool("isPinSet");

    if (isPinSet == null || isPinSet == false) {
      return false;
    }
    else {
      return true;
    }
  }
}
