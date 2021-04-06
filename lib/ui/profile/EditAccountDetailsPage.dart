import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zomatoui/Model/User.dart';
import 'package:zomatoui/constants/constants.dart';
import 'package:zomatoui/ui/profile/EditAccountController.dart';

// ignore: must_be_immutable
class EditAccountDetailsPage extends StatefulWidget {
  @override
  _EditAccountDetailPage createState() => _EditAccountDetailPage();
}

class _EditAccountDetailPage extends State<EditAccountDetailsPage> {
  TextEditingController firstName, lastName, emailAdd, phoneNo;
  String responseMessage = "";
  bool isChanging = false;
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
      body: !isChanging
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: firstName..text = User().fname,
                    onChanged: (text) => {},
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: lastName..text = User().lastName,
                    onChanged: (text) => {},
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: emailAdd..text = User().email,
                    onChanged: (text) => {},
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: phoneNo..text = User().phone,
                    onChanged: (text) => {},
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextButton(
                    onPressed: () async {
                      setState(() {
                        isChanging = true;
                      });
                      responseMessage = await EditAccountDetails()
                          .setChangeUserDetails(emailAdd.text, firstName.text,
                              lastName.text, phoneNo.text);
                      print(responseMessage);
                      if (responseMessage == "Invalid Login") {
                        await showAlertDialog(
                            context,
                            "Error with login. \nPlease Login again to continue...",
                            "login error");
                      } else if (responseMessage == "Unconfirmed Phone") {
                        await showAlertDialog(context,
                            "Please Verify your Phone Number.", "PhoneBad");
                      } else if (responseMessage == "Successfully Saved") {
                        await showAlertDialog(
                            context,
                            "Information Successfully Modified!",
                            "InfoChanged");
                      } else if (responseMessage == "Error Saving") {
                        await showAlertDialog(
                            context,
                            "An Error occurred while updating your information.\nPlease try again later",
                            "Saving Issue");
                      } else {
                        // showAlertDialog(context, "No Changes Made.");
                        setState(() {});

                        Navigator.pop(context, false);
                      }
                    },
                    child: Text("Confirm Changes"),
                  )
                ],
              ))
          : Container(
              child: Center(
                  child: Column(children: <Widget>[
              SizedBox(height: 300),
              Text("Updating Information"),
              SizedBox(height:15),
              CircularProgressIndicator(),
            ]))),
    );
  }

  showAlertDialog(BuildContext context, String textString, String issue) {
    bool closePage = false;
    if (issue == "login error") {
      User().logoutProcess();
    }
    if (issue == "InfoChanged" || issue == "Saving Issue") {
      closePage = true;
    }
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Back"),
      onPressed: () {
        Navigator.pop(context);
        if (closePage) {
          Navigator.pop(context, true);
        }
        if (issue == "login error") {
          Navigator.popAndPushNamed(context, PROFILE);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(textString),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
