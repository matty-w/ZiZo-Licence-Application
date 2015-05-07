import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();
  HelpScreenFunctions help = new HelpScreenFunctions();
    
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
  SpanElement output = querySelector("#permissionDescription");
  output.innerHtml = "User Can Return A String Showing An Entries From Other Administrators. Includes A List Of Their Permissions.";
  querySelector("#setPermissions").onChange.listen(setText);
}

setText(Event e)
{
  SelectElement dropDown = querySelector("#setPermissions");
  int index = dropDown.selectedIndex;
  OptionElement oe = dropDown.options[index];
  SpanElement output = querySelector("#permissionDescription");
  output.innerHtml = oe.attributes['doc'];
}

