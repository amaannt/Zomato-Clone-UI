import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/Model/User.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';
import 'package:zomatoui/constants/constants.dart';

class FoodCart extends StatefulWidget {
  @override
  _FoodCartState createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  ///User Information
  String userID;
  String userAddress;
  String userPhone_Number;
  bool isPaymentDone;
  String paymentType;
  String PaymentID = "";

  ///Item Information
  List<String> itemName;
  List<String> itemPrice;
  List<String> itemID;
  List<String> itemImage;
  List<int> quantityItem;
  int orderAmount;
  bool isCartEmpty;
  double serviceCharge = 0.0;
  double totalCost = 0.0;
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
      totalCost = _calculateTotal();
    }
  }

  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _resetOrder() {
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
                _resetOrder();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmPayment() async {
    BuildContext contextPayment;
    // delayed code here
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        contextPayment = context;
        return AlertDialog(
          title: Text('Loading Payment'),
          content: SingleChildScrollView(
            child: LinearProgressIndicator(),
          ),
        );
      },
    );
    isPaymentDone = true;
    //this will change either to a listener or something
    new Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(contextPayment).pop();
      if (isPaymentDone) {
        _sendOrder();
        print('Done order.');
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            contextPayment = context;
            return AlertDialog(
              title: Text('Order Completed!'),
              content: SingleChildScrollView(
                child: Image.asset(
                  "assets/images/greentickmark.png",
                  width: 100,
                ),
              ),
            );
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            contextPayment = context;
            return AlertDialog(
              title: Text('Error In Payment'),
              content: SingleChildScrollView(
                child: Image.asset(
                  "assets/images/errorpayment.png",
                  width: 100,
                ),
              ),
            );
          },
        );
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }
    });
  }

  String OrderID = "";
  Future<void> _sendOrder() async {
    var jsonID = json.encode(itemID);
    var jsonName = json.encode(itemName);
    var jsonPrice = json.encode(itemPrice);
    var jsonQuantity = json.encode(quantityItem);
    print(jsonName);
    //**************************************test data

    userAddress = "Test Address 1";
    paymentType = "Visa/Mastercard";
    userID = User().id;
    userPhone_Number = User().phone;
    Map orderData = {
      "Address": "$userAddress",
      "ItemID_List": jsonID,
      "Order_List": jsonName,
      "Pay_Type": paymentType,
      "Price_List": jsonPrice,
      "Total_Price": totalCost,
      "User_ID": userID,
      "UserPhone_Number": userPhone_Number,
      "Items_Quantity": jsonQuantity,
    };
    await Backendless.data
        .of("Live_Orders")
        .save(orderData)
        .then((updatedOrder) {
      print(
          "Order Object has been updated in the database - ${updatedOrder['objectId']}");

      StorageUtil.putString("TempOrderID", updatedOrder["objectId"]);
    });

    ///save order to local storage
    int orderIndexInStorage = 0;
    bool ActiveOrderSaved = false;
    while (!ActiveOrderSaved) {
      if (StorageUtil.getString(
                  "ActiveOrder_" + orderIndexInStorage.toString()) ==
              null ||
          StorageUtil.getString(
                  "ActiveOrder_" + orderIndexInStorage.toString()) ==
              "") {
        try {
          StorageUtil.putString(
              "ActiveOrderID_" + orderIndexInStorage.toString(),
              StorageUtil.getString("TempOrderID"));
          print("The order ID that is saved " +
              StorageUtil.getString(
                  "ActiveOrderID_" + orderIndexInStorage.toString()));
          StorageUtil.deleteKey("TempOrderID");
          StorageUtil.putString(
              "ActiveOrderStatus_" + orderIndexInStorage.toString(),
              "Confirmation Pending");
          //need this to check the if condition we are running of this scope (if this is null only then we can save this as an active order in this index *we need this*)
          StorageUtil.putString(
              "ActiveOrder_" + orderIndexInStorage.toString(), "Order Active");
          StorageUtil.putString(
              "ActiveOrderAddress_" + orderIndexInStorage.toString(),
              userAddress);
          var now = new DateTime.now();
          var formatter = new DateFormat('yyyy-MM-dd');
          String formattedDate = formatter.format(now);
          print(formattedDate); // 2016-01-25

          StorageUtil.putString(
              "ActiveOrderDate_" + orderIndexInStorage.toString(),
              formattedDate.toString());
          StorageUtil.putInt(
              "ActiveOrderIndex_" + orderIndexInStorage.toString(),
              orderIndexInStorage);
          StorageUtil.putString(
              "ActiveOrderItemIDList_" + orderIndexInStorage.toString(),
              jsonID);
          StorageUtil.putString(
              "ActiveOrderItemNameList_" + orderIndexInStorage.toString(),
              jsonName);
          StorageUtil.putString(
              "ActiveOrderPayMode_" + orderIndexInStorage.toString(),
              paymentType);
          StorageUtil.putString(
              "ActiveOrderPriceList_" + orderIndexInStorage.toString(),
              jsonPrice);
          StorageUtil.putString(
              "ActiveOrderTotalPrice_" + orderIndexInStorage.toString(),
              totalCost.toString());
          StorageUtil.putString(
              "ActiveOrderQuantityList_" + orderIndexInStorage.toString(),
              jsonQuantity);
          ActiveOrderSaved = true;
        } catch (e) {
          ActiveOrderSaved = false;
          orderIndexInStorage++;
        }
      } else {
        orderIndexInStorage++;
      }
    }

    setState(() {
      _resetOrder();
    });
    print('Sent Order');
    /*
    ADMIN CODE
    DataQueryBuilder queryBuilderContent2 = DataQueryBuilder();
    new Future.delayed(const Duration(seconds: 5), () {
       Backendless.data
          .of("Live_Orders")
          .find(queryBuilderContent2)
          .then((changes) {
            for(int x = 0; x<changes.length;x++){
              Map itemJSON = changes[x]["ItemID_List"];
              print("Order: ${changes[x]["objectId"]}");
            }
      });

    });*/
  }

  _calculateTotal() {
    double total = serviceCharge;
    for (int x = 0; x < itemPrice.length; x++) {
      total += double.parse(itemPrice[x]) * quantityItem[x];
    }
    return total;
  }

  incrementItemQuantity(int index, bool isAdd) {
    if (quantityItem[index] == 1) {
      isAdd ? quantityItem[index] += 1 : quantityItem[index] = 1;
    } else {
      isAdd ? quantityItem[index] += 1 : quantityItem[index] -= 1;
    }

    StorageUtil.putString(
        "Cart_ItemQuantity_" + itemName[index], quantityItem[index].toString());

    totalCost = _calculateTotal();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.blueAccent[700],
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///a little bit of space never hurts.

              Row(
                children: [
                  Text(
                    "Basket",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 28,
                        fontFamily: 'Merriweather'),
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
                                    index: index,
                                    productPrice: "€${itemPrice[index]}",
                                    productImage: "ic_popular_food_1",
                                    productCartQuantity: StorageUtil.getString(
                                        "Cart_ItemQuantity_" +
                                            itemName[index])),
                                Row(
                                  children: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        incrementItemQuantity(index, false);
                                      },
                                      child: Text("-"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        incrementItemQuantity(index, true);
                                      },
                                      child: Text("+"),
                                    ),
                                  ],
                                ),
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
                      Container(
                        padding: const EdgeInsets.all(10),
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 2,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Basket is Empty",
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
                          borderRadius: BorderRadius.circular(3.0),
                          side: BorderSide(
                            color: Colors.black26,
                            width: 0.2,
                          ),
                        ),
                        child: totalDisplay(_calculateTotal()),
                      ),
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
                          onPressed: () {
                            if(User().isLoggedIn){
                              _confirmPayment();
                            } else{
                              navigateToSignIn();
                              Flushbar(
                                backgroundColor: Colors.red[900],
                                title:  "      Please Login to Continue..",
                                message:  " ",

                                duration:  Duration(seconds: 3),
                              )..show(context);
                            }
                           
                          },
                          child: Container(
                            child: Text(
                              User().isLoggedIn
                              ?"Confirm Order":"Login to Complete Order",
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
                            "Try our awesome offers!",
                          ],
                          textStyle: TextStyle(
                              fontSize: 30.0,
                              fontFamily: "Agne",
                              color: Colors.black45),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ]),
            ],
          ),
        ));
  }
navigateToSignIn() async{
  Navigator.popAndPushNamed(context,SIGN_IN);
}
  totalDisplay(double total) {
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
                            "Total Price:",
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
                            "€" + total.toString() + " (Plus VAT)",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF3a3a3b),
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerRight,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  String productName;
  String productPrice;
  String productImage;
  String productCartQuantity;
  int index;
  CartItem({
    Key key,
    @required this.productName,
    @required this.productPrice,
    @required this.productImage,
    @required this.productCartQuantity,
    @required this.index,
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
