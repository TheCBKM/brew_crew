import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loadin.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleViews;
  Register({this.toggleViews});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
              title: Text("Sign Up to Brew_Crew"),
              actions: <Widget>[
                FlatButton.icon(
                  textColor: Colors.white,
                  onPressed: () {
                    widget.toggleViews();
                  },
                  icon: Icon(Icons.person),
                  label: Text("Sign In"),
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
                            onChanged: (val) => setState(() => email = val),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            validator: (val) => val.length < 6
                                ? "Enter an password greater than 6"
                                : null,
                            decoration: textInputDecoration.copyWith(
                              hintText: "Password",
                            ),
                            obscureText: true,
                            onChanged: (val) => setState(() => password = val),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          RaisedButton(
                            color: Colors.brown[800],
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(()=>loading=true);
                                dynamic res = await _auth.regwithEmailPassword(
                                    email, password);
                                if (res == null) {
                                  setState(() {
                                    loading=false;
                                    err = "Error in register";
                                  });
                                }
                              }
                            },
                          ),
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
