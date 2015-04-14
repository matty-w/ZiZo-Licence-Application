import 'loginfunctions.dart';
import 'dart:html';

void main()
{
  var log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
}


