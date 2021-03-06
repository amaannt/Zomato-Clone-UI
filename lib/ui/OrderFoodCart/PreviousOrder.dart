import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'OrderPage.dart';

class PreviousOrderState extends StatefulWidget {
  @override
  _PreviousOrderState createState() => _PreviousOrderState();
}

class _PreviousOrderState extends State<PreviousOrderState> {
  List<Order> orders;

  String updates = "";
  bool isRefresh = false;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    createListener();
  }

  createListener() {
    EventHandler<Map> orderEventHandler =
        Backendless.data.of("Live_Orders").rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      print("An Order object has been updated. Object ID - ${updatedOrder}");
      updates = updatedOrder["User_ID"].toString();
      setState(() {});
      isRefresh = true;
    });
  }

  Future<String> orderPanels() async {
    return updates;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("updates : " + updates),
    );
  }
}
