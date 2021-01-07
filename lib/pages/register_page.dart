import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _username, _email, _password, _cartId = "";
  bool _obscureText = true;
  bool isSubmitting = false;

  Widget _showTitle() {
    return Text(
      'Register',
      style: Theme.of(context).textTheme.headline5,
    );
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _username = val,
        validator: (val) => val.length < 6 ? 'Username too short' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
          hintText: 'Enter username, min length 6',
          icon: Icon(
            Icons.face,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val,
        validator: (val) => !val.contains('@') ? 'Invalid Email' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter a valid email',
          icon: Icon(
            Icons.email,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _password = val,
        validator: (val) => val.length < 6 ? 'Password too short' : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
          suffix: GestureDetector(
            child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
            onTap: () {
              setState(() => _obscureText = !_obscureText);
            },
          ),
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter password, min length 6',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          isSubmitting
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              : RaisedButton(
                  child: Text(
                    'Submit',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: Colors.black),
                  ),
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: _submit,
                ),
          FlatButton(
            child: Text('Existing user? Login'),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          )
        ],
      ),
    );
  }

  _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() => isSubmitting = true);
    http.Response response =
        await http.post('http://10.0.2.2:1337/auth/local/register', body: {
      'username': _username,
      'email': _email,
      'password': _password,
    });
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => isSubmitting = false);
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() => isSubmitting = false);
      // print(responseData['message'].toString());
      final errorMsg = responseData['message'][0]['messages'][0]['message'];
      _showErrorSnack(errorMsg);
    }
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/');
    });
  }

  void _storeUserData(responseData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  _showSuccessSnack() {
    final snackBar = SnackBar(
        content: Text(
      'User $_username successfully created!',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.green),
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackBar = SnackBar(
        content: Text(
      errorMsg,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.red),
    ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
    throw Exception('Error registering: $errorMsg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _showTitle(),
                  _showUsernameInput(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormActions()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
