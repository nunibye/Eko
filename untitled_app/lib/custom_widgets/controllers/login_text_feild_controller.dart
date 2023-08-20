import 'package:flutter/widgets.dart';

class LoginFieldController extends ChangeNotifier {
  final bool password;
  bool hidden;

  LoginFieldController({this.password = false, this.hidden = false}) {
    hidden = password;
  }

  bottonPressed() {
    hidden = !hidden;
    notifyListeners();
  }
}
