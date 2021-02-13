import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ItemPopupTab {
  String ItemID;
  String ItemName;
  String ItemDescription;

  ItemPopupTab(String ItemName, String ItemDesc, String ItemID) {
    this.ItemName = ItemName;
    this.ItemDescription = ItemDesc;
    this.ItemID = ItemID;
  }
  void GetItemInfo() {
    /*DocumentSnapshot doc = await followersRef
        .document(widget.profileId)
        .collection('userFollowers')
        .document(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });*/
  }

  ConfirmOrder(BuildContext context) {
    print("Ordered");
     Flushbar(
      borderRadius:0.5,

      backgroundColor: Colors.red[900],
      messageText:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(ItemName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(" Has been added to your current orders!",
            style: TextStyle(color: Colors.lightBlue[50]),
            softWrap: true,
            textAlign: TextAlign.center,
          ),

        ],
      ),

      duration:  Duration(seconds: 1, milliseconds: 500),
      flushbarPosition: FlushbarPosition.TOP,
      routeBlur: 0.7,
      blockBackgroundInteraction:true,
    )..show(context);

  }

  AnimationController anim1;
  PopupItem(BuildContext context) {
    final popup = showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(children: <Widget>[
              Row(
                children: <Widget>[
                  Spacer(),
                  IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              ),
              Text(
                ItemName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: RichText(
                  text: TextSpan(
                    text: ItemDescription,
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
              ),
              FlatButton(
                  onPressed: (){

                    ConfirmOrder(context);
                  },
                  child: Icon(Icons.add_shopping_cart))
            ]),
          );
        });
  }
}
