import 'dart:convert';

import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:intl/intl.dart';
import 'package:zomatoui/Utils/LanguageController.dart';
import 'package:zomatoui/Utils/StorageUtil.dart';

import 'ListenerModel.dart';

class User {
  String id;
  String email;
  String fname;
  String lastName;
  String displayName;
  String phone;
  String address;
  String languageSelection;
  String wordPass;
  String accountType;
  bool isLoggedIn = false;
  bool isPhoneVerified = false;
  static final User _user = User._internal();
  BackendlessUser bkU = new BackendlessUser();
  factory User() {
    return _user;
  }
  User._internal();

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['ownerId'] = user.id;
    data['email'] = user.email;
    data['First_Name'] = user.displayName;
    data['AddressList'] = user.address;
    data['phone'] = user.phone;
    data['languageSelected'] = user.languageSelection;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.id = mapData['ownerId'];
    this.email = mapData['email'];
    this.fname = mapData['First_Name'];
    this.lastName = mapData['Last_Name'];
    this.displayName = mapData['First_Name'];
    this.address = mapData['AddressList'];
    this.phone = mapData['phone'];
  }

  Future userRegistration(String regFirstName, String regLastName,
      String emailId, String phoneNo, String pass) async {
    bkU = new BackendlessUser();
    //CHECK IF USER EXISTS

    bkU.email = emailId;
    bkU.password = pass;
    bkU.setProperty("First_Name", regFirstName);
    bkU.setProperty("Last_Name", regLastName);
    bkU.setProperty("phone", phoneNo);
    bkU.setProperty(
        "languageSelected", LanguageInformation().getActiveLanguage());

    var responseMessage = false;
    try {
      await Backendless.userService.register(bkU).then((registeredUser) {
        print("From registration server: " + registeredUser.toString());
        if (registeredUser.getProperty("userStatus") ==
                "EMAIL_CONFIRMATION_PENDING" ||
            registeredUser.getProperty("userStatus") == "ENABLED") {
          responseMessage = true;
          bkU = registeredUser;
          applyUserDetailLocal(registeredUser, true, "");
          id = registeredUser.getProperty("objectId");
        }
        // user has been registered and now can login
      });

      return true;
    } catch (e) {
      return responseMessage;
    }
  }

  Future<bool> updateKeyProperty(List<String> key, List<String> value) async {
    bool responseMessage = false;

    for (int x = 0; x < key.length; x++) {
      if (key[x] == "email") {
        bkU.email = value[x];
      } else {
        bkU.setProperty("${key[x]}", "${value[x]}");
      }
    }

    ///Updates the changed User Data
    await Backendless.userService.update(bkU).then((user) {
      // user has been updated
      responseMessage = true;
      applyUserDetailLocal(user, false, address);
    });

    ///If successfully updated, change the local variables of the singleton user class
    /*if (responseMessage) {
      for (int x = 0; x < key.length; x++) {
        switch (key[x]) {
          case "phone":
            phone = value[x];
            break;
          case "email":
            email = value[x];
            break;
          case "First_Name":
            fname = value[x];
            break;
          case "Last_Name":
            lastName = value[x];
            break;
          default:
            break;
        }
      }
    }*/
    return responseMessage;
  }

  Future<bool> loginStatus() async {
    bool isValidLog = false;
    await Backendless.userService.isValidLogin().then((response) {
      isValidLog = response;
    });
    return isValidLog;
  }

  Future logoutProcess() async {
    try {
      await Backendless.userService.logout().then((response) {
        // user has been logged out.
        // ListenOrderModel().deleteListener();
        ///Change user Status
        isLoggedIn = false;
        ///Stop Listeners for Orders
        if (StorageUtil.getBool("OrderListenerActive")) {
          try{ListenOrderModel().deleteListener();}
          catch(e){}
        }
        ///Remove User Details From Storage
        StorageUtil.putString("userStoredKeys", "");
        StorageUtil.putString("userStoredValues", "");
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  ///DONT FORGET TO VALIDATE THIS PHONE NUMBER
  Future<bool> userPhoneConfirmation(String phoneNo) async {
    isPhoneVerified = false;
    //function to confirm verify phone number
    await new Future.delayed(const Duration(seconds: 2, milliseconds: 500), () {
      isPhoneVerified = true;
    });
    return isPhoneVerified;
  }

  applyUserDetailLocal(
      BackendlessUser thisUser, bool isNewUser, String Address) {
    bkU = thisUser;
    try {
      print("User with email:" +
          thisUser.email +
          " registered with ID:" +
          thisUser.getProperty("objectId"));
    } catch (e) {}

    fname = thisUser.getProperty("First_Name");
    lastName = thisUser.getProperty("Last_Name");
    email = thisUser.email;
    phone = thisUser.getProperty("phone");

    displayName = thisUser.getProperty("First_Name");

    ///Apply logged in status in app local
    isLoggedIn = true;

    ///Apply logged in status in app storage
    StorageUtil.putBool('isLoggedIn', true);

    accountType = thisUser.getProperty("socialAccount");
    if (isNewUser) {
      address = "[]";
    } else {
      address = Address;
    }
  }

  applyUserDetailLocalInit(var thisUser) {
    //bkU = thisUser;
    try {
      print("User with email:" +
          thisUser.email +
          " registered with ID:" +
          thisUser.getProperty("objectId"));
    } catch (e) {}

    fname = thisUser["First_Name"];
    lastName = thisUser["Last_Name"];
    email = thisUser["email"];
    phone = thisUser["phone"];

    displayName = thisUser["First_Name"];

    ///Apply logged in status in app local
    isLoggedIn = true;

    ///Apply logged in status in app storage
    StorageUtil.putBool('isLoggedIn', true);

    accountType = thisUser["socialAccount"];
  }

  dynamicToBackendlessUser(var hold) {
    ///CONVERTS FROM MAP<DYNAMIC,DYNAMIC> TO BACKENDLESS FORMAT
    /*bkU.email = hold["email"];
  bkU.setProperty("First_Name", hold["First_Name"]);
  bkU.setProperty("Last_Name", hold["Last_Name"]);
  bkU.setProperty("phone", hold["phone"]);
  bkU.setProperty(
      "languageSelected", hold["languageSelected"]);
  bkU.setProperty("ownerId", currentUserObjectId);
  bkU.setProperty("accountType", hold["accountType"]);
  bkU.setProperty("socialAccount", hold["socialAccount"]);
  bkU.setProperty("___class", hold["___class"]);
  bkU.setProperty("oAuthIdentities", hold["oAuthIdentities"]);
  bkU.setProperty("blUserLocale",hold["blUserLocale"]);
  bkU.setProperty("AddressList",hold["AddressList"]);
  bkU.setProperty("updated",hold["updated"]);
  bkU.setProperty("objectId",hold["objectId"]);
  bkU.setProperty("Location",hold["Location"]);*/
  }

  getUserDataFromServer() async {
    ///Get backendless logged in user ID
    String currentUserObjectId = await Backendless.userService.loggedInUser();

    ///Find backendless user as that class by ID
    BackendlessUser user = await Backendless.data
        .withClass<BackendlessUser>()
        .findById(currentUserObjectId);

    ///Apply the data to local Application
    applyUserDetailLocal(user, false, "");
  }

  userServerLoginCheck() async {
    await Backendless.userService.isValidLogin().then((response) {
      try {
        if (response) {
          print("User has logged in previously");
          //String currentUserObjectId = await Backendless.userService.loggedInUser();
          StorageUtil.putBool('isLoggedIn', true);
        } else {
          StorageUtil.putBool('isLoggedIn', false);
          User().isLoggedIn = false;
          print("User has NOT logged in previously");
        }
      } catch (e) {
        if (StorageUtil.getBool('isLoggedIn')) {
          print("User has logged in as per local records");
        }
      }
    });
  }

  setUserDataLocal(BackendlessUser hold) {
    //print(hold);
    List<String> keys = [];
    List<String> values = [];
    ///Change BackendlessUser data to a map
    var r = hold.toJson().values.first;
    ///Convert the map into lists of key and values
    r.forEach((k,v) => keys.add(k));
    r.forEach((k,v) => values.add(v.toString()));
    ///Store the list into the local storage
    StorageUtil.putString("userStoredKeys", json.encode(keys));
    StorageUtil.putString("userStoredValues", json.encode(values));
    StorageUtil.putBool("isLoggedIn", true);

  }

  getUserDataLocal(){
    ///Converts user information from storage to lists
    List<String> keys = convertToList("userStoredKeys");
    List<dynamic> values =convertToList("userStoredValues");
    ///Change BackendlessUser data to a map
    Map<String, dynamic> mapKV = new Map.fromIterables(keys, values);
    //print(mapKV);
    ///Converts map to BackendlessUser Properties
    Map<String, dynamic> userKV = {"properties": mapKV};
    //print(userKV);
    ///Converts BkU JSON properties to backendlessUser object
    BackendlessUser user = BackendlessUser.fromJson(userKV);
    //print("\n $user");
    ///Apply this information to local Application
    applyUserDetailLocal(user, false,"");
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
}
