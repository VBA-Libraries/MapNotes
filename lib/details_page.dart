import 'package:flutter/material.dart';
import 'package:map_call_note/dropbox.dart';

class DetailsPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  DetailsPage({Key? key, required this.file_name, required this.title})
      : super(key: key);

  String file_name = "";
  String title = "";
  @override
  _MyAppState createState() {
    return _MyAppState(file_name, title);
  }
}

Future<String> fetchCall(fileName) {
  //print(fileName);
  var content = testDownload(fileName);

  // print(content.then((value) => print(value)));
  return content;
}

class _MyAppState extends State<DetailsPage> {
  _MyAppState(this.file_name, this.title);
  late Future<String> _futureCall;
  String file_name;
  String title;
  @override
  void initState() {
    super.initState();
    // print(file_name);
    _futureCall = fetchCall(file_name);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Call: " + this.title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Call: " + this.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<String>(
              future: _futureCall,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(snapshot.data!
                            .toString()
                            .replaceAll("####", "\n\n")
                            .replaceAll(":", ": ")),
                        // TextField(
                        //   controller: _controller,
                        //   decoration: const InputDecoration(
                        //     hintText: 'Enter Title',
                        //   ),
                        // ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       _futureAlbum = updateAlbum(_controller.text);
                        //     });
                        //   },
                        //   child: const Text('Update Data'),
                        // ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                }

                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
