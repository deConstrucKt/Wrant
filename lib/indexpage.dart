import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wrant/database/database_helper.dart';
import 'package:wrant/view.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  final DatabaseHelper _databaseHelper = DatabaseHelper();

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
            padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Index",
                      style: GoogleFonts.sniglet(fontSize: 28, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: _getListOfCards(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getListOfCards() {
    List<List<dynamic>> allDataList = _databaseHelper.getAllTitleDateAndId();
    List<Widget> listOfWidget = [];

    if (allDataList.isEmpty) {
      listOfWidget.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Nothing weighing you down",
            textAlign: TextAlign.center,
            style: GoogleFonts.sniglet(fontSize: 14)
          ),
        ],
      ));
    } else {
      for (var dataList in allDataList) {
        Widget card = _getCard(
            dataList[0],
            dataList[1],
            dataList[2]);

        listOfWidget.add(card);
      }
    }

    return listOfWidget;
  }

  Widget _getCard(dynamic id, dynamic title, dynamic date) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (context) => ViewPage(initialId: int.parse(id),),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: GoogleFonts.sniglet(fontSize: 19, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10,),
              Text(
                "Date: $date",
                style: GoogleFonts.sniglet(fontSize: 12),
                textAlign: TextAlign.left
              ),
              SizedBox(height: 3,),
              Text(
                "Page: $id",
                style: GoogleFonts.sniglet(fontSize: 12),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
