import 'package:flutter/material.dart';

import 'package:flutter_beautiful_popup/main.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ItemPopupTab {
  String ItemId;
  String ItemDescription;

  ItemPopupTab(String ItemID, String ItemDesc) {
    this.ItemId = ItemID;
    this.ItemDescription = ItemDesc;
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
  ConfirmOrder(context) {
    print("Ordered");
    return Navigator.of(context).pop;
  }
AnimationController anim1;
  PopupItem(BuildContext context) {

    final popup = showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(

            padding:  const EdgeInsets.fromLTRB(15,15,15,0),
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                IconButton(
                    icon: Icon(Icons.cancel, color: Colors.redAccent,size: 25,),
                    onPressed: (){
                      Navigator.of(context).pop();
                    })

              ],),
              Text(ItemId, style: TextStyle(fontWeight: FontWeight.bold),),
              Padding(
                padding:const EdgeInsets.fromLTRB(15,15,15,0) ,
                child: RichText(
                  text: TextSpan(
                    text: ItemDescription,
                    style: DefaultTextStyle.of(context).style,

                  ),
                ),
              )
            ]),
          );
        });
  }
}
