import 'package:backendless_sdk/backendless_sdk.dart';

class BackendlessUtil {
  static final BackendlessUtil beUtil = BackendlessUtil._internal();

  factory BackendlessUtil() {
    return beUtil;
  }

  BackendlessUtil._internal();

  initializeBackend(){
    Backendless.setUrl("https://eu-api.backendless.com");

    Backendless.initApp(
        "13A22BAC-C06B-C97D-FF9D-BEF9E8D5CD00",
        "B74F9B50-B1AF-4A7C-8185-4ACA2B4EC917",
        "5AABF002-30D5-4761-91B3-38847D41B723");

  }

  var updatesColumn = "", updatesRecord = "";
  createListenerColumn(String tableName, String column) {
    EventHandler<Map> orderEventHandler = Backendless.data.of(tableName).rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      //print("An Order object has been updated. Object ID - ${updatedOrder}");
      updatesColumn = updatedOrder[column].toString();
    });
  }

  createListenerRecord(String tableName) {
    EventHandler<Map> orderEventHandler = Backendless.data.of(tableName).rt();

//have to insert socket.io for this listener
    orderEventHandler.addUpdateListener((updatedOrder) {
      //print("An Order object has been updated. Object ID - ${updatedOrder}");
      updatesRecord = updatedOrder.toString();
    });
  }
}
