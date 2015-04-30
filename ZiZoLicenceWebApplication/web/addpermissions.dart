import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';

void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#helpButton").onClick.listen(help.showAddPermissionsScreen);
  querySelector("#addPermissions_button").onClick.listen(addPermission);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  
  setDescriptionText();
  ViewablePages.revealOptions();
}

void addPermission(MouseEvent m)
{
  InputElement usernameInput = querySelector("#username");
  SelectElement permissionChoice = querySelector("#setPermissions");
  
  String permission;
  String user = usernameInput.value;
  
  permission = permissionChoice.value;
  
  LicenceServerRequest.addPermission(user, permission, window.sessionStorage['username'],window.sessionStorage['password'], "localhost",
       (s) => window.alert(s),(s) => window.alert("fail: "+s));
}

setDescriptionText()
{
  OutputElement output = querySelector("#permissionDescription");
  output.innerHtml = "User Can Return A String Showing An Entries From Other Administrators. Includes A List Of Their Permissions.";
  querySelector("#setPermissions").onChange.listen(setText);
}

setText(Event e)
{
  SelectElement dropDown = querySelector("#setPermissions");
  OutputElement output = querySelector("#permissionDescription");
  output.innerHtml = dropDown.attributes['doc'];
}

