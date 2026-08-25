import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wrant/constants/data_dict_keys.dart';

class DatabaseHelper {
    late final int lastId;
    late final Box box;

    DatabaseHelper() {
        box = Hive.box(name: "MainDatabase");
        int len = box.length;
        lastId = len;
    }

    Future<String> get _localPath async {
        final directory = await getApplicationDocumentsDirectory();

        return directory.path;
    }

    void addData(Map<String, String> dataMap, String contentText) async {
        final int id = lastId + 1;
        final String key = "data-$id";

        final path = await _localPath;
        final String finalName = "wrant-$id";
        final String filePath = "$path/$finalName";

        final File file = File(filePath);

        file.writeAsString(contentText);

        dataMap[DataDictKeys.filePath] = filePath;
        box.put(key, dataMap);

        lastId++;
    }

    Map<String, dynamic> getData(int id) {
        final String key = "data-$id";
        final Map<String, dynamic> data = box.get(key);

        return data;
    }

    Future<String> getContent(int id) async {
        final path = await _localPath;
        final String finalName = "wrant-$id";
        final String filePath = "$path/$finalName";

        final File file = File(filePath);

        final String content = await file.readAsString();
        return content;
    }

    bool isDataNotEmpty() {
        return box.isNotEmpty;
    }

    int returnTotalLength() {
        return box.length;
    }
    
    List<List<dynamic>> getAllTitleDateAndId() {
        List<List<dynamic>> finalList = [];

        int totalLength = returnTotalLength();
        if (totalLength == 0) {
          return [];
        } else {
            for (var i = 1; i <= totalLength; i++) {
                final String key = "data-$i";
                final Map<String, dynamic> data = box.get(key);

                List<dynamic> dataList = [];
                dataList.add(data[DataDictKeys.id]);
                dataList.add(data[DataDictKeys.title]);
                dataList.add(data[DataDictKeys.date]);

                finalList.add(dataList);
            }
        }

        return finalList;
    }
}