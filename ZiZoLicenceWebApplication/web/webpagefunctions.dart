library webPageFunctions;

import 'dart:html';
import 'loginfunctions.dart';
import 'popup.dart';
import 'popupconstruct.dart';
import 'createlicence.dart';
import 'dart:js';
import 'licenceserverrequest.dart';

String isoDate;
String licenceLength;
String licenceLengthError;

class GlobalFunctions
{
  void setLogOut()
  {
    LoginAndOut log = new LoginAndOut();
    querySelector("#logoutButton").onClick.listen(log.logout);
  }
  
  void setDefaultIpAddress()
  {
    InputElement ipAddress = querySelector("#url");
    ipAddress.value = window.location.host;
  }
  
  void saveToClipboard(MouseEvent e)
  {
    PopupWindow p = new PopupWindow();
    clipboardPrompt(p.getLicenceName());
    window.location.reload();
  }
  
  void clipboardPrompt(String licence)
  {
    SelectPopup sp = new SelectPopup();
    var result = context.callMethod('prompt', ["Copy to clipboard: Ctrl+C, Enter", licence]);
    print(result);
    sp.popupLicence("add-licence","#popUpDiv");
    main();
  }
}

class CreateLicenceFunctions
{ 
  void disableDateLengthTextBox()
  {
    InputElement specifiedLengthTextbox = querySelector("#specifiedLength");
    specifiedLengthTextbox.disabled = true;
  }
  
  void createDefaultDate()
  {
    DateInputElement date = querySelector("#specifiedLength"); 
    date.value = today(3);
  }
  
  void listenToRadioButtons()
  {
    querySelector("#thirtyDays").onChange.listen(createThirtyDayLicence);
    querySelector("#neverExpires").onChange.listen(createUnlimitedLicence);
    querySelector("#specified").onChange.listen(createUserSpecifiedLicence);
  }
  
  void setRadioButtons()
  {
    (querySelector("#thirtyDays") as RadioButtonInputElement).checked = false;
    (querySelector("#neverExpires") as RadioButtonInputElement).checked = false;
    (querySelector("#specified") as RadioButtonInputElement).checked = false;
  }
  
  void createThirtyDayLicence(Event e)
  { 
    disableTextbox(e);
    createDefaultDate();
    thirtyDayDate();
  }
  
  void createUnlimitedLicence(Event e)
  {
    disableTextbox(e);
    createDefaultDate();
    OutputElement unlimited = querySelector("#expiryDate");
    unlimited.innerHtml = "";
  }
  
  void createUserSpecifiedLicence(Event e)
  {
    enableTextbox(e);
    DateInputElement i = querySelector("#specifiedLength");
    OutputElement specified = querySelector("#expiryDate");
    specified.innerHtml = "";
    licenceLength = i.value;
  }
  
  void enableTextbox(Event e)
  {
    InputElement specifiedLengthTextbox = querySelector("#specifiedLength");
    specifiedLengthTextbox.disabled = false;
  }
  
  void disableTextbox(Event e)
  {
    InputElement specifiedLengthTextbox = querySelector("#specifiedLength");
    specifiedLengthTextbox.disabled = true;
  }
  
  void thirtyDayDate()
  {
    DateTime baseDate = new DateTime.now();
    DateTime licenceDate = baseDate.add(new Duration(days: 30));
    String date = licenceDate.toString();
    isoDate = date.substring(0,10);
    String printedDate = isoDate.split("-").reversed.join("-");
    OutputElement thirtyDays = querySelector("#expiryDate");
    thirtyDays.innerHtml = "The Licence Will Expire On: "+printedDate;
    licenceLength = thirtyDays.value;
  }
  
  String today(int days)
  {
    DateTime baseDate = new DateTime.now();
    DateTime minDate = baseDate.add(new Duration(days: days));
    String baseDateString = minDate.toString();
    String finalDate = baseDateString.substring(0,10);
    return finalDate;
  }
  
  void submitForm(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    PopupWindow p = new PopupWindow();
    InputElement un = querySelector("#username");
    InputElement fe = querySelector("#filter");
    InputElement url = querySelector("#url");
    RadioButtonInputElement specifiedChoice = querySelector("#specified");
    RadioButtonInputElement thirtyDay = querySelector("#thirtyDays");
    RadioButtonInputElement unlimited = querySelector("#neverExpires");
    String userValue; 


    if(!(specifiedChoice.checked) && !(thirtyDay.checked) && !(unlimited.checked))
    {
      sp.popupOther("no-option-selected","#popUpDiv");
      return;
    }
    
    if(un.value == null || un.value.trim() == "")
    {
      sp.popupOther("no-username","#popUpDiv");
      return;
    }
    
    if(specifiedChoice.checked)
      if(checkDateValue() == false)
      {  
        sp.popupInvalidDate("#popUpDiv", licenceLengthError);
        return;
      }    
    
    if(checkUsername() == true)
    {
      sp.popupLicenceFormat("#popUpDiv");
      return;
    } 
    else
    {
      String shortDate = licenceLengthValue();
        
      if (un.value.length==0)
        return;
      if (!hasButtonSet())
        return;
        
      userValue = un.value;
      if (url.value.length>0)
        userValue = userValue+"("+url.value+")";
        
      LicenceServerRequest.addLicence(
          userValue,shortDate,fe.value,
          window.sessionStorage['username'],window.sessionStorage['password'],
          LicenceServerRequest.defaultUri(),(s) => p.getResult(sp.popupLicence("add-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
        
      un.value = "";
      fe.value = "";
      }
  }
  
  void completeLicence(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    PopupWindow p = new PopupWindow();
    sp.popupLicence("add-licence","#popUpDiv");
    InputElement un = querySelector("#username");
    InputElement fe = querySelector("#filter");
    InputElement url = querySelector("#url");
    String userValue;
    
    String shortDate = licenceLengthValue();
          
    if (un.value.length==0)
      return;
    if (!hasButtonSet())
      return;
          
    userValue = un.value;
    if (url.value.length>0)
      userValue = userValue+"("+url.value+")";
          
    LicenceServerRequest.addLicence(
        userValue,shortDate,fe.value,
        window.sessionStorage['username'],window.sessionStorage['password'],
        LicenceServerRequest.defaultUri(),(s) => p.getResult(sp.popupLicence("add-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
          
    un.value = "";
    fe.value = "";
  }
  
  String chosenDate()
  {
    DateInputElement date = querySelector("#specifiedLength");
    String baseChoice = date.value;
    String dateChoice = baseChoice.split("-").reversed.join("-");
    return dateChoice;
  }
  
  String licenceLengthValue()
  {
    if((querySelector("#thirtyDays") as RadioButtonInputElement).checked)
      return isoDate;
    else if((querySelector("#specified") as RadioButtonInputElement).checked)
      return chosenDate();
    else
      return "";
  }
  
  bool checkDateValue()
  {
    DateInputElement dateInput = querySelector("#specifiedLength");
    DateTime shortDate = DateTime.parse(dateInput.value);
    DateTime now = new DateTime.now();
    int day = now.day+2;
    DateTime nowWithoutTime = new DateTime(now.year,now.month,now.day,1,0,0,0);
    DateTime nowPlusThree = new DateTime(now.year,now.month,day,1,0,0,0);
    
    if(shortDate == nowWithoutTime)
    {  
      licenceLengthError = "Invalid Date : Licence Cannot Expire On Current Day";
      return false;
    }  
    else if(shortDate == null)
    {  
      licenceLengthError = "Please Enter A Date";
      return false;
    }  
    else if(!(shortDate.isAfter(nowWithoutTime)))
    {  
      licenceLengthError = "Invalid Date: Licence Cannot Be Set Before Current Day";
      return false;
    }  
    else if(!(shortDate.isAfter(nowPlusThree)))
    {  
      licenceLengthError = "Invalid Date: Licence Must Have Minimum Length Of Three Days";
      return false;
    }  
    else
    return true;
  }
  
  bool hasButtonSet()
  {
    return (querySelector("#thirtyDays") as RadioButtonInputElement).checked ||
    (querySelector("#neverExpires") as RadioButtonInputElement).checked ||
    (querySelector("#specified") as RadioButtonInputElement).checked;
  }
  
  bool checkUsername()
  {
    InputElement input = querySelector("#username");
    String username = input.value;
      
    RegExp exp = new RegExp("[a-zA-Z0-9][a-zA-Z0-9-_\s]+@[a-zA-Z0-9-\s].+\.[a-zA-Z]{2,5}");
         
    if(!(exp.hasMatch(username)))
    {  
      return true;  
    }
    else  
      return false;
  }
}

class AddAdminFucntions
{
  void addAdmin(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    InputElement userNameInput = querySelector("#username");
    InputElement passwordInput = querySelector("#password");
    InputElement confirmPassword = querySelector("#confirmPassword");
    String passwordFirst = passwordInput.value;
    String passwordSecond = confirmPassword.value;
    
    if(userNameInput.value == null || userNameInput.value.trim() == "")
    {
      sp.popupOther("no-username","#popUpDiv");
      return;
    }
    
    if(passwordFirst == null || passwordFirst.trim() == "" || passwordSecond == null || passwordSecond.trim() == "")
    {  
      sp.popupOther("no-password","#popUpDiv");
      return;
    }  
    
    if(checkPasswordsMatch(passwordFirst, passwordSecond) == true)
    { 
      PopupWindow p = new PopupWindow();
      String user = userNameInput.value;
      String password = passwordInput.value;
       
      LicenceServerRequest.addAdminUser(user, password, window.sessionStorage['username'],window.sessionStorage['password'],
          LicenceServerRequest.defaultUri(), (s) => p.getResult(sp.popup("add-admin","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
      
      userNameInput.value = "";
      passwordInput.value = "";
      confirmPassword.value = "";
      return;
    }  
      
    sp.popupOther("passwords-dont-match","#popUpDiv");

  }

  bool checkPasswordsMatch(String password, String confirmPassword)
  {  
    if(confirmPassword != password)
      return false;
    else
      return true;
  }
}

class AddPermissionsFunctions
{
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
        LicenceServerRequest.defaultUri(), (s) => p.getResult(sp.popup("add-permissions","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
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
}

class RegenerateLicenceFunctions
{
  void regenerateLicence(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    PopupWindow p = new PopupWindow();
    InputElement usernameInput = querySelector("#username");
    InputElement url = querySelector("#url");
    
    String userValue;
    
    if(usernameInput.value == null || usernameInput.value.trim() == "")
    {
      sp.popupOther("no-licence-name","#popUpDiv");
      return;
    }  
    
    userValue = usernameInput.value;
      if (url.value.length>0)
        userValue = userValue+"("+url.value+")";
      
    LicenceServerRequest.regenerateLicence(userValue, window.sessionStorage['username'],window.sessionStorage['password'], 
        LicenceServerRequest.defaultUri(), (s) => p.getResult(sp.popupLicence("regenerate-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));  
  }
}

class RemoveAdminFunctions
{
  void removeUser(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    PopupWindow p = new PopupWindow();
    InputElement username = querySelector("#username");
    String userValue;
    
    userValue = username.value;
    
    if(userValue == null || userValue.trim() == "")
    {
      sp.popupOther("no-username", "#popUpDiv");
      return;
    }
    
    LicenceServerRequest.removeUser(userValue, window.sessionStorage['username'],window.sessionStorage['password'], LicenceServerRequest.defaultUri(),
        (s) => p.getResult(sp.popup("remove-admin","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
    
    username.value = "";
  }

}

class RemoveLicenceFunctions
{
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
    
    LicenceServerRequest.removeAdmin(licenceValue, window.sessionStorage['username'],window.sessionStorage['password'], LicenceServerRequest.defaultUri(),
        (s) => p.getResult(sp.popup("remove-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
  }
}

class ChangePassword
{
  void changePassword(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    PopupWindow p = new PopupWindow();
    InputElement username = querySelector("#username");
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
          LicenceServerRequest.defaultUri(), (s) => p.getResult(sp.popup("change-password","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
      window.sessionStorage['password'] = pass;
    }  
    
    pass = "";
    cp = "";
  }
}