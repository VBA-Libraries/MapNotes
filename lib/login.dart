import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class LoginPage extends StatefulWidget {
  static final routeName = "/login";
  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('MAP Calls'),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/screen.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
                // padding: EdgeInsets.all(0.0),
                padding: EdgeInsets.fromLTRB(50, 30, 50, 50),
                child: ListView(
                  children: <Widget>[
                    // Container(
                    //     decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //     ),
                    //     alignment: Alignment.center,
                    //     padding: EdgeInsets.all(10),
                    //     child: Center(
                    //       child: Image.asset('assets/images/ic_launcher.png'),
                    //     )),
                    // CircleAvatar(
                    //   radius: 10.0,
                    //   backgroundImage: AssetImage('assets/images/ic_launcher.png'),
                    // ),
                    //
                    // ClipRRect(
                    //   borderRadius: new BorderRadius.circular(50.0),
                    //   child: Image(
                    //     fit: BoxFit.fill,
                    //     image: AssetImage('assets/images/ic_launcher.png'),
                    //     width: 50.0,
                    //     height: 50.0,
                    //   ),
                    // ),

                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.yellow.shade50,
                          border: OutlineInputBorder(),
                          hintText: 'User Name',
                          //\labelText: 'User Name',
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.yellow.shade50,
                            border: OutlineInputBorder(),
                            hintText: 'Password'
                            //labelText: 'Password',
                            ),
                      ),
                    ),
                    // FlatButton(
                    //   onPressed: () {
                    //     //forgot password screen
                    //   },
                    //   textColor: Colors.blue,
                    //   child: Text('Forgot Password'),
                    // ),
                    Container(
                        height: 70,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                        child: ElevatedButton(
                          style: ButtonStyle(),
                          child: Text('Login'),
                          onPressed: () async {
                            bool is_logged_in = false;
                            if (users.containsKey(nameController.text) ==
                                true) {
                              if (users[nameController.text] ==
                                  passwordController.text) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                    'user_name', nameController.text);

                                Navigator.pushNamed(context, '/');

                                is_logged_in = true;
                              }
                            }
                            if (is_logged_in == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Incorrect password')));
                            }
                          },
                        )),
                    // Container(
                    //     child: Row(
                    //   children: <Widget>[
                    //     Text('Does not have account?'),
                    //     FlatButton(
                    //       textColor: Colors.blue,
                    //       child: Text(
                    //         'Sign in',
                    //         style: TextStyle(fontSize: 20),
                    //       ),
                    //       onPressed: () {
                    //         //signup screen
                    //       },
                    //     )
                    //   ],
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    // ))
                  ],
                )),
          ),
        ));
  }
}
