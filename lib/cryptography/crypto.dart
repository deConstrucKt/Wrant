import 'package:wrant/constants/cipher_map.dart';

String encryptData(String text) {
  String encryptedData = "";
  Iterable<String> keys = CipherMap.encryptMap.keys;

  for (int i = 0; i < text.length; i++) {
    bool flag = false;
    for (var key in keys) {
      if (key == text[i]) {
        flag = true;
        encryptedData += CipherMap.encryptMap[key]!;
      }
    }
    if (flag == false) {
      encryptedData += text[i];
    }
  }

  return encryptedData;
}

String decryptData(String text) {
  String decryptedData = "";
  Iterable<String> keys = CipherMap.decryptMap.keys;

  for (int i = 0; i < text.length; i++) {
    bool flag = false;
    for (var key in keys) {
      if (key == text[i]) {
        print("${text[i]} replaced by ${CipherMap.decryptMap[key]}");
        flag = true;
        decryptedData += CipherMap.decryptMap[key]!;
      }
    }
    if (flag == false) {
      print("${text[i]}");
      print("false");
      decryptedData += text[i];
    }
  }

  print(decryptedData);
  return decryptedData;
}