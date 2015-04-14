import 'loginfunctions.dart';
import 'dart:html';

void main()
{
  var log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#confirmPassword").onChange.listen(checkPasswords);
}

tickAlloptions(MouseEvent m)
{
  InputElement selectAll = querySelector("#selectAll") as CheckboxInputElement;
  InputElement canRemoveUser = querySelector("#canRemoveUser") as CheckboxInputElement;
  InputElement canAddUser = querySelector("#canAddUser") as CheckboxInputElement;
  InputElement canAddPermissions = querySelector("#canAddPermissions") as CheckboxInputElement;
  InputElement canViewLogs = querySelector("#canViewLogs") as CheckboxInputElement;
  
  if(selectAll.checked)
  {
    canRemoveUser.checked = true;
    canAddUser.checked = true;
    canAddPermissions.checked = true;
    canViewLogs.checked = true;
    canRemoveUser.disabled = true;
    canAddUser.disabled = true;
    canAddPermissions.disabled = true;
    canViewLogs.disabled = true;
  }
  else
  {
    canRemoveUser.checked = false;
    canAddUser.checked = false;
    canAddPermissions.checked = false;
    canViewLogs.checked = false;
    canRemoveUser.disabled = false;
    canAddUser.disabled = false;
    canAddPermissions.disabled = false;
    canViewLogs.disabled = false;
  }
}

checkPasswords(Event e)
{
  InputElement password1 = querySelector("#password");
  InputElement password2 = querySelector("#confirmPassword");
  
  if(password2.value != password1.value)
    password2.setCustomValidity("Passwords Must Be Matching.");
  else
    password2.setCustomValidity("");
}

