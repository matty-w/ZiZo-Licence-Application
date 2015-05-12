import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';
import 'viewablepages.dart';
import 'popup.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  LoginAndOut log = new LoginAndOut();
  HelpScreenFunctions help = new HelpScreenFunctions();
  
  querySelector("#dismissSuccess").onClick.listen(dismissPrompt);
  querySelector("#dismissFail").onClick.listen(dismissPrompt);
    
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
  
  LicenceServerRequest.addPermission(user, permission, window.sessionStorage['username'],window.sessionStorage['password'], 
      "localhost", (s) => getResult(popup("#popUpDiv"), s),(s) => getResult(popupFail("#popUpDiv"), s));
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

popup(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissFail");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissSuccess");
  button2.hidden = false;
  querySelector("#popupTitle").innerHtml = "Permission Added";
  OutputElement text = querySelector("#popupText");
  text.value = "The Permission Was Successfully Added: ";
  querySelector("#tick").setAttribute("src", "images/ticksmall.png");
  
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

popupFail(String popupId)
{
  PopupWindow p = new PopupWindow();
  ButtonElement button = querySelector("#dismissSuccess");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismissFail");
  button2.hidden = false;
  
  
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "An Error Occurred: ";
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

void getResult(Function popup, String s)
{
  OutputElement admin = querySelector("#serverResponse");
  admin.value = s;
  popup;
}

void dismissPrompt(MouseEvent e)
{
  popup("#popUpDiv");
  main();
}

