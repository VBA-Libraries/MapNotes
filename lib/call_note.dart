import 'package:dropbox_client/dropbox_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

import 'package:date_format/date_format.dart';

import 'dropbox.dart';
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Call Note',
//       theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           inputDecorationTheme: const InputDecorationTheme(
//             labelStyle: TextStyle(color: Colors.blueAccent),
//             hintStyle: TextStyle(color: Colors.grey),
//           )),
//       home: Scaffold(body: MyHomePage(title: 'MAP Call Notes')),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _case_id = "";
  String _tx_type = "";
  String _encounter = "1";
  String _call_dir = "";
  String _policy_no = "";
  String _member_name = "";
  String _caller_name = "";
  String _calling_from_no = "";
  // DateTime _DOB = DateTime.now();
  String _country = ""; //countries.first;
  String _transfer_from = "";

  DateTime _call_date = DateTime.now();

  String _phone_number = "";
  double _minutes = 0.0;
  String _location = ""; // location.first;
  String _contact_person = ""; //contact.first;
  String _contact_person_name = "";
  String file_path = "";
  String _call_notes = "";
  String _extn = ""; // extn.first;
  bool _enabled = true;

  // String _call_loc = ""; //location.first;
  bool _is_admin = false;
  String str_data = "";
  bool _is_new = false;
  bool _eoc = false;
  String pre_name = "";

  final _formKey = GlobalKey<FormState>();

  String folder_path = "";
  TextEditingController phoneController = new TextEditingController();
  TextEditingController caseController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController phoneToController = new TextEditingController();
  Future initDropbox() async {
    await Dropbox.init(dropbox_clientId, dropbox_key, dropbox_secret);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('dropboxAccessToken');

    setState(() {});
  }

  Future check_login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_name = prefs.getString('user_name');

    setState(() {
      _extn = user_name!;
    });
  }

  @override
  void initState() {
    super.initState();

    initDropbox();
    check_login();
    if (user_name == "") {
      Navigator.pushNamed(context, '/login');
    }

    //listFolder('/Dropbox_Calls');
  }

  // _write(String text, String file_name) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final File file = File('${directory.path}/' + file_name + '.txt');
  //   await file.writeAsString(text);
  // }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    bool _is_new_case = false;
    void reset_form() {
      _formKey.currentState!.reset();
      caseController.clear();
      phoneController.clear();
    }

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
          color: Colors.orangeAccent,
          child: Wrap(
            spacing: 20,
            textDirection: TextDirection.rtl,
            children: [
              // Save button
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Text("Save"),
                onPressed: () {
                  var flag = _formKey.currentState!.validate();
                  if (flag = true && _eoc == true) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saving Call Details')),
                    );

                    str_data = "";
                    str_data = str_data + "case_id:" + _case_id + "####";
                    str_data = str_data + "encounter:" + _encounter + "####";
                    str_data =
                        str_data + "call_direction:" + _call_dir + "####";

                    str_data = str_data + "tx_type:" + _tx_type + "####";
                    str_data = str_data +
                        "calling_from_no:" +
                        _calling_from_no +
                        "####";
                    str_data = str_data + "policy_no:" + _policy_no + "####";

                    str_data =
                        str_data + "member_name:" + _member_name + "####";
                    str_data =
                        str_data + "caller_name:" + _caller_name + "####";

                    // str_data = str_data + "DOB:" + _DOB.toString() + "####";
                    str_data = str_data + "country:" + _country + "####";
                    str_data = str_data +
                        "call_date:" +
                        _call_date.toString() +
                        "####";

                    str_data =
                        str_data + "phone_number:" + _phone_number + "####";
                    str_data =
                        str_data + "minutes:" + _minutes.toString() + "####";
                    str_data = str_data + "extn:" + _extn + "####";

                    str_data =
                        str_data + "contact_person:" + _contact_person + "####";
                    str_data = str_data +
                        "contact_person_name:" +
                        _contact_person_name +
                        "####";

                    str_data =
                        str_data + "transfer_from:" + _transfer_from + "####";
                    str_data = str_data + "location:" + _location + "####";

                    // str_data = str_data + "billed:" + _billed + "####";
                    str_data = str_data + "call_notes:" + _call_notes + "####";
                    str_data =
                        str_data + "new_case:" + _is_new.toString() + "####";
                    // str_data = str_data + "call_location:" + _call_loc + "####";
                    // // str_data = str_data +
                    //     "calling_from_no" +
                    //     _calling_from_no +
                    //     "####";
                    str_data =
                        str_data + "is_admin:" + _is_admin.toString() + "####";

                    str_data = str_data + "eoc:" + _eoc.toString() + "####";

                    if (_is_new == true) {
                      pre_name = "New_Case";
                    } else {
                      pre_name = _case_id + "-E" + _encounter.toString();
                    }
                    String file_name = pre_name +
                        "_" +
                        formatDate(
                            DateTime.now(), ["yyyy", "mm", "dd", "hh", "mm"]);
                    // print(file_name);
                    // _write(str_data, "1");
                    uploadTest(file_name, str_data, context, reset_form);

                    // listFolder('/Dropbox_Calls');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill the required fields.')),
                    );
                  }
                },
              ),
              // Clear button
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                child: Text("Clear"),
                onPressed: () {
                  reset_form();
                },
              )
            ],
          ),
        ),
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // new case, case id, encounter
                Row(
                  children: [
                    //New case checkbox
                    Expanded(
                      flex: 2,
                      child: CheckboxListTile(
                        title: Text("New Case"),
                        // title: const Text('Animate Slowly'),
                        value: _is_new,
                        onChanged: (bool? value) {
                          setState(() {
                            _is_new = value!;
                            _enabled = !value;
                            caseController.clear();
                            _case_id = "";
                          });
                        },
                      ),
                    ),

                    //Case ID
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                        enabled: _enabled,
                        controller: caseController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty && _policy_no.isEmpty) {
                            return 'Please enter Policy No or Case ID';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),

                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Case ID",

                          // hintText: "Case ID",
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          focusColor: Colors.yellow[10],
                          fillColor: Colors.yellow[50],
                        ),
                        onChanged: (text) {
                          _case_id = text;
                        },
                      ),
                    ),

                    //Encounter
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: DropdownButtonFormField(
                            value: _encounter,
                            // hint: Text(" Enc", overflow: TextOverflow.ellipsis),
                            decoration: InputDecoration(
                                alignLabelWithHint: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(8, 10, 0, 0),
                                border: OutlineInputBorder(),
                                filled: true,
                                // contentPadding: EdgeInsets.all(0.0),
                                fillColor: Color(0xecedec),
                                labelText: "Encounter"),
                            items: encounters
                                .map((e) => new DropdownMenuItem(
                                      value: e,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Text(e,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                print(newValue);
                                _encounter = newValue!;
                              });
                            }),
                      ),
                    ),
                  ],
                ),
                //Divider(color: Colors.white),
                Divider(height: 10),
                //Policy no  ,coutnry
                Row(children: [
                  //Policy No
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty && _case_id.isEmpty) {
                          return 'Please enter Policy No or Case ID';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        labelText: "Policy No",
                        //// floatingLabelBehavior: FloatingLabelBehavior.always,
                        // hintText: "Policy No",
                        focusColor: Colors.yellow[100],
                        fillColor: Colors.yellow[50],
                      ),
                      onChanged: (text) {
                        setState(() {
                          _policy_no = text;
                        });
                      },
                    ),
                  ),
                  //Country
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: DropdownButtonFormField(
                          key: UniqueKey(),
                          isExpanded: true,
                          validator: (value) {
                            if (value == "") {
                              return 'Please enter country';
                            }
                            return null;
                          },
                          // hint: Text("Country"),
                          value: _country,
                          decoration: InputDecoration(
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 10, 10, 10),
                              border: OutlineInputBorder(),
                              labelText: "Country"),
                          items: countries
                              .map((e) => new DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _country = newValue!;
                              if (_country == "United States") {
                                _location = "Domestic";
                              } else {
                                _location = "INTL";
                              }
                            });
                          }),
                    ),
                  ),
                ]),
                Divider(height: 10),
                //Member name, caller name
                Row(
                  children: [
                    //Member Name
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Member Name",
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(),
                          //floatingLabelBehavior:
                          //  FloatingLabelBehavior.always,
                          // hintText: "Member Name",
                          focusColor: Colors.yellow[100],
                          fillColor: Colors.yellow[50],
                        ),
                        onChanged: (text) {
                          setState(() {
                            _member_name = text;
                          });
                        },
                      ),
                    ),
                    //Caller Name
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Caller Name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(),
                            labelText: "Caller Name",
                            // floatingLabelBehavior:
                            //     FloatingLabelBehavior.always,
                            // hintText: "Caller Name",
                            focusColor: Colors.yellow[100],
                            fillColor: Colors.yellow[50],
                          ),
                          onChanged: (text) {
                            setState(() {
                              _caller_name = text;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                Divider(height: 10),
                //  call direction, tx type, extn
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  //Call direction
                  Expanded(
                    child: DropdownButtonFormField(
                        key: UniqueKey(),
                        validator: (value) {
                          if (value == "") {
                            return 'Please enter call direction';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            filled: true,
                            fillColor: Color(0xecedec),
                            labelText: "Direction"),
                        value: _call_dir,
                        items: call_direction
                            .map((e) => new DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _call_dir = newValue!;
                            if (newValue == "OUT") {
                              phoneController.text = "17867802088";
                              _calling_from_no = "17867802088";
                              _phone_number = "";
                              phoneToController.clear();
                            } else {
                              _phone_number = "17867066960";
                              _calling_from_no = "";
                              phoneToController.text = "17867066960";
                              phoneController.clear();
                              // phoneController.text = "17867066960";
                              //  = "17867066960";
                            }
                          });
                        }),
                  ),
                  //Tx Type
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: DropdownButtonFormField(
                          isExpanded: true,
                          key: UniqueKey(),
                          validator: (value) {
                            if (value == "") {
                              return 'Please enter Tx Type';
                            }
                            return null;
                          },
                          value: _tx_type,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            labelText: "Tx Type",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // hintText: "Contact"
                          ),
                          items: tx_types
                              .map((e) => new DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            _tx_type = newValue!;
                          }),
                    ),
                  ),
                  //Extn
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: DropdownButtonFormField(
                          isExpanded: true,
                          key: UniqueKey(),
                          value: _extn,
                          validator: (value) {
                            if (value == "") {
                              return 'Please enter Extn';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(),

                            labelText: "Extn",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // hintText: "Contact"
                          ),
                          items: extn
                              .map((e) => new DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _extn = newValue!;
                            });
                          }),
                    ),
                  )
                ]),
                // policy no , member name
                Divider(height: 10),
                //calling from , calling to
                Row(children: [
                  //calling from
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter calling from';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      controller: phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        labelText: "Calling From",
                        // floatingLabelBehavior: FloatingLabelBehavior.always,
                        // hintText: "Policy No",
                        focusColor: Colors.yellow[100],
                        fillColor: Colors.yellow[50],
                      ),
                      onChanged: (text) {
                        setState(() {
                          _calling_from_no = text;
                        });
                      },
                    ),
                  ),

                  //Calling to
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Phone no';
                          }
                          return null;
                        },
                        controller: phoneToController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(),
                          labelText: "Calling To",
                          // floatingLabelBehavior: FloatingLabelBehavior.always,
                          // hintText: "Phone Number",
                          focusColor: Colors.yellow[100],
                          fillColor: Colors.yellow[50],
                        ),
                        onChanged: (text) {
                          setState(() {
                            _phone_number = text;
                          });
                        },
                      ),
                    ),
                  ),
                ]),

                Divider(height: 10),
                //Minutes,call date
                Row(children: [
                  //Minutes
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Minutes';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        border: OutlineInputBorder(),
                        labelText: "Minutes",
                        // floatingLabelBehavior: FloatingLabelBehavior.always,
                        // hintText: "Minutes",
                        focusColor: Colors.yellow[100],
                        fillColor: Colors.yellow[50],
                      ),
                      onChanged: (text) {
                        setState(() {
                          _minutes = double.parse(text);
                        });
                      },
                    ),
                  ),
                  //Call Date
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                      child: TextButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                currentTime: DateTime.now(),
                                showTitleActions: true,
                                minTime: DateTime(2020, 1, 1),
                                maxTime: DateTime(2030, 1, 1),
                                onConfirm: (date) {
                              setState(() {
                                _call_date = date;
                              });
                            });
                          },
                          child: Text("Pick Call Date"),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.teal,
                            onSurface: Colors.grey,
                          )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _call_date == null
                          ? ""
                          : " |  " +
                              _call_date.toString().substring(0, 16) +
                              "  |",
                    ),
                  )
                ]),
                Divider(height: 10),

                Divider(height: 10),
                //Contact person, name
                Row(
                  children: [
                    //Contact person
                    Expanded(
                      child: DropdownButtonFormField(
                          isExpanded: true,
                          key: UniqueKey(),
                          value: _contact_person,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(),
                            labelText: "Contact",
                            // floatingLabelBehavior:
                            // FloatingLabelBehavior.always,
                            // hintText: "Contact"
                          ),
                          items: contact
                              .map((e) => new DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _contact_person = newValue!;
                            });
                          }),
                    ),
                    // Container(width: 4),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Name",
                            //floatingLabelBehavior:
                            //FloatingLabelBehavior.always,
                            //hintText: "Name",
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(),
                            focusColor: Colors.yellow[100],
                            fillColor: Colors.yellow[50],
                          ),
                          onChanged: (text) {
                            setState(() {
                              _contact_person_name = text;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(height: 10),
                //Transfer from , admin
                Row(
                  children: [
                    //Transfer from
                    Expanded(
                      child: TextFormField(
                          //  isExpanded: true,
                          //key: UniqueKey(),

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            border: OutlineInputBorder(),
                            labelText: "Transfer From",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            // hintText: "Contact"
                          ),
                          // items: extn
                          //     .map((e) => new DropdownMenuItem(
                          //           value: e,
                          //           child: Text(e),
                          //         ))
                          //     .toList(),
                          onChanged: (String? newValue) {
                            _transfer_from = newValue!;
                          }),
                    ),
                    //is Admin
                    Expanded(
                      child: CheckboxListTile(
                        value: _is_admin,
                        title: Text("Admin Call"),
                        onChanged: (new_value) {
                          setState(() {
                            _is_admin = new_value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Divider(height: 10),
                //Call note
                Row(
                  children: [
                    //Call note

                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Call Notes';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "Call Notes",

                          // hintText: "Call Notes",
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          border: OutlineInputBorder(),
                          focusColor: Colors.yellow[100],
                          fillColor: Colors.yellow[50],
                        ),
                        onChanged: (text) {
                          setState(() {
                            _call_notes = text;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                //Eoc
                Row(children: <Widget>[
                  Expanded(
                      child: CheckboxListTile(
                    value: _eoc,
                    onChanged: (val) {
                      print("--------" + val.toString());
                      setState(() => _eoc = val!);
                    },
                    subtitle: !_eoc
                        ? Text(
                            'Required.',
                            style: TextStyle(color: Colors.red),
                          )
                        : null,
                    title: new Text(
                      'EOC',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.green,
                  )
                      // child: CheckboxListTileFormField(
                      //   validator: (value) {
                      //     if (value == false) {
                      //       return 'Please select EOC';
                      //     }
                      //     return null;
                      //   },
                      //
                      //   onSaved: (bool value) {
                      //     setState(() {
                      //       _eoc = value;
                      //       print(_eoc);
                      //     });
                      //   },
                      //   title: Text("EOC"),
                      //   //value: _eoc,
                      // ),
                      )
                ]),
              ],
            ),
          ),
        ),
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}