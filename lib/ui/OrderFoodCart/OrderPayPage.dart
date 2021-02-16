import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FoodCart extends StatefulWidget {
  @override
  _FoodCartState createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  List<String> itemName;
  List<String> itemPrice;
  List<String> itemID;
  List<String> itemImage;
  List<int> quantityItem;
  int orderAmount;
  bool isCartEmpty;
  double serviceCharge = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setItems();
  }

  convertToList(String firstPartOfString) {
    List<String> second;
    var imgs = json.decode(StorageUtil.getString(firstPartOfString));
    second = new List(imgs.length);
    for (int x = 0; x < imgs.length; x++) {
      second[x] = imgs[x].toString();
    }
    return second;
  }

  ///RETRIEVE ORDER DATA FROM STORAGE
  _setItems() {
    var storageState = StorageUtil.getString("Cart_ItemName");
    if (storageState == null || storageState == "") {
      isCartEmpty = true;
    } else {
      isCartEmpty = false;
      itemName = convertToList("Cart_ItemName");
      itemPrice = convertToList("Cart_ItemPrice");
      itemID = convertToList("Cart_ItemID");
      itemImage = convertToList("Cart_ItemImage");
      orderAmount = itemID.length;
      quantityItem = new List(itemName.length);
      for (int x = 0; x < itemName.length; x++) {
        quantityItem[x] = int.parse(
            StorageUtil.getString("Cart_ItemQuantity_" + itemName[x]));
      }
    }
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _cancelOrder() {
    print("Erase all order items here");
    StorageUtil.putString("Cart_ItemName", "");
    StorageUtil.putString("Cart_ItemPrice", "");
    StorageUtil.putString("Cart_ItemID", "");
    StorageUtil.putString("Cart_ItemImage", "");
    setState(() {
      isCartEmpty = true;
    });
  }

  Future<void> _showDeleteWarning() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empty your Cart?'),
          content: SingleChildScrollView(
            child: Text('Are you sure you want to delete all items?'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Spacer(),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                _cancelOrder();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _calculateTotal() {
    double total = serviceCharge;
    for (int x = 0; x < itemPrice.length; x++) {
      total += double.parse(itemPrice[x]) * quantityItem[x];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///a little bit of space never hurts.
              Container(
                padding: const EdgeInsets.all(10),
              ),
              Row(
                children: [
                  Text(
                    "Order",
                    style: TextStyle(
                        color: Color(0xFF3a3737),
                        fontWeight: FontWeight.w600,
                        fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  !isCartEmpty
                      ? TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red[700],
                          ),
                          onPressed: () {
                            _showDeleteWarning();
                          },
                          child: Container(
                            child: Text(
                              "Cancel Order",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white),
                            ),
                          ))
                      : Container(),
                ],
              ),
            ],
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            ///CartIconWithBadge(),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              !isCartEmpty
                  ? Container(
                      padding: EdgeInsets.all(15),
                      child: Card(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true, // use this
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: orderAmount,
                          itemBuilder: (context, index) {
                            return Column(
                              children: <Widget>[
                                CartItem(
                                    productName: "${itemName[index]}",
                                    productPrice: "€${itemPrice[index]}",
                                    productImage: "ic_popular_food_1",
                                    productCartQuantity: StorageUtil.getString(
                                        "Cart_ItemQuantity_" +
                                            itemName[index])),
                                (index < orderAmount - 1)
                                    ? Divider()
                                    : Container(),
                              ],
                            );
                          },
                        ),
                      ),

                      // PaymentMethodWidget(),
                    )
                  : Column(children: <Widget>[
                      Divider(),
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Order List is Empty",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                  color: Colors.black26),
                            )),
                      ),
                    ]),

              ///this section edits the total price panel widget
              !isCartEmpty
                  ? Container(
                      padding: EdgeInsets.all(15),
                      child: Card(
                          color: Colors.white54,
                          elevation: 2,
                          shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(
                              color: Colors.black,
                              width: 0.2,
                            ),
                          ),
                          child: CartItem(
                              productName: "Total Price:",
                              productPrice: "€" +
                                  _calculateTotal().toString() +
                                  " (Plus tax)",
                              productImage: "",
                              productCartQuantity: "")),
                    )
                  : Container(),

              ///this section edits the button and text if there is no button
              !isCartEmpty
                  ? Container(
                      height: 60,
                      width: queryData.size.width * 0.9,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue[600],
                          ),
                          onPressed: () {},
                          child: Container(
                            child: Text(
                              "Confirm Order",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          )))
                  : Column(children: <Widget>[
                      Container(
                        height: queryData.size.height * 0.1,
                      ),
                      SizedBox(
                        width: 250.0,
                        child: TypewriterAnimatedTextKit(
                          speed: Duration(milliseconds: 55),
                          onTap: () {
                            print("Tap Event");
                          },
                          text: [
                            "hungry?",
                            "don't be.",
                            "Try our awesome offers. :D",
                          ],
                          textStyle:
                              TextStyle(fontSize: 30.0, fontFamily: "Agne",color: Colors.black45),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ]),
            ],
          ),
        ));
  }
}

double calculateTotalPrices() {
  return 0.0;
}

class CartItem extends StatelessWidget {
  String productName;
  String productPrice;
  String productImage;
  String productCartQuantity;

  CartItem({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productImage,
    @required this.productCartQuantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.white70,
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Center(
                    child: Image.asset(
                  "assets/images/placeholder/ImageIconFood.png",
                  width: 110,
                  height: 100,
                )),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "$productName",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Text(
                            "$productPrice",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF3a3a3b),
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          child: Text(
                            "Quantity: $productCartQuantity",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black38,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        "assets/images/placeholder/ImageIconFood.png",
                        width: 25,
                        height: 25,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerRight,
                  //child: //AddToCartMenu(2),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
