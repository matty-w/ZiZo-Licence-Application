import 'dart:html';
import 'loginfunctions.dart';

void main()
{
  var log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
}
