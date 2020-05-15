import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loadin.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleViews;
  SignIn({this.toggleViews});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";

  String err = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign IN to Brew_Crew"),
              actions: <Widget>[
                FlatButton.icon(
                  textColor: Colors.white,
                  onPressed: () {
                    widget.toggleViews();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Sign Up"),
                ),
              ],
            ),
            body: Container(
              child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 50.0,
                  ),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "Email",
                            ),
                            validator: (val) =>
                                val.isEmpty ? "Enter an Email" : null,
                            cursorColor: Colors.brown,
                            onChanged: (val) => setState(() => email = val),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: "Password",
                            ),
                            obscureText: true,
                            validator: (val) => val.length < 6
                                ? "Enter an password greater than 6"
                                : null,
                            onChanged: (val) => setState(() => password = val),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          RaisedButton(
                              color: Colors.brown[800],
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                    err = "";
                                  });
                                  dynamic res = await _auth
                                      .signinwithEmailPassword(email, password);
                                  if (res == null) {
                                    setState(() {
                                      loading = false;
                                    });
                                    setState(() {
                                      err = "Error in Sign in";
                                    });
                                  }
                                }
                              }),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            err,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          )
                        ],
                      ))),
            ),
          );
  }
}
