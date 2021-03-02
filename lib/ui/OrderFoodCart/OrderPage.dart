import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';

import 'OrderDetails.dart';

class OrderPageTab extends StatefulWidget {
  @override
  _OrderPageTabState createState() => _OrderPageTabState();
}

class _OrderPageTabState extends State<OrderPageTab> {
  String userID;
  List Orders;
  int sizeOfList;

  String result;
  @override
  void initState() {
    super.initState();
    getOrderListSize();

    Orders = getActiveOrders();
    print("Order page orders loaded");


  }
  showAlertDialog(BuildContext context , String textString) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context);},
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
  getOrderListSize() {
    sizeOfList = 0;
    while (
        StorageUtil.getString("ActiveOrder_" + sizeOfList.toString()) != '') {
      sizeOfList += 1;
    }
    print("Size of List : " + sizeOfList.toString());
  }

  Card makeCard(Order order) => Card(
        elevation: 8.0,
        child: ClipPath(
          child: Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.black,
                border:
                    Border(right: BorderSide(color: Colors.white, width: 8))),
            child: makeListTile(order),
          ),
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3))),
        ),
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      );

  ListTile makeListTile(Order order) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          "Order Date: " + order.orderDate,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(order.Address,
                      style: TextStyle(color: Colors.white))),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Total Price: €" + order.totalCost.toString(),
                      style: TextStyle(color: Colors.white))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          result  = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new OrderDetails(order: order, sizeOfList: sizeOfList,)),
          );
          if(result == "Successfully Removed!" ||result == "Error Occurred" ){
            showAlertDialog(context, result);

            result = "";

            Orders = getActiveOrders();
            getOrderListSize();
            setState(() {

            });
          }
        },
      );

  convertToList(String firstPartOfString) {
    List<String> second;
    var imgs = json.decode(StorageUtil.getString(firstPartOfString));
    second = new List(imgs.length);
    for (int x = 0; x < imgs.length; x++) {
      second[x] = imgs[x].toString();
    }
    return second;
  }


  List<Order> getActiveOrders() {
    int x = 0;
    bool isEOL = false;
    var re = (StorageUtil.getKeyPrefs());
    for (String r in re) {
      try {
        print("$r : " + StorageUtil.getString(r).toString());
      } catch (e) {
        try {
          print("$r : " + StorageUtil.getBool(r).toString());
        } catch (ex) {
          print("$r : " + StorageUtil.getInt(r).toString());
        }
      }
    }

    List<Order> orderList = new List(sizeOfList);
    //test data
    userID = "User123";
    isEOL = false;

    for (x = 0; x < sizeOfList; x++) {
      orderList[x] = Order(
          currentIndex: StorageUtil.getInt("ActiveOrderIndex_" + x.toString()),
          orderDate: StorageUtil.getString("ActiveOrderDate_" + x.toString()),
          UserID: userID,
          Address: StorageUtil.getString("ActiveOrderAddress_" + x.toString()),
          quantityItem:
              convertToList("ActiveOrderQuantityList_" + x.toString()),
          totalCost: double.parse(
              StorageUtil.getString("ActiveOrderTotalPrice_" + x.toString())),
          itemPrice: convertToList("ActiveOrderPriceList_" + x.toString()),
          itemID: convertToList("ActiveOrderItemIDList_" + x.toString()),
          itemName: convertToList("ActiveOrderItemNameList_" + x.toString()),
          modeOfPayment:
              StorageUtil.getString("ActiveOrderPayMode_" + x.toString()));
    }
    return orderList;
  }

  getActiveOrderList() {
    try {
      return sizeOfList > 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sizeOfList,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(Orders[(sizeOfList - 1) - index]);
              },
            )
          : Column(
              children: [
                Container(
                  height: 50,
                ),
                Center(
                    child: Text(
                  "You have no Active orders!",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(5.0, 2.0),
                        blurRadius: 7.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                )),
                Center(
                  child: Image.asset(
                    "assets/images/emptyplate.png",
                    width: 250,
                  ),
                ),
              ],
            );
    } catch (e) {
      return Column(
        children: [
          Center(child: Text("Loading your orders...")),
          Center(child: LinearProgressIndicator()),
        ],
      );
    }
  }

  ///Previous Orders
  getPreviousOrdersList(){
    return Text("Here lays the previous orders ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Center(
          child: Text("Orders",
            style: TextStyle(
            color: Colors.white,
            fontSize:20,
            fontWeight: FontWeight.bold,
          ),),
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 95, 54, 1),
      body: Column(children: <Widget>[
        Divider(color: Colors.black26,),
        Container(
          padding: const EdgeInsets.symmetric(vertical:3,horizontal: 10),
          alignment:Alignment.centerLeft,
          child: Text(

            "Active orders",
            style: TextStyle(
              color: Colors.white70,
              fontSize:15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(color: Colors.black26,),
        getActiveOrderList(),
        Divider(color: Colors.black26,),
        Container(
          padding: const EdgeInsets.symmetric(vertical:3,horizontal: 10),
          alignment:Alignment.centerLeft,
          child: Text(

            "Previous orders",
            style: TextStyle(
              color: Colors.white70,
              fontSize:15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(color: Colors.black26,),
        getPreviousOrdersList(),
      ]),
    );
  }
}

class Order {
  int currentIndex;
  String UserID;
  String orderID = "";
  String Address;
  String orderDate;
  List<String> itemName;
  List<String> itemPrice;
  String modeOfPayment;
  List<String> itemID;
  List<String> quantityItem;
  double totalCost = 0.0;
  Order(
      {this.currentIndex,
      this.UserID,
      this.orderID,
      this.Address,
      this.quantityItem,
      this.totalCost,
      this.itemPrice,
      this.itemName,
      this.itemID,
      this.orderDate,
      this.modeOfPayment});
}
