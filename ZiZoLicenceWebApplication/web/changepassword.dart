import 'dart:html';
import 'loginfunctions.dart';
import 'popupconstruct.dart';
import 'licenceserverrequest.dart';
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
  querySelector("#logoutButton").onClick.listen(log.logout);
  InputElement username = querySelector("#username");
  username.disabled = true;
  username.value = window.sessionStorage['username'];
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#addUser_submitButton").onClick.listen(changePassword);
  querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
}

void changePassword(MouseEvent m)
{
  SelectPopup sp = new SelectPopup();
  PopupWindow p = new PopupWindow();
  InputElement username = querySelector("#username");
  username.value = window.sessionStorage['username'];
  InputElement password = querySelector("#password");
  InputElement confirmPassword = querySelector("#confirmPassword");
  String pass = password.value;
  String cp = confirmPassword.value;
  
  if(pass == null || pass.trim() == "" || cp == null || cp.trim() == "")
  {
    sp.popupOther("no-password","#popUpDiv");
    return;
  }
  
  if(pass != cp)
  {
    sp.popupOther("passwords-dont-match","#popUpDiv");
    return;
  }
  else
  {
    LicenceServerRequest.changeAdminPassword(username.value, cp, window.sessionStorage['username'],window.sessionStorage['password'],
        "localhost", (s) => p.getResult(sp.popup("change-password","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
    window.sessionStorage['password'] = pass;
  }  
}
