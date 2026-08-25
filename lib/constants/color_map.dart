import 'package:wrant/add.dart';

class ColorMap {
  static const Map<ColorsToPick, String> enumToString = {
    ColorsToPick.black: "black",
    ColorsToPick.teal: "teal",
    ColorsToPick.orange: "orange",
    ColorsToPick.pink: "pink",
    ColorsToPick.lightBlue: "lightBlue",
    ColorsToPick.green: "green"
  };

  static const Map<String, ColorsToPick> stringToEnum = {
    "black": ColorsToPick.black,
    "teal": ColorsToPick.teal,
    "orange": ColorsToPick.orange,
    "pink": ColorsToPick.pink,
    "lightBlue": ColorsToPick.lightBlue,
    "green": ColorsToPick.green
  };
}