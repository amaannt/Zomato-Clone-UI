import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zomatoui/Model/ListenerModel.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';

import 'OrderDetails.dart';
import 'package:zomatoui/ui/OrderFoodCart/PreviousOrder.dart';

class OrderPageTab extends StatefulWidget {
  @override
  _OrderPageTabState createState() => _OrderPageTabState();
}

class _OrderPageTabState extends State<OrderPageTab> {
  ///User details
  String userID = "User123";

  ///Order variables
  //current active orders
  List<Order> activeOrders;
  //history of orders
  List<Order> previousOrders;

  //total size of active order list
  int sizeOfActiveList = 0;

  //total size of History of Orders
  int sizeOfHistoryList = 0;

  ///update status of orders
  String updateStatus = "";
  String updateOrderID = "";

  String result;
  @override
  void initState() {
    super.initState();

    ///listen for order status changes
   // createListener();

    //get active order list size
    getOrderListSizes();

    activeOrders = getOrdersFromStorage(true, sizeOfActiveList);
    previousOrders = getOrdersFromStorage(false, sizeOfHistoryList);
    print("Order page orders loaded");


  }

  handleUpdates(){
    if (updateStatus == "Delivered") {
      // run through each active order
      for (int x = 0; x < sizeOfActiveList; x++) {
        print(StorageUtil.getString("ActiveOrderID_" + x.toString()));
        //if the order matches then; store previous order, delete active order and reset the class object array with new size and content
        if (updateOrderID ==
            StorageUtil.getString("ActiveOrderID_" + x.toString())) {

          //send x as the index of the order in both the storage and Order object index
          //store active order as previous order
          storePreviousOrder(x, updateStatus);
          //delete active order when confirmed
          deleteActiveOrder(x, sizeOfActiveList);
          //get new sizes of both order types
          getOrderListSizes();
          //reset and initialize the order lists, with new sizes and orders
          //getOrdersFromStorage(bool isActiveOrder, int sizeOfOrders)
          activeOrders = getOrdersFromStorage(true, sizeOfActiveList);
          previousOrders = getOrdersFromStorage(false, sizeOfHistoryList);
          /*setState(() {

          });*/
        }
      }
    }
    else {

      for (int x = 0; x < sizeOfActiveList; x++) {
        //print(updateOrderID+" and  "+StorageUtil.getString("ActiveOrderID_" + x.toString()));
        if (updateOrderID ==
            StorageUtil.getString("ActiveOrderID_" + x.toString())) {
          //print("Found order and changed variables");

          ///change storage content
          StorageUtil.putString(
              "ActiveOrderStatus_" + x.toString(), updateStatus);
          ///change object content(list)
          activeOrders[x].orderStatus = updateStatus;
          activeOrders = getOrdersFromStorage(true, sizeOfActiveList);
         /* setState(() {});*/
          break;
        }
      }
    }
  }
  ///Listen to Active order changes Specific to user account ID
  createListener() {
    bool isChanged = false;
    EventHandler<Map> orderEventHandler =
        Backendless.data.of("Live_Orders").rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      print("An Order object has been updated. Object ID - ${updatedOrder}");
      updateStatus = updatedOrder["Order_Status"].toString();
      updateOrderID = updatedOrder["objectId"];
      // change the active stored order as per the order status
      if (updateStatus == "Delivered") {
        // run through each active order
        for (int x = 0; x < sizeOfActiveList; x++) {
          print(StorageUtil.getString("ActiveOrderID_" + x.toString()));
          //if the order matches then; store previous order, delete active order and reset the class object array with new size and content
          if (updateOrderID ==
              StorageUtil.getString("ActiveOrderID_" + x.toString())) {

            //send x as the index of the order in both the storage and Order object index
            //store active order as previous order
            storePreviousOrder(x, updateStatus);
            //delete active order when confirmed
            deleteActiveOrder(x, sizeOfActiveList);
            //get new sizes of both order types
            getOrderListSizes();
            //reset and initialize the order lists, with new sizes and orders
            //getOrdersFromStorage(bool isActiveOrder, int sizeOfOrders)
            activeOrders = getOrdersFromStorage(true, sizeOfActiveList);
            previousOrders = getOrdersFromStorage(false, sizeOfHistoryList);
            setState(() {

            });}
        }
      }
      else {

        for (int x = 0; x < sizeOfActiveList; x++) {
          //print(updateOrderID+" and  "+StorageUtil.getString("ActiveOrderID_" + x.toString()));
          if (updateOrderID ==
              StorageUtil.getString("ActiveOrderID_" + x.toString())) {
            //print("Found order and changed variables");

            ///change storage content
            StorageUtil.putString(
                "ActiveOrderStatus_" + x.toString(), updateStatus);
            ///change object content(list)
            activeOrders[x].orderStatus = updateStatus;
            activeOrders = getOrdersFromStorage(true, sizeOfActiveList);
            setState(() {});
            break;
          }
        }
      }
      // if the order isn't complete, just change the active order status
      setState(() {});
    }, whereClause: "User_ID =" + userID.toString());
  }

  ///Store Active order as a Previous Order, which makes it a part of the Order History
  storePreviousOrder(int orderIndexInStorage, String orderStatus) {
    var jsonID = json.encode(activeOrders[orderIndexInStorage].itemID);
    var jsonName = json.encode(activeOrders[orderIndexInStorage].itemName);
    var jsonPrice = json.encode(activeOrders[orderIndexInStorage].itemPrice);
    var jsonQuantity =
        json.encode(activeOrders[orderIndexInStorage].quantityItem);
    int pIndex = 0;
    bool previousOrderSaved = false;
    while (!previousOrderSaved) {
      if (StorageUtil.getString("PreviousOrder_" + pIndex.toString()) == null ||
          StorageUtil.getString("PreviousOrder_" + pIndex.toString()) == "") {
        try {
          StorageUtil.putString("PreviousOrderID_" + pIndex.toString(),
              activeOrders[orderIndexInStorage].orderID);
          StorageUtil.putString(
              "PreviousOrderStatus_" + pIndex.toString(), orderStatus);

          StorageUtil.putString("PreviousOrderAddress_" + pIndex.toString(),
              activeOrders[orderIndexInStorage].Address);
          StorageUtil.putString(
              "PreviousOrder_" + pIndex.toString(), "History Order Exists");
          StorageUtil.putString("PreviousOrderDate_" + pIndex.toString(),
              activeOrders[orderIndexInStorage].orderDate);
          StorageUtil.putInt("PreviousOrderIndex_" + pIndex.toString(), pIndex);
          StorageUtil.putString(
              "PreviousOrderItemIDList_" + pIndex.toString(), jsonID);
          StorageUtil.putString(
              "PreviousOrderItemNameList_" + pIndex.toString(), jsonName);
          StorageUtil.putString("PreviousOrderPayMode_" + pIndex.toString(),
              activeOrders[orderIndexInStorage].modeOfPayment);
          StorageUtil.putString(
              "PreviousOrderPriceList_" + pIndex.toString(), jsonPrice);
          StorageUtil.putString("PreviousOrderTotalPrice_" + pIndex.toString(),
              activeOrders[orderIndexInStorage].totalCost.toString());
          StorageUtil.putString(
              "PreviousOrderQuantityList_" + pIndex.toString(), jsonQuantity);
          previousOrderSaved = true;
        } catch (e) {
          previousOrderSaved = false;
          pIndex++;
        }
      } else {
        pIndex++;
      }
    }
  }

  ///deleting Active orders from one part of storage and putting them in Previous orders
  deleteActiveOrder(int key, int size) {
    //if accessed from the details page

    try {
      if (key == 0 && size == 1) {
        ///delete the one and only element of the orders
        StorageUtil.deleteKey("ActiveOrderIndex_0");
        StorageUtil.deleteKey("ActiveOrderDate_0");
        StorageUtil.deleteKey("ActiveOrder_0");
        StorageUtil.deleteKey("ActiveOrderAddress_0");
        StorageUtil.deleteKey("ActiveOrderItemIDList_0");
        StorageUtil.deleteKey("ActiveOrderItemNameList_0");
        StorageUtil.deleteKey("ActiveOrderPayMode_0");
        StorageUtil.deleteKey("ActiveOrderPriceList_0");
        StorageUtil.deleteKey("ActiveOrderTotalPrice_0");
        StorageUtil.deleteKey("ActiveOrderQuantityList_0");
        StorageUtil.deleteKey("ActiveOrderID_0");
        StorageUtil.deleteKey("ActiveOrderStatus_0");
      } else if (key == size - 1) {
        deleteLastActiveOrderKeys(size);
      } else {
        for (int orderIndexInStorage = key;
            orderIndexInStorage < size - 1;
            orderIndexInStorage++) {
          print("First pass" + orderIndexInStorage.toString());
          //order active to check if it exists or not first
          StorageUtil.putString(
              "ActiveOrder_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrder_" + (orderIndexInStorage + 1).toString()));
          //order address
          StorageUtil.putString(
              "ActiveOrderAddress_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrderAddress" + (orderIndexInStorage + 1).toString()));
          //order date
          StorageUtil.putString(
              "ActiveOrderDate_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrderDate_" + (orderIndexInStorage + 1).toString()));
          //orderitem list
          StorageUtil.putString(
              "ActiveOrderItemIDList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderItemIDList_" +
                  (orderIndexInStorage + 1).toString()));
          //order itemname list
          StorageUtil.putString(
              "ActiveOrderItemNameList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderItemNameList_" +
                  (orderIndexInStorage + 1).toString()));
          //order payment method
          StorageUtil.putString(
              "ActiveOrderPayMode_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderPayMode_" +
                  (orderIndexInStorage + 1).toString()));
          //order item price list
          StorageUtil.putString(
              "ActiveOrderPriceList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderPriceList_" +
                  (orderIndexInStorage + 1).toString()));
          //order total price
          StorageUtil.putString(
              "ActiveOrderTotalPrice_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderTotalPrice_" +
                  (orderIndexInStorage + 1).toString()));
          //order item quantity list
          StorageUtil.putString(
              "ActiveOrderQuantityList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderQuantityList_" +
                  (orderIndexInStorage + 1).toString()));
          //order id list
          StorageUtil.putString(
              "ActiveOrderID_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrderID_" + (orderIndexInStorage + 1).toString()));
          //order status
          StorageUtil.putString(
              "ActiveOrderStatus_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrderStatus_" + (orderIndexInStorage + 1).toString()));
          print("Second pass" + orderIndexInStorage.toString());
        }

        deleteLastActiveOrderKeys(size);
        //  print("Third pass: deleting last keys: " + (sizeOfList - 1).toString());
      }
    } catch (e) {
      setState(() {
        showAlertDialog(
            context, "Error Occurred while receiving order information");
      });
    }
  }

  ///Delete the last Active order
  deleteLastActiveOrderKeys(int size) {
    ///delete last key since stack is reset
    StorageUtil.deleteKey("ActiveOrderIndex_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderDate_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrder_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderAddress_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderItemIDList_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderItemNameList_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderPayMode_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderPriceList_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderTotalPrice_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderQuantityList_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderID_" + (size - 1).toString());
    StorageUtil.deleteKey("ActiveOrderStatus_" + (size - 1).toString());
  }

  ///Show alerts
  showAlertDialog(BuildContext context, String textString) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
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

  ///Get amount of orders in both active and history
  getOrderListSizes() {
    sizeOfActiveList = 0;
    sizeOfHistoryList = 0;
    while (
        StorageUtil.getString("ActiveOrder_" + sizeOfActiveList.toString()) !=
            '') {
      sizeOfActiveList += 1;
    }
    while (StorageUtil.getString(
            "PreviousOrder_" + sizeOfHistoryList.toString()) !=
        '') {
      sizeOfHistoryList += 1;
    }
    print("Size of Active List : " + sizeOfActiveList.toString());
    print("Size of History List : " + sizeOfHistoryList.toString());
  }

  ///Widget design for orders
  Card makeCard(Order order) => Card(
        elevation: 8.0,
        child: ClipPath(
          child: Container(

            height: 120,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
        title: Text(
          "Order Date: " + order.orderDate,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: <Widget>[
            Flexible(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text("Order Status: " + order.orderStatus,
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                )),
            Expanded(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(order.Address,
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ),
            Flexible(
              flex: 4,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Total Price: €" + order.totalCost.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            )
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () async {
          result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new OrderDetails(
                      order: order,
                      sizeOfList: order.orderStatus=="Delivered"?sizeOfHistoryList:sizeOfActiveList,
                    )),
          );
          if (result == "Successfully Removed!" || result == "Error Occurred") {
            showAlertDialog(context, result);

            /// first get tbe size of the list
            getOrderListSizes();
            result = "";

            /// next get the orders for the refresh
            activeOrders = getOrdersFromStorage(true, sizeOfActiveList);
            previousOrders = getOrdersFromStorage(false, sizeOfHistoryList);
            setState(() {});
          }
        },
      );

  ///Convert the Json String to a list
  convertToList(String firstPartOfString) {
    List<String> second;
    var imgs = json.decode(StorageUtil.getString(firstPartOfString));
    second = new List(imgs.length);
    for (int x = 0; x < imgs.length; x++) {
      second[x] = imgs[x].toString();
    }
    return second;
  }

  ///this is the list loader for Orders
  List<Order> getOrdersFromStorage(bool isActive, int size) {
    int x = 0;
    String orderType;
    List<Order> orderList = new List(size);

    isActive ? orderType = "Active" : orderType = "Previous";

    for (x = 0; x < size; x++) {
      orderList[x] = Order(
          orderStatus:
              StorageUtil.getString(orderType + "OrderStatus_" + x.toString()),
          orderID: StorageUtil.getString(orderType + "OrderID_" + x.toString()),
          currentIndex:
              StorageUtil.getInt(orderType + "OrderIndex_" + x.toString()),
          orderDate:
              StorageUtil.getString(orderType + "OrderDate_" + x.toString()),
          UserID: userID,
          Address:
              StorageUtil.getString(orderType + "OrderAddress_" + x.toString()),
          quantityItem:
              convertToList(orderType + "OrderQuantityList_" + x.toString()),
          totalCost: double.parse(StorageUtil.getString(
              orderType + "OrderTotalPrice_" + x.toString())),
          itemPrice:
              convertToList(orderType + "OrderPriceList_" + x.toString()),
          itemID: convertToList(orderType + "OrderItemIDList_" + x.toString()),
          itemName:
              convertToList(orderType + "OrderItemNameList_" + x.toString()),
          modeOfPayment: StorageUtil.getString(
              orderType + "OrderPayMode_" + x.toString()));
    }
    return orderList;
  }

  /// this is the widgets loader for Orders
  getActiveOrderList() {
    try {
      return sizeOfActiveList > 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: sizeOfActiveList,
              itemBuilder: (BuildContext context, int index) {
                if (activeOrders[sizeOfActiveList - 1 - index].orderStatus !=
                    "Delivered")
                  return makeCard(activeOrders[(sizeOfActiveList - 1) - index]);
                else
                  return Container();
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

  getPreviousOrderList() {
    try {
      return sizeOfHistoryList > 0
          ? ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: sizeOfHistoryList,
        itemBuilder: (BuildContext context, int index) {

            return makeCard(previousOrders[(sizeOfHistoryList - 1) - index]);

        },
      )
          : Column(
        children: [
          Container(
            height: 50,
          ),
          Center(
              child: Text(
                "You have no Past Orders!",
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

  @override
  Widget build(BuildContext context) {

    Provider.of<ListenOrderModel>(context).notifyChanges();
    try{final messagePrint= Provider.of<ListenOrderModel>(context);
    updateStatus = messagePrint.updateStatus;
    updateOrderID = messagePrint.updateOrderID;
    handleUpdates();}
    catch(e){
      return LinearProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        title: Center(
          child: Text(
            "Orders",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 95, 54, 1),
      body: ListView(

          children: <Widget>[
        Divider(
          color: Colors.black26,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            "Active orders",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(
          color: Colors.black26,
        ),
        ///GETS THE ACTIVE ORDERS HERE
        getActiveOrderList(),
        Divider(
          color: Colors.black26,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            "Previous orders",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(
          color: Colors.black26,
        ),
        ///GETS THE HISTORY OF ORDERS HERE
getPreviousOrderList(),
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
  String orderStatus;

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
      this.orderStatus,
      this.modeOfPayment});
}
