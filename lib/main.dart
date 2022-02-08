import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'details_page.dart';

import 'dropbox.dart';
import 'call_note.dart';
import 'login.dart';

void main() {
  /// your app lunch from here
  runApp(MaterialApp(
    //// remove debug logo  top left AppBar
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.blueAccent),
          hintStyle: TextStyle(color: Colors.grey),
        )),
//    application title
    title: 'Map Call Note',
//     whole  content
    //home: CallTabs(),

    initialRoute: LoginPage.routeName,
    routes: {
      LoginPage.routeName: (context) => LoginPage(),
      CallTabs.routeName: (context) => CallTabs(),
    },
  ));
}

class CallTabs extends StatefulWidget {
  static final routeName = "/";
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return TabsState();
  }
}

class TabsState extends State<CallTabs> {
  List list = [];

  Future log_out() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', "");
    Navigator.pushNamed(context, '/login');
    setState(() {});
  }

  Future listFolder(path) async {
    if (await checkAuthorized(true)) {
      // print("loading..");

      final result = await Dropbox.listFolder(path);
      // print(result);
      setState(() {
        list.clear();

        list.addAll(result); 
        list.removeWhere((element) {
          return element["name"] == "Processed_Calls";
        });

        print('Refreshed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    log_out();
                  },
                  child:
                      Icon(Icons.logout_outlined, color: Colors.orangeAccent)),
            ],
            title: Text('MAP Call Note'),
            bottom: TabBar(
                onTap: (val) {
                  if (val == 1) {
                    listFolder('/Dropbox_Calls');
                  }
                },
                indicator: BoxDecoration(
                  color: Colors.orangeAccent,
                ),
                // indicator: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10), // Creates border
                //     color: Colors.greenAccent),
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    icon: Icon(Icons.phone),
                  ),
                  Tab(
                    icon: Icon(Icons.save),
                  ),
                  // Tab(
                  //   icon: Icon(Icons.local_hospital),
                  // ),
                ]),
          ),
          body: TabBarView(children: [
//             any widget can work very well here <3

            new Container(
                color: Colors.redAccent,
                child: MyHomePage(title: 'Add Call Note')),

            new Container(
              color: Colors.greenAccent,
              child: Center(
                  child: Scaffold(
                body: SizedBox(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        var file_path = item['lowerPath'];
                        var name = item['name'];
                        return Card(
                          elevation: 2.0,
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.orange.shade50),
                            child: ListTile(
                              title: Text(name),
                              // trailing: OutlinedButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       deleteFile(list[index]);
                              //       list.removeAt(index);
                              //     });
                              //   },
                              //   child: Icon(Icons.delete),
                              // ),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0,
                                            color: Colors.orangeAccent))),
                                child: Icon(
                                  Icons.call,
                                ),
                              ),

                              onTap: () {
                                var file_name = list[index]["name"];
                                // testDownload(file_name);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                            file_name: file_name,
                                            title: file_name)));
                              },

                              // leading: Icon(Icons.call),

                              // onTap: () async {
                              //   listFolder('/Dropbox_Calls');
                              // }
                              //   final link = await getTemporaryLink(file_path);
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              //       content: Text(link ??
                              //           'get
                              //
                              //           TemporaryLink error: $file_path')));
                              // },
                            ),
                          ),
                        );
                      }),
                ),
                floatingActionButton: Stack(children: <Widget>[
                  Positioned(
                    right: 10,
                    bottom: 15,
                    child: FloatingActionButton(
                      heroTag: 'Refresh',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Refreshing content.')),
                        );

                        listFolder('/Dropbox_Calls');
                      },
                      child: Icon(Icons.refresh),
                    ),
                  ),
                ]),
              )),
            ),
            // new Container(
            //   color: Colors.blueAccent,
            //   child: Center(
            //     child: Text(
            //       'Hi from Hospital',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // ),
          ]),
        ));
  }
}
