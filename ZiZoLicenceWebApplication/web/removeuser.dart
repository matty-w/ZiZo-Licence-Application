import 'loginfunctions.dart';
import 'dart:html';
import 'dart:js';

void main()
{
  var log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#removeUser_button").onClick.listen(removeUser);
}

void removeUser(MouseEvent m)
{
  printResponse();
}

void printResponse()
{
  InputElement i = querySelector("#username");
  context.callMethod('alert',["The User "+"'"+i.value+"'"+" Has Been Deleted."]);
}


