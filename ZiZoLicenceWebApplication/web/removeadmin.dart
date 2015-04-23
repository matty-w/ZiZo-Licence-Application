import 'loginfunctions.dart';
import 'dart:html';
import 'dart:js';
import 'helpscreenfunctions.dart';

void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  querySelector("#helpButton").onClick.listen(help.showRemoveUsersScreen);
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


