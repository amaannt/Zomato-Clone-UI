import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';

class ItemPopupTab {
  String itemID;
  String itemName;
  String itemDescription;
  String itemPrice;
  String itemImage;

  ItemPopupTab(String itemName, String itemDesc, String itemID,
      String itemPrice, String itemIMG) {
    this.itemName = itemName;
    this.itemDescription = itemDesc;
    this.itemID = itemID;
    this.itemPrice = itemPrice;
    this.itemImage = itemIMG;
  }

  ///convert string from the storage to list
  ///this is working
  convertAndAddToList(String firstPartOfString, String item) {
    var imgs = json.decode(StorageUtil.getString(firstPartOfString));

    //print(imgs.toString());
    List<String> second = new List(imgs.length + 1);
    for (int x = 0; x < imgs.length; x++) {
      if (imgs[x] != null) second[x] = (imgs[x]);
    }
    //add the last element
    second[imgs.length] = item;
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
  confirmOrder(BuildContext context) {
    print("Ordered");
   
    //if there is nothing at all in the orders
    if (StorageUtil.getString("Cart_ItemName") == null ||
        StorageUtil.getString("Cart_ItemName") == "") {
      var jsonID = json.encode([itemID]);
      StorageUtil.putString("Cart_ItemID", jsonID);

      var jsonName = json.encode([itemName]);
      StorageUtil.putString("Cart_ItemName", jsonName);

      var jsonPrice = json.encode([itemPrice]);
      StorageUtil.putString("Cart_ItemPrice", jsonPrice);

      var jsonIMG = json.encode([itemImage]);
      StorageUtil.putString("Cart_ItemImage", jsonIMG);

      //this line puts the preexisting items value as one and resets any other value previously
      StorageUtil.putString("Cart_ItemQuantity_" + itemName, "1");
    } else {

      //check if item exists
      if(orderExistsInList(itemName)){

        int quantityOfItem = int.parse(StorageUtil.getString("Cart_ItemQuantity_" + itemName));
        quantityOfItem +=1;
        StorageUtil.putString("Cart_ItemQuantity_" + itemName, "$quantityOfItem");
      } else{
        print("Order Present");
        //convert storage string to list
        //add new item to list
        List<String> itemI = convertAndAddToList("Cart_ItemID", itemID);
        List<String> itemNm = convertAndAddToList("Cart_ItemName", itemName);
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
        StorageUtil.putString("Cart_ItemQuantity_" + itemName, "1");
      }

    }

    Flushbar(
      borderRadius: 0.5,
      backgroundColor: Colors.red[900],
      messageText: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(itemName,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(
            " has been added to your basket!",
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
  popupItem(BuildContext context) {
     showModalBottomSheet(
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
                itemName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: RichText(
                  text: TextSpan(
                    text: itemDescription,
                    style: DefaultTextStyle.of(context).style,
                  ),
                ),
              ),
              ProgressButton.icon(iconedButtons: {
                ButtonState.idle: IconedButton(
                    text: "Order",
                    icon: Icon(Icons.add_shopping_cart_rounded, color: Colors.white),
                    color: Colors.deepPurple.shade500),
                ButtonState.loading: IconedButton(
                    text: "Loading", color: Colors.deepPurple.shade700),
                ButtonState.fail: IconedButton(
                    text: "Failed",
                    icon: Icon(Icons.cancel, color: Colors.white),
                    color: Colors.red.shade300),
                ButtonState.success: IconedButton(
                    text: "Success",
                    icon: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    color: Colors.green.shade400)
              }, onPressed: () {var x = confirmOrder(context);}, state: ButtonState.idle),
              TextButton(
                  onPressed: () {
                    confirmOrder(context);
                  },
                  child: Card(child: Container(height:40,child: Icon(Icons.add_shopping_cart))))
            ]),
          );
        });
  }
}
