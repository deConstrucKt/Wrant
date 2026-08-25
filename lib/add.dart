import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wrant/constants/color_map.dart';
import 'package:wrant/constants/data_dict_keys.dart';
import 'package:wrant/cryptography/crypto.dart';
import 'package:wrant/database/database_helper.dart';

enum ColorsToPick { black, green, lightBlue, pink, orange, teal }

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  ColorsToPick selectedColor = ColorsToPick.black;

  final TextEditingController _titleEditController = TextEditingController();
  final TextEditingController _contentEditController = TextEditingController();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  late final String _currentDate;
  late final String _currentTime;
  late final String _currentDay;

  @override
  void initState() {
    _updateDateTimeAndDay();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        appBar: AppBar(
            leading: BackButton(),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            )
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleEditController,
                  style: GoogleFonts.sniglet(fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: "What do you want to rant about"
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text(_currentDate, style: GoogleFonts.sniglet(fontSize: 12, fontWeight: FontWeight.w100,)),
                    SizedBox(width: 20,),
                    Text(_currentDay, style: GoogleFonts.sniglet(fontSize: 12, fontWeight: FontWeight.w100,)),
                    SizedBox(width: 20,),
                    Text(_currentTime, style: GoogleFonts.sniglet(fontSize: 12, fontWeight: FontWeight.w100,)),
                    SizedBox(width: 20,),
                  ],
                ),
                SizedBox(height: 40,),
                Text("Pick a color to express your feeling",
                    style: GoogleFonts.sniglet(fontSize: 15),
                ),
                SizedBox(height: 10,),
                Row(
                  spacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = ColorsToPick.green;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.green,
                        child: selectedColor == ColorsToPick.green ? Icon(Icons.check, color: Colors.white70,) : null
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = ColorsToPick.lightBlue;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.lightBlue,
                        child: selectedColor == ColorsToPick.lightBlue ? Icon(Icons.check, color: Colors.white70,) : null
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = ColorsToPick.pink;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.pink,
                          child: selectedColor == ColorsToPick.pink ? Icon(Icons.check, color: Colors.white70,) : null
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = ColorsToPick.orange;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.orange,
                          child: selectedColor == ColorsToPick.orange ? Icon(Icons.check, color: Colors.white70,) : null
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = ColorsToPick.teal;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.teal,
                          child: selectedColor == ColorsToPick.teal ? Icon(Icons.check, color: Colors.white70,) : null
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = ColorsToPick.black;
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.black,
                        child: selectedColor == ColorsToPick.black ? Icon(Icons.check, color: Colors.white70,) : null,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40,),
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: _contentEditController,
                    style: GoogleFonts.sniglet(
                        fontSize: 16,
                        color: _getTextColor()
                    ),
                    decoration: InputDecoration(
                      hintText: "Express everything you feel like at the moment here",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: _addData,
                        child: Text(
                          "Save",
                          style: GoogleFonts.sniglet(fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.sniglet(fontSize: 15),
                          )
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor() {
    switch (selectedColor) {
      case ColorsToPick.black:
        return Colors.black;
      case ColorsToPick.green:
        return Colors.green;
      case ColorsToPick.lightBlue:
        return Colors.lightBlue;
      case ColorsToPick.pink:
        return Colors.pink;
      case ColorsToPick.orange:
        return Colors.orange;
      case ColorsToPick.teal:
        return Colors.teal;
    }
  }

  void _updateDateTimeAndDay() {
    var now = DateTime.now();
    var dateFormatter = DateFormat("dd-MM-yyyy");
    var timeFormatter = DateFormat.jm();
    var dayFormatter = DateFormat("EEEE");

    _currentDate = dateFormatter.format(now);
    _currentTime = timeFormatter.format(now);
    _currentDay = dayFormatter.format(now);
  }

  void _addData() {
    final String title = _titleEditController.text;
    final String content = _contentEditController.text;

    if (title.isEmpty) {
      Fluttertoast.showToast(
          msg: "Title required to save",
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );

      return;
    }

    if (content.isEmpty) {
      Fluttertoast.showToast(
          msg: "Let it out! Write your rant first",
          backgroundColor: Colors.red,
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_SHORT
      );

      return;
    }

    final String color = ColorMap.enumToString[selectedColor] ?? "black";

    final int lastId = _databaseHelper.returnTotalLength();
    final int currentId = lastId + 1;

    final Map<String, String> finalMap = {};
    finalMap[DataDictKeys.id] = currentId.toString();
    finalMap[DataDictKeys.title] = title;
    finalMap[DataDictKeys.color] = color;
    finalMap[DataDictKeys.date] = _currentDate;
    finalMap[DataDictKeys.day] = _currentDay;
    finalMap[DataDictKeys.time] = _currentTime;

    final String encryptedData = encryptData(content);
    _databaseHelper.addData(finalMap, encryptedData);

    Navigator.of(context).pop();
  }
}
