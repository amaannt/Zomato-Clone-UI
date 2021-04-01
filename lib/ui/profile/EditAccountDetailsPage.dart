import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zomatoui/Model/User.dart';

// ignore: must_be_immutable
class EditAccountDetailsPage extends StatelessWidget {
  TextEditingController firstName, lastName, emailAdd, phoneNo;

  @override
  Widget build(BuildContext context) {
   firstName = new TextEditingController();
    lastName = new TextEditingController();
    emailAdd = new TextEditingController();
    phoneNo = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Account Information"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
        children: <Widget>[
          TextField(
            controller: firstName..text =  User().fname,
              onChanged: (text) => {},
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: lastName..text =  User().lastName,
            onChanged: (text) => {},
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: emailAdd..text =  User().email,
              onChanged: (text) => {},
          ),
          SizedBox(
            height: 30,
          ),
          TextField(
            controller: phoneNo..text =  User().phone,
              onChanged: (text) => {},
          ),
          SizedBox(
            height: 30,
          ),

          TextButton(
            child: Text("Confirm Changes"),
          )
        ],
      )),
    );
  }
}
