import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrant/add.dart';
import 'package:wrant/constants/color_map.dart';
import 'package:wrant/constants/data_dict_keys.dart';
import 'package:wrant/cryptography/crypto.dart';
import 'package:wrant/database/database_helper.dart';

class ViewPage extends StatefulWidget {
  final int initialId;

  const ViewPage({super.key, this.initialId = 1});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  // String temp = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since 1966, when designers at Letraset and James Mosley, the librarian at St Bride Printing Library in London, took a 1914 Cicero translation and scrambled it to make dummy text for Letraset's Body Type sheets. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
  late int currentId;
  final TextEditingController _pageEditController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    _setInitialPage();
    currentId = widget.initialId;

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
        body: _databaseHelper.isDataNotEmpty() ? SafeArea(
            child: Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 15, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_getTitle(), style: GoogleFonts.sniglet(fontSize: 28, fontWeight: FontWeight.w600,), textAlign: TextAlign.left,),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(_getDate(), style: GoogleFonts.sniglet(fontSize: 12, fontWeight: FontWeight.w100,)),
                      SizedBox(width: 20,),
                      Text(_getDay(), style: GoogleFonts.sniglet(fontSize: 12, fontWeight: FontWeight.w100,)),
                      SizedBox(width: 20,),
                      Text(_getTime(), style: GoogleFonts.sniglet(fontSize: 12, fontWeight: FontWeight.w100,)),
                      SizedBox(width: 20,),
                    ],
                  ),
                  SizedBox(height: 30,),
                    Expanded(
                      child: SingleChildScrollView(
                        child: FutureBuilder(
                          future: _getText(),
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              return Text(
                                asyncSnapshot.data ?? "None",
                                style: GoogleFonts.sniglet(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    height: 1.7,
                                    letterSpacing: 1,
                                    color: _getColor()
                                ),
                                textAlign: TextAlign.justify,
                              );
                            }
                            return const CircularProgressIndicator();
                          }
                        ),
                      ),
                    ),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Theme.of(context).colorScheme.primaryContainer
                            ),
                            child: IconButton(
                              onPressed: () {
                                if ((currentId - 1) >= 1) {
                                  setState(() {
                                    currentId--;
                                    _pageEditController.text = currentId.toString();
                                  });
                                }
                                else {
                                  Fluttertoast.showToast(
                                    msg: "That is all for now. Close the book and smile.",
                                    backgroundColor: Colors.pinkAccent,
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                }
                              },
                              icon: Icon(Icons.keyboard_arrow_left),
                              color: Theme.of(context).colorScheme.primary,),
                          ),
                          SizedBox(width: 25,),
                          Column(
                            children: [
                              Container(
                                width: 65.0,
                                child: TextField(
                                  controller: _pageEditController,
                                  autofocus: false,
                                  onSubmitted: (value) {
                                    final int val = int.parse(value);
                                    final int totalLength = _databaseHelper.returnTotalLength();
                                    if (val >= 1 && val <= totalLength) {
                                      setState(() {
                                        currentId = val;
                                      });
                                    }
                                    else {
                                      Fluttertoast.showToast(
                                        msg: "Page not available",
                                        backgroundColor: Colors.pinkAccent,
                                        gravity: ToastGravity.BOTTOM,
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2
                                      )
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 5)
                                  ),
                                  style: GoogleFonts.sniglet(fontSize: 12),
                                ),
                              ),
                              SizedBox(height: 3,),
                              Text("of ${_getTotalLength()}", style: GoogleFonts.sniglet(fontSize: 12),)
                            ],
                          ),
                          SizedBox(width: 25,),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  color: Theme.of(context).colorScheme.primaryContainer
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    final int totalLength = _databaseHelper.returnTotalLength();
                                    if ((currentId+1) <= totalLength) {
                                      setState(() {
                                        currentId++;
                                        _pageEditController.text = currentId.toString();
                                      });
                                    }
                                    else {
                                      Fluttertoast.showToast(
                                        msg: "No more pages left. You used all the ink.",
                                          backgroundColor: Colors.pinkAccent,
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_SHORT
                                      );
                                    }
                                  },
                                  icon: Icon(Icons.keyboard_arrow_right),
                                  color: Theme.of(context).colorScheme.primary)
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 5,)
                ],
              ),
          )
        ) : SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                "A quiet mind is a rare thing. Enjoy it while it lasts",
                textAlign: TextAlign.center,
                style: GoogleFonts.sniglet(fontSize: 17),
              ),
            ),
          ),
        )
      ),
    );
  }

  void _setInitialPage() {
    String initialId = widget.initialId.toString();
    setState(() {
      _pageEditController.text = initialId;
    });
  }

  String _getTotalLength() {
    return _databaseHelper.returnTotalLength().toString();
  }

  Future<String> _getText() async {
    final int id = currentId;
    final String content = await _databaseHelper.getContent(id);

    final String decryptedData = decryptData(content);

    return decryptedData;
  }

  String _getTitle() {
    return _getAllData()[DataDictKeys.title] ?? "None";
  }

  String _getDate() {
    return _getAllData()[DataDictKeys.date] ?? "None";
  }
  String _getDay() {
    return _getAllData()[DataDictKeys.day] ?? "None";
  }
  String _getTime() {
    return _getAllData()[DataDictKeys.time] ?? "None";
  }

  Color _getColor() {
    String color = _getAllData()[DataDictKeys.color] ?? "black";
    ColorsToPick colorsToPick = ColorMap.stringToEnum[color]!;

    switch (colorsToPick) {
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

  Map<String, dynamic> _getAllData() {
    Map<String, dynamic> data = _databaseHelper.getData(currentId);

    return data;
  }
}
