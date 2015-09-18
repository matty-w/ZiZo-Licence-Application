library selectPopup;

import 'dart:html';
import 'popupconstruct.dart';

class SelectPopup
{
  popupLicence(String option, String popupId)
  {
    PopupWindow p = new PopupWindow();
    p.setText(option);
    p.setErrorPicture(false);
    p.buttons(true, true, false, false);
    p.popup(popupId);
  }
  
  popup(String option, String popupId)
  {
    PopupWindow p = new PopupWindow();
    p.setText(option);
    p.setErrorPicture(false);
    p.buttons(true, false, true, true);
    p.popup(popupId);
  }
  
  popupFail(String popupId)
  {
    PopupWindow p = new PopupWindow();
    p.setFailText("Error", "An Error Occurred: ");
    p.setErrorPicture(true);
    p.buttons(true, true, false, true);
    p.popup(popupId);
  }
  
  popupOther(String option, String popupId)
  {
    PopupWindow p = new PopupWindow();
    p.setText(option);
    p.setErrorPicture(true);
    p.buttons(true, true, false, true);
    p.popup(popupId);
  }
  
  popupInvalidDate(String popupId, String reason)
  {
    PopupWindow p = new PopupWindow();
    p.setErrorPicture(true);
    querySelector("#popupTitle").innerHtml = "Error";
    OutputElement text = querySelector("#popupText");
    text.innerHtml = reason;
    OutputElement licenceText = querySelector("#serverResponse");
    licenceText.innerHtml = "";
    p.buttons(true, true, false, true);
    p.popup(popupId);
  }
  
  popupLicenceFormat(String popupId)
  {
    PopupWindow p = new PopupWindow();
    querySelector("#tick").setAttribute("src", "images/questionMark.png");
    querySelector("#popupTitle").innerHtml = "Username Format";
    OutputElement text = querySelector("#popupText");
    text.innerHtml = "The Username Is Not In The Recommended Email Format, Continue?";
    OutputElement licenceText = querySelector("#serverResponse");
    licenceText.innerHtml = "";
    p.buttons(false, false, true, true);
    p.popup(popupId);
  }
  
  popupLicenceList(List licenceNames, String popupId)
  {
    PopupWindow p = new PopupWindow();
    p.setText("confrim-licence-deletion");
    p.setList(licenceNames);
    p.setErrorPicture(true);
    p.buttons(false, false, true, true);
    p.popup(popupId);
  }
}