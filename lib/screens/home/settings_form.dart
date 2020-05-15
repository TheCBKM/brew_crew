import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/databse.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loadin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugarslist = ['0', '1', '2', '3', '4'];

  String _name;
  String _sugars;
  int _strength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userdata = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your settings here.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userdata.name,
                    decoration: textInputDecoration.copyWith(
                        hintText: "Enter your name"),
                    validator: (val) =>
                        val.isEmpty ? "Please enter a name" : null,
                    onChanged: (val) => setState(() => _name = val),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _sugars ?? userdata.sugars,
                    items: sugarslist.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text('$e sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _sugars = val),
                  ),
                  Slider(
                      activeColor: Colors.brown[_strength ?? userdata.strength],
                      inactiveColor:
                          Colors.brown[_strength ?? userdata.strength],
                      min: 100,
                      max: 900,
                      divisions: 8,
                      onChanged: (val) => setState(
                            () => _strength = val.round(),
                          ),
                      value: (_strength ?? userdata.strength).roundToDouble()),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate())
                        await DatabaseService(uid: user.uid).updateUserData(
                            _sugars ?? userdata.sugars,
                            _name ?? userdata.name,
                            _strength ?? userdata.strength);
                            Navigator.pop(context);
                    },
                    color: Colors.brown[800],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
