import 'package:dropbox_client/dropbox_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';

String? accessToken;
String? user_name;
final String dropbox_clientId = 'test-flutter-dropbox';
final String dropbox_key = 'p2ba1tf4kix6fvt';
final String dropbox_secret = 'uuzuw6b3fws5z95';

Future<String?> getTemporaryLink(path) async {
  final result = await Dropbox.getTemporaryLink(path);
  return result;
}

Future<bool> checkAuthorized(bool authorize) async {
  final token = await Dropbox.getAccessToken();
  if (token != null) {
    if (accessToken == null || accessToken!.isEmpty) {
      accessToken = token;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('dropboxAccessToken', accessToken!);
    }
    return true;
  }
  if (authorize) {
    if (accessToken != null && accessToken!.isNotEmpty) {
      await Dropbox.authorizeWithAccessToken(accessToken!);
      final token = await Dropbox.getAccessToken();
      if (token != null) {
        //  print('authorizeWithAccessToken!');
        return true;
      }
    } else {
      await Dropbox.authorize();
      //   print('authorize!');
    }
  }
  return false;
}

Future authorize() async {
  await Dropbox.authorize();
}

Future<File> _localFile(String _localPath) async {
  return File(_localPath);
}

Future<int?> deleteFile(file_name) async {
  try {
    final file = await _localFile(file_name);
    await file.delete();
  } catch (e) {
    return 0;
  }
}

Future uploadTest(
    String file_name, String str_data, context, reset_form) async {
  if (await checkAuthorized(true)) {
    var tempDir = await getTemporaryDirectory();
    var filepath = '${tempDir.path}/' + file_name;

    File(filepath).writeAsStringSync(str_data);
    final result = await Dropbox.upload(filepath, '/Dropbox_Calls/' + file_name,
        (uploaded, total) {
      deleteFile(filepath);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved!')),
      );
      reset_form();
    });
    print(result);
  }
}

Future<String> testDownload(fileName) async {
  // final filepath = '/path/to/local/file.txt';
  var tempDir = await getTemporaryDirectory();
  var filepath = '${tempDir.path}/' + fileName;
  var content;
  deleteFile(filepath);
  final result = await Dropbox.download(
      '/Dropbox_Calls/' + fileName, filepath, (downloaded, total) {});
  content = readText(filepath);
  deleteFile(filepath);
  return content;
}

Future<String> readText(file_name) async {
  try {
    final file = await _localFile(file_name);

    // Read the file
    final contents = await file.readAsString();
    // print("inside read text" + contents);
    return contents;
  } catch (e) {
    // If encountering an error, return 0
    return "";
  }
}
//
