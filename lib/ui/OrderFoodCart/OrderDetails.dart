import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';

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

  deleteLastActiveOrderKeys() {
    ///delete last key since stack is reset
    StorageUtil.deleteKey("ActiveOrderIndex_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey("ActiveOrderDate_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey("ActiveOrder_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey("ActiveOrderAddress_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey(
        "ActiveOrderItemIDList_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey(
        "ActiveOrderItemNameList_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey("ActiveOrderPayMode_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey(
        "ActiveOrderPriceList_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey(
        "ActiveOrderTotalPrice_" + (sizeOfList - 1).toString());
    StorageUtil.deleteKey(
        "ActiveOrderQuantityList_" + (sizeOfList - 1).toString());
  }

  deleteActiveOrder(int key) {
    try {
      if (key == 0 && sizeOfList == 1) {
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
      } else if (key == sizeOfList - 1) {
        deleteLastActiveOrderKeys();
      } else {
        for (int orderIndexInStorage = key;
            orderIndexInStorage < sizeOfList - 1;
            orderIndexInStorage++) {
          print("First pass" + orderIndexInStorage.toString());
          StorageUtil.putString(
              "ActiveOrder_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrder_" + (orderIndexInStorage + 1).toString()));
          StorageUtil.putString(
              "ActiveOrderAddress_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrderAddress" + (orderIndexInStorage + 1).toString()));
          StorageUtil.putString(
              "ActiveOrderDate_" + orderIndexInStorage.toString(),
              StorageUtil.getString(
                  "ActiveOrderDate_" + (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "ActiveOrderItemIDList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderItemIDList_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "ActiveOrderItemNameList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderItemNameList_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "ActiveOrderPayMode_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderPayMode_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "ActiveOrderPriceList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderPriceList_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "ActiveOrderTotalPrice_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderTotalPrice_" +
                  (orderIndexInStorage + 1).toString()));

          StorageUtil.putString(
              "ActiveOrderQuantityList_" + orderIndexInStorage.toString(),
              StorageUtil.getString("ActiveOrderQuantityList_" +
                  (orderIndexInStorage + 1).toString()));
          print("Second pass" + orderIndexInStorage.toString());
        }

        deleteLastActiveOrderKeys();
        //  print("Third pass: deleting last keys: " + (sizeOfList - 1).toString());
      }

      ///refresh page to re initialize the list
      setState(() {
        Navigator.pop(context, "Successfully Removed!");
      });
    } catch (e) {
      Navigator.pop(context, "Error Occurred");
    }
  }

  retrieveOrderDetails() {
    return Column(
      children: [
        Container(
          child: Text("Sup mate this your orders"),
        ),
        TextButton(
            onPressed: () {
              deleteActiveOrder(order.currentIndex);
            },
            child: Container(
              child: Text("Delete Order"),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: retrieveOrderDetails(),
    );
  }
}
