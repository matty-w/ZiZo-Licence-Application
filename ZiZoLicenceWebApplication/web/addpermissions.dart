import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';
import 'popupconstruct.dart';
import 'popup.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();
  PopupWindow p = new PopupWindow();
  HelpScreenFunctions help = new HelpScreenFunctions();
  
  querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
  querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
    
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#helpButton").onClick.listen(help.showAddPermissionsScreen);
  querySelector("#addPermissions_button").onClick.listen(addPermission);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    
  setDescriptionText();
  ViewablePages.revealOptions();
}

void addPermission(MouseEvent m)
{
  SelectPopup sp = new SelectPopup();
  PopupWindow p = new PopupWindow();
  InputElement usernameInput = querySelector("#username");
  SelectElement permissionChoice = querySelector("#setPermissions");
  String permission;
  String user = usernameInput.value;
  permission = permissionChoice.value;
  
  LicenceServerRequest.addPermission(user, permission, window.sessionStorage['username'],window.sessionStorage['password'], 
      "localhost", (s) => p.getResult(sp.popup("add-permissions","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
}

void setDescriptionText()
{
  SpanElement output = querySelector("#permissionDescription");
  output.innerHtml = "User Can Return A String Showing An Entries From Other Administrators. Includes A List Of Their Permissions.";
  querySelector("#setPermissions").onChange.listen(setText);
}

void setText(Event e)
{
  SelectElement dropDown = querySelector("#setPermissions");
  int index = dropDown.selectedIndex;
  OptionElement oe = dropDown.options[index];
  SpanElement output = querySelector("#permissionDescription");
  output.innerHtml = oe.attributes['doc'];
}
