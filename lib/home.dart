import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrant/add.dart';
import 'package:wrant/indexpage.dart';
import 'dart:math';

import 'package:wrant/view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String quote = "";

  @override
  void initState() {
    showQuote();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Color.fromARGB(255, 232, 225, 247),
        systemNavigationBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 232, 225, 247),
        body: SafeArea(
            child: Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Wrant", style: GoogleFonts.windSong(fontSize: 40, fontWeight: FontWeight.bold),),
                        SizedBox(height: 40,),
                        Center(
                          child: Text(quote, style: GoogleFonts.loversQuarrel(fontSize: 28, fontWeight: FontWeight.w500,),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 40,),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => ViewPage(),
                                ),
                              );
                            },
                            child: Text("Open pages", style: GoogleFonts.dynaPuff(fontSize: 13),)
                        ),
                        SizedBox(height: 20,),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => IndexPage(),
                                ),
                              );
                            },
                            child: Text("Open index", style: GoogleFonts.dynaPuff(fontSize: 13),)
                        ),
                        SizedBox(height: 20,),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => AddPage(),
                                ),
                              );
                            },
                            child: Text("Write", style: GoogleFonts.dynaPuff(fontSize: 13),)
                        ),
                      ],
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  void showQuote() async {
    final String content =  await rootBundle.loadString('assets/texts/quotes.txt');
    final List<String> quotesList = content.split("\n");

    final int upperLimit = quotesList.length;
    final int randomNum = Random().nextInt(upperLimit);

    setState(() {
      quote = quotesList.elementAt(randomNum);
    });
  }
}
