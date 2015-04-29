import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';


void main()
{
  var log = new LoginAndOut();
  var help = new HelpScreenFunctions();
  
  
  
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#helpButton").onClick.listen(help.showAddPermissionsScreen);
  querySelector("#addPermissions_button").onClick.listen(addPermission);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  
  setDescriptionText();
}

void addPermission(MouseEvent m)
{
  InputElement usernameInput = querySelector("#username");
  SelectElement permissionChoice = querySelector("#setPermissions");
  
  String permission;
  String user = usernameInput.value;
  
  if(permissionChoice.value == "userEntries")
    permission = "user-entries";
  else if(permissionChoice.value == "changePassword")
    permission = "change-password";
  else if(permissionChoice.value == "addPermissions")
    permission = "add-permission";
  else if(permissionChoice.value == "deleteUser")
    permission = "delete-user";
  else if(permissionChoice.value == "removePermissions")
    permission = "remove-permission";
  else if(permissionChoice.value == "listCommands")
    permission = "list-commands";
  else if(permissionChoice.value == "addUser")
    permission = "add-user";
  else
    return;
  
  LicenceServerRequest.addPermission(user, permission, window.sessionStorage['username'],window.sessionStorage['password'], "localhost",
       (s) => window.alert(s),(s) => window.alert("fail: "+s));
}

setDescriptionText()
{
  OutputElement output = querySelector("#permissionDescription");
  output.value = "User Can Return A String Showing An Entries From Other Administrators. Includes A List Of Their Permissions.";
  querySelector("#setPermissions").onChange.listen(setText);
}

setText(Event e)
{
  SelectElement dropDown = querySelector("#setPermissions");
  OutputElement output = querySelector("#permissionDescription");
  
  
  if(dropDown.value == "userEntries")
    output.value = "User Can Return A String Showing An Entries From Other Administrators. Includes A List Of Their Permissions.";
  else if(dropDown.value == "changePassword")
    output.value = "Can Change Password For A User. (Note: A User Can Alter Their Own Password Without This Permission).";
  else if(dropDown.value == "addPermissions")
    output.value = "Can Add Indicated Operation To The List Of Things The Administrator Can Do.";
  else if(dropDown.value == "deleteUser")
    output.value = "User Can Delete This User From The List Of Administrators.";
  else if(dropDown.value == "removePermissions")
    output.value = "Can Remove Indicated Operation To The List Of Things The Administrator Can Do.";
  else if(dropDown.value == "listCommands")
    output.value = "Returns A Quick List Of Available Commands.";
  else if(dropDown.value == "addUser")
    output.value = "User Can Add A New Administrator To The Service. This Administrator Has No Permissions.";
}

