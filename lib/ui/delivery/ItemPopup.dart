import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';

class ItemPopupTab {
  String itemID;
  String ItemName;
  String ItemDescription;
  String itemPrice;
  String itemImage;

  ItemPopupTab(String itemName, String itemDesc, String itemID,
      String itemPrice, String itemIMG) {
    this.ItemName = itemName;
    this.ItemDescription = itemDesc;
    this.itemID = itemID;
    this.itemPrice = itemPrice;
    this.itemImage = itemIMG;
  }

  ///convert string from the storage to list
  ///this is working
  convertAndAddToList(String firstPartOfString, String Item) {
    var imgs = json.decode(StorageUtil.getString(firstPartOfString));

    //print(imgs.toString());
    List<String> second = new List(imgs.length + 1);
    for (int x = 0; x < imgs.length; x++) {
      if (imgs[x] != null) second[x] = (imgs[x]);
    }
    //add the last element
    second[imgs.length] = Item;
    return second;
  }

  orderExistsInList(String item){
    bool isExist = false;
    print("Order reached here");
    var imgs = json.decode(StorageUtil.getString("Cart_ItemName"));

    for(int x =0 ; x< imgs.length; x++){
      if(item == imgs[x]){
        isExist = true;
      }
    }
    return isExist;
  }
  ConfirmOrder(BuildContext context) {
    print("Ordered");
    //if there is nothing at all in the orders
    if (StorageUtil.getString("Cart_ItemName") == null ||
        StorageUtil.getString("Cart_ItemName") == "") {
      var jsonID = json.encode([itemID]);
      StorageUtil.putString("Cart_ItemID", jsonID);

      var jsonName = json.encode([ItemName]);
      StorageUtil.putString("Cart_ItemName", jsonName);

      var jsonPrice = json.encode([itemPrice]);
      StorageUtil.putString("Cart_ItemPrice", jsonPrice);

      var jsonIMG = json.encode([itemImage]);
      StorageUtil.putString("Cart_ItemImage", jsonIMG);

      //this line puts the preexisting items value as one and resets any other value previously
      StorageUtil.putString("Cart_ItemQuantity_" + ItemName, "1");
    } else {

      //check if item exists
      if(orderExistsInList(ItemName)){

        int quantityOfItem = int.parse(StorageUtil.getString("Cart_ItemQuantity_" + ItemName));
        quantityOfItem +=1;
        StorageUtil.putString("Cart_ItemQuantity_" + ItemName, "$quantityOfItem");
      } else{
        print("Order Present");
        //convert storage string to list
        //add new item to list
        List<String> itemI = convertAndAddToList("Cart_ItemID", itemID);
        List<String> itemNm = convertAndAddToList("Cart_ItemName", ItemName);
        List<String> itemP = convertAndAddToList("Cart_ItemPrice", itemPrice);
        List<String> itemIMG = convertAndAddToList("Cart_ItemImage", itemImage);

        //convert back to stringitemImage and store in shareprefs
        var jsonID = json.encode(itemI);
        StorageUtil.putString("Cart_ItemID", jsonID);
        var jsonName = json.encode(itemNm);
        StorageUtil.putString("Cart_ItemName", jsonName);
        var jsonPrice = json.encode(itemP);
        StorageUtil.putString("Cart_ItemPrice", jsonPrice);
        var jsonIMG = json.encode(itemIMG);
        StorageUtil.putString("Cart_ItemImage", jsonIMG);
        StorageUtil.putString("Cart_ItemQuantity_" + ItemName, "1");
      }

    }

    Flushbar(
      borderRadius: 0.5,
      backgroundColor: Colors.red[900],
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(ItemName,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(
            " Has been added to your current orders!",
            style: TextStyle(color: Colors.lightBlue[50]),
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      duration: Duration(seconds: 1, milliseconds: 500),
      flushbarPosition: FlushbarPosition.TOP,
      routeBlur: 0.7,
      blockBackgroundInteraction: true,
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
                  onPressed: () {
                    ConfirmOrder(context);
                  },
                  child: Icon(Icons.add_shopping_cart))
            ]),
          );
        });
  }
}
