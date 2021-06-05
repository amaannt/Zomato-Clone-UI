import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:zomatoui/Model/User.dart';

class ListenOrderModel extends ChangeNotifier{

  ///Singleton Instance creator
  static final ListenOrderModel _singleton = ListenOrderModel._internal();

  factory ListenOrderModel() {
    return _singleton;
  }

  ListenOrderModel._internal();
  ///initialize update variables
  String updateStatus="";
  String updateOrderID="";
  //ListenOrderModel({this.userID});
  ///Listen to Active order changes Specific to user account ID
  EventHandler<Map> orderEventHandler;
 void createListen() {
    orderEventHandler =
    Backendless.data.of("Live_Orders").rt();
    print("Starting Update Listener");
//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      print("An Order object has been updated. Object ID - ${updatedOrder}");
      print("${updatedOrder["ownerId"]} and ${User().id}" + updateStatus);
      print(updatedOrder["UserPhone_Number"] == User().phone  );
      //find a better way to compare
      if(updatedOrder["UserPhone_Number"] == User().phone) {

        this.updateStatus = updatedOrder["Order_Status"].toString();
        this.updateOrderID = updatedOrder["objectId"];
        notifyChanges();
      }

    },);
  }

  deleteListener(){
    orderEventHandler.removeUpdateListeners();

  }
  Future <void> notifyChanges() async => Future.delayed(const Duration(seconds: 3), () {
      notifyListeners();
    });
}