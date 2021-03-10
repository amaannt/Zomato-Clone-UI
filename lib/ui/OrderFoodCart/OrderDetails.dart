import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';
import 'package:zomatoui/constants/colors.dart';

import 'OrderPage.dart';

class OrderDetails extends StatefulWidget {
  Order order;
  int sizeOfList;
  OrderDetails({this.order, this.sizeOfList});
  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetails> {
  Order order;
  int sizeOfList;

  @override
  void initState() {
    super.initState();
    this.order = widget.order;
    this.sizeOfList = widget.sizeOfList;
  }

  Future<void> _showDeleteWarning() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text('Are you sure you want to delete this Order?'),
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
                deleteOrder(order.currentIndex, sizeOfList);
              },
            ),
          ],
        );
      },
    );
  }
///****12 keys, don't forget****///
  deleteLastOrderKeys(int size) {
    ///delete last key since stack is reset
    StorageUtil.deleteKey("PreviousOrderIndex_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderDate_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrder_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderAddress_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderItemIDList_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderItemNameList_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderPayMode_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderPriceList_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderTotalPrice_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderQuantityList_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderID_" + (size - 1).toString());
    StorageUtil.deleteKey("PreviousOrderStatus_" + (size - 1).toString());
  }

  deleteOrder(int key, int size) {
    //if accessed from the details page
    Navigator.of(context).pop();
    try {
      if (key == 0 && size == 1) {
        ///delete the one and only element of the orders
        StorageUtil.deleteKey("PreviousOrderIndex_0");
        StorageUtil.deleteKey("PreviousOrderDate_0");
        StorageUtil.deleteKey("PreviousOrder_0");
        StorageUtil.deleteKey("PreviousOrderAddress_0");
        StorageUtil.deleteKey("PreviousOrderItemIDList_0");
        StorageUtil.deleteKey("PreviousOrderItemNameList_0");
        StorageUtil.deleteKey("PreviousOrderPayMode_0");
        StorageUtil.deleteKey("PreviousOrderPriceList_0");
        StorageUtil.deleteKey("PreviousOrderTotalPrice_0");
        StorageUtil.deleteKey("PreviousOrderQuantityList_0");
        StorageUtil.deleteKey("PreviousOrderID_0");
        StorageUtil.deleteKey("PreviousOrderStatus_0");
      } else if (key == size - 1) {
        deleteLastOrderKeys(size);
      } else {
        for (int orderIndexInStorage = key;
        orderIndexInStorage < size - 1;
        orderIndexInStorage++) {
          print("First pass" + orderIndexInStorage.toString());
          StorageUtil.putString(
              "PreviousOrder_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "PreviousOrder_" + (orderIndexInStorage + 1).toString()));
          StorageUtil.putString(
              "PreviousOrderAddress_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "PreviousOrderAddress" + (orderIndexInStorage + 1).toString()));
          StorageUtil.putString(
              "PreviousOrderDate_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "PreviousOrderDate_" + (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "PreviousOrderItemIDList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("PreviousOrderItemIDList_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "PreviousOrderItemNameList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("PreviousOrderItemNameList_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "PreviousOrderPayMode_" + orderIndexInStorage.toString(),
              StorageUtil.getString("PreviousOrderPayMode_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "PreviousOrderPriceList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("PreviousOrderPriceList_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "PreviousOrderTotalPrice_" + orderIndexInStorage.toString(),
              StorageUtil.getString("PreviousOrderTotalPrice_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "PreviousOrderQuantityList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("PreviousOrderQuantityList_" +
                  (orderIndexInStorage + 1).toString()));
          //order id list
          StorageUtil.putString(
              "PreviousOrderID_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "PreviousOrderID_" + (orderIndexInStorage + 1).toString()));
          //order status
          StorageUtil.putString(
              "PreviousOrderStatus_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "PreviousOrderStatus_" + (orderIndexInStorage + 1).toString()));
          print("Second pass" + orderIndexInStorage.toString());
        }

        deleteLastOrderKeys(size);
        //  print("Third pass: deleting last keys: " + (sizeOfList - 1).toString());
      }

      //if accessed from OrderDetails Page

      ///refresh page to re initialize the list
      setState(() {
        Navigator.pop(context, "Successfully Removed!");
      });

    } catch (e) {
      Navigator.pop(context, "Error Occurred");
    }
  }

  retrieveOrderDetails() {
    return Flexible(
      child: ListView.builder(
          itemCount: order.itemName.length,
          itemBuilder: (BuildContext context, int index) {
            print(sizeOfList);
            return Container(
              height: 100,
              child: Card(
                child: new Column(
                  children: [
                    Container(
                        child: Text(order.itemName[index].toString() +
                            " x " +
                            order.quantityItem[index] +
                            "   \$" +
                            order.itemPrice[index])),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: Column(children: <Widget>[
            retrieveOrderDetails(),
            Card(
              child: Text("Order Date: " + order.orderDate),
            ),
            Card(
              child: Text("Total Price: " + order.totalCost.toString()),
            ),
          ]),
        ),
        Flexible(
          child: order.orderStatus == "Delivered"
              ? OutlineButton(
                  highlightedBorderColor: AppColors.highlighterPink,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        EvilIcons.close_o,
                        color: AppColors.highlighterPink,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      new Text(
                        "Delete",
                        style: TextStyle(color: AppColors.highlighterPink),
                      ),
                    ],
                  ),
                  onPressed: () {
                    _showDeleteWarning();
                  },
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)))
              : Container(child: Text("Rate us :)")), ///ADD A RATING OR REVIEW AREA OR SOMETHING
        ),
      ]),
    );
  }
}
