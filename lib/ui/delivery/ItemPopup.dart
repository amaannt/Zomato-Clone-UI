import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/constants/colors.dart';
import 'package:zomatoui/constants/textstyles.dart';
import 'package:zomatoui/widgets/rating.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_beautiful_popup/main.dart';

class ItemPopupTab {
  String ItemId;

  ItemPopupTab(String ItemID){
    this.ItemId = ItemID;
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
  PopupItem(BuildContext context) {
    final popup = BeautifulPopup(
      context: context,
      template: TemplateGift,
    );
    popup.show(
      title: '$ItemId',
      content: 'String or Widget',
      actions: [
        popup.button(
          label: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      ],
      // bool barrierDismissible = false,
      // Widget close,
    );
  }
}
