import 'package:zomatoui/Model/User.dart';

class EditAccountDetails {
  String _userID = User().id;
  String _userFirstName;
  String _userLastName;
  String _userPhoneNo;
  String _userEmailAddress;
  List<String> keys = ["phone", "email", "First_Name", "Last_Name"];
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

  setChangeUserDetails(
      String email, String fname, String Lname, String phoneNum) async {
    String messageResponse = "Invalid Login";
    userEmailAddress = email;
    userFirstName = fname;
    userLastName = Lname;
    userPhoneNo = phoneNum;
    bool userConfirmedPhone = false;
    bool isUserChangedPhone = false;
    bool isValidLogin = await User().loginStatus();
    bool isAnyChange = false;
    List<String> _values = [
      User().phone,
      User().email,
      User().fname,
      User().lastName
    ];
    //check for valid user login status
    if (isValidLogin) {
      if (User().phone != _userPhoneNo) {
        isAnyChange = true;
        isUserChangedPhone = true;
        userConfirmedPhone = await setPhoneNoConfirmation();
        print(
            "Delivery App message: $userConfirmedPhone : User has verified the phone number ${User().phone} to $_userPhoneNo ");
        //change phone number in db and local storage if user phone number is verified within the time limit or until it is verified at all
        if (isUserChangedPhone && userConfirmedPhone) {
          //set user details in database
          _values = [_userPhoneNo, User().email, User().fname, User().lastName];
          print(
              "Delivery App message: Changing user details with phone number");
        } else if (isUserChangedPhone && !userConfirmedPhone) {
          //return error message and tell user to confirm
          messageResponse = "Unconfirmed Phone";
          print(
              "Delivery App message: User has not confirmed their phone number");
        }
      }
      if (_userEmailAddress != User().email ||
          _userFirstName != User().fname ||
          _userLastName != User().lastName) {
        isAnyChange = true;
        if (!isUserChangedPhone) {
          // set user details in database with only the changed information
          _values = [
            User().phone,
            _userEmailAddress,
            _userFirstName,
            _userLastName
          ];
          //set user details in database

          print(
              "Delivery App message: Changing user details without phone number");
        } else if (isUserChangedPhone && userConfirmedPhone) {
          _values = [
            _userPhoneNo,
            _userEmailAddress,
            _userFirstName,
            _userLastName
          ];
          print("Delivery App message: Successfully changed Phone Number");
        }
      }

      ///Save updated information to backend server if there is any change
      if(isAnyChange){
        bool updateResponse = await User().updateKeyProperty(keys, _values);

        ///If successfully changed, change response message
        if (updateResponse) {
          messageResponse = "Successfully Saved";
        } else {
          messageResponse = "Error Saving";
        }
      } else {
        messageResponse = "No Changes Made.";
      }

    } else {
      return messageResponse;
    }
    return messageResponse;
  }

  setPhoneNoConfirmation() async {
    return await User().userPhoneConfirmation(_userPhoneNo);
  }
}
