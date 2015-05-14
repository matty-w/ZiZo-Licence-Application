import 'dart:html';
import 'loginfunctions.dart';
import 'helpscreenfunctions.dart';
import 'viewablepages.dart';
import 'licenceserverrequest.dart';
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
  querySelector("#removeLicence_button").onClick.listen(removeLicence);
    
  querySelector("#helpButton").onClick.listen(help.showRemoveLicenceScreen);
  querySelector("#logoutButton").onClick.listen(log.logout);
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    
  ViewablePages.revealOptions();
}

void removeLicence(MouseEvent m)
{
  SelectPopup sp = new SelectPopup();
  PopupWindow p = new PopupWindow();
  InputElement licence = querySelector("#licence");
  String licenceValue;
  licenceValue = licence.value;
  
  if(licenceValue == null || licenceValue.trim() == "")
  {
    sp.popupOther("no-licence-name","#popUpDiv");
    return;
  }
  
  LicenceServerRequest.removeAdmin(licenceValue, window.sessionStorage['username'],window.sessionStorage['password'], "localhost",
      (s) => p.getResult(sp.popup("remove-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
}
