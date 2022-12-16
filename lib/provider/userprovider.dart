import 'package:flutter/cupertino.dart';
import 'package:pistagram/models/user.dart';
import 'package:pistagram/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User get getuser => _user!;
  Future<void> refreshuser() async {
    User user = await AuthMethods().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
