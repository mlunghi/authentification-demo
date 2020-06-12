import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

 enum FormType {
    login, register
  }

//_ in flutter means private
class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  FormType _formType = FormType.login;

  final formKey = new GlobalKey<FormState>(); //key to tie validator to form

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save(); //ensures we can persist state
      return true;
    } else {
      return false;
    }
  }

  //Whenever we call setState() build method gets recalled
  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
       _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
       _formType = FormType.login;
    });
  }

  void validateAndSubmit() async {
    if(validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)).user;
          print("Signed in: ${user.uid}");
        } else {
          FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)).user;
          print("Registered user: ${user.uid}");
        }
        
      } catch (e) {
        print('ERROR: $e');
      }      
    }
  }

  //Widters are the building blocks of an application
  //Code used to render application
  @override
  Widget build(BuildContext context) {
    return new Scaffold(appBar: new AppBar(title: new Text("Flutter Login Demo"),
    ),
    body: new Container (
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: formKey, //tells form to use the global key
        child:
        new Column(crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buildInputs() + buildSubmitButtons(), 
        )
        )
      ) //container is like a colored box around text
    ); 
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
          decoration: new InputDecoration(labelText: 'Email'),
          validator: (value) => value.isEmpty ? 'Email can\'t be empty.' : null,
          onSaved: (value) => _email = value,
          ),
        new TextFormField(
          decoration: new InputDecoration(labelText: 'Password'), 
          obscureText: true,
          validator: (value) => value.isEmpty ? 'Email can\'t be empty.' : null,
          onSaved: (value) => _password = value,
          )
    ];
  }

  List<Widget> buildSubmitButtons() {
    //Flat vs Raised button change how the button is show in UI
    if (_formType == FormType.login) {
      return [
      new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,),
        new FlatButton(
          child: new Text('Register a New Account', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        )
    ];
    } else {
      return [
      new RaisedButton(
          child: new Text("Create an Account", style: new TextStyle(fontSize: 20)),
          onPressed: validateAndSubmit,),
       new FlatButton(
          child: new Text('Have an Account? Login', style: new TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        )
     ];
    }
  }
}