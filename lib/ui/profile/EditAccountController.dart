import 'package:zomatoui/Model/User.dart';

class EditAccountDetails {
  String _userID;
  String _userFirstName;
  String _userLastName;
  String _userPhoneNo;
  String _userEmailAddress;

  set userEmailAddress(String userEmailAddress) {
    _userEmailAddress = userEmailAddress;
  }

  set userPhoneNo(String userPhoneNo) {
    _userPhoneNo = userPhoneNo;
  }

  set userFirstName(String userFirstName) {
    _userFirstName = userFirstName;
  }

  set userLastName(String userLastName) {
    _userLastName = userLastName;
  }

  set userID(String userID) {
    _userID = userID;
  }

  setChangeUserDetails() async {
    bool userConfirmedPhone = false;
    bool isUserChangedPhone = false;
    if (User().phone != _userPhoneNo) {
      isUserChangedPhone = true;
      userConfirmedPhone = await setPhoneNoConfirmation();
    }
    if (_userEmailAddress != User().email ||
        _userFirstName != User().fname ||
        _userLastName != User().lastName) {
      if (isUserChangedPhone && userConfirmedPhone) {
        //set user details in database
      } else if (isUserChangedPhone && !userConfirmedPhone) {
        //return error message and tell user to confirm
      } else if (!isUserChangedPhone) {
        // set user details in database with only the changed information
      }
    }
  }

  setPhoneNoConfirmation() async {
    return await User().userPhoneConfirmation(_userPhoneNo);
  }
}
