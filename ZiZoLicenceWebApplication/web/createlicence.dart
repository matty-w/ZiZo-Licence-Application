import 'loginfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';
import 'helpscreenfunctions.dart';
import 'viewablepages.dart';
import 'dart:js';
import 'popup.dart';

String licenceLength;
String defaultDate = today(3);
String licenceName;
String isoDate;
bool continueWithLicence;
String licenceLengthError;

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  HelpScreenFunctions help = new HelpScreenFunctions();
    
  querySelector("#helpButton").onClick.listen(help.showCreateLicenceScreen);
  
  querySelector("#dismiss").onClick.listen(dismissPrompt);
  querySelector("#clipboard").onClick.listen(saveToClipboard);
  
  querySelector("#no").onClick.listen(dismissPrompt);
  querySelector("#yes").onClick.listen(completeLicence);
    
  setlogOut();
  disableDateLengthTextBox();
  createDefaultDate();
  setDefaultIpAddress();
  setRadioButtons();
  listenToRadioButtons();
  querySelector("#username-output").innerHtml = window.sessionStorage['username'];
  querySelector("#default_submitButton").onClick.listen(submitForm);
  querySelector("#specifiedLength").onClick.listen(checkDateValue);
  querySelector("#filter").onChange.listen(checkFilter);
  ViewablePages.revealOptions();
}

void setlogOut()
{
  LoginAndOut log = new LoginAndOut();
  querySelector("#logoutButton").onClick.listen(log.logout);
}

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

void setDefaultIpAddress()
{
  InputElement ipAddress = querySelector("#url");
  ipAddress.value = window.location.host;
}

void listenToRadioButtons()
{
  querySelector("#thirtyDays").onChange.listen(createThirtyDayLicence);
  querySelector("#neverExpires").onChange.listen(createUnlimitedLicence);
  querySelector("#specified").onChange.listen(createUserSpecifiedLicence);
}

void createThirtyDayLicence(Event e)
{ 
  createDefaultDate();
  thirtyDayDate();
  disableTextbox(e);
}

void createUnlimitedLicence(Event e)
{
  createDefaultDate();
  OutputElement unlimited = querySelector("#expiryDate");
  unlimited.innerHtml = "";
  disableTextbox(e);
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

void submitForm(MouseEvent m)
{
  InputElement un = querySelector("#username");
  InputElement fe = querySelector("#filter");
  InputElement url = querySelector("#url");
  RadioButtonInputElement specifiedChoice = querySelector("#specified");
  RadioButtonInputElement thirtyDay = querySelector("#thirtyDays");
  RadioButtonInputElement unlimited = querySelector("#neverExpires");
  String userValue; 
  Event e;
  
  if(!(specifiedChoice.checked) && !(thirtyDay.checked) && !(unlimited.checked))
  {
    popupNoOptionSelected("#popUpDiv");
    return;
  }
  
  if(specifiedChoice.checked)
    if(checkDateValue(e) == false)
    {  
      popupInvalidDate("#popUpDiv", licenceLengthError);
      return;
    }  
  
  if(un.value == null || un.value.trim() == "")
  {
    popupNoUserName("#popUpDiv");
    return;
  }  
  
  if(checkUsername(e) == true)
  {
    popupLicenceFormat("#popUpDiv");
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
        "localhost",(s) => getResult(popup("#popUpDiv"), s),(s) => getResult(popupFail("#popUpDiv"), s));
      
    un.value = "";
    fe.value = "";
    }
}

void checkFilter(Event e)
{
  InputElement filter = querySelector("#filter");
  
  if(filter != "" || filter != "someFilter")
  
    filter.setCustomValidity("The Filter Does Not Exist, Please Enter A Valid Filter Option.");
  else
    filter.setCustomValidity("");
}

void processForm()
{
  
}

String licenceLengthChoice()
{
  if((querySelector("#thirtyDays") as RadioButtonInputElement).checked)
    return "The Licence Lasts For Thirty Days, Ending On: "+licenceLength+".";
  else if((querySelector("#neverExpires") as RadioButtonInputElement).checked)
    return "The Licence Has An Unlimited Length, The Licence Does Not Have An Expiration Date.";
  else if((querySelector("#specified") as RadioButtonInputElement).checked)
    return "The Licence Length Has A User Specified Length, Ending On: "+chosenDate()+".";
  else
    return "";
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

String today(int days)
{
  DateTime baseDate = new DateTime.now();
  DateTime minDate = baseDate.add(new Duration(days: days));
  String baseDateString = minDate.toString();
  String finalDate = baseDateString.substring(0,10);
  return finalDate;
}

String chosenDate()
{
  DateInputElement date = querySelector("#specifiedLength");
  String baseChoice = date.value;
  String dateChoice = baseChoice.split("-").reversed.join("-");
  return dateChoice;
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

void setRadioButtons()
{
  (querySelector("#thirtyDays") as RadioButtonInputElement).checked = false;
  (querySelector("#neverExpires") as RadioButtonInputElement).checked = false;
  (querySelector("#specified") as RadioButtonInputElement).checked = false;
}

bool hasButtonSet()
{
  return (querySelector("#thirtyDays") as RadioButtonInputElement).checked ||
  (querySelector("#neverExpires") as RadioButtonInputElement).checked ||
  (querySelector("#specified") as RadioButtonInputElement).checked;
}

bool checkDateValue(Event e)
{
  DateInputElement dateInput = querySelector("#specifiedLength");
  DateTime shortDate = dateInput.valueAsDate;
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

bool checkUsername(Event e)
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

popup(String popupId)
{
  PopupWindow p = new PopupWindow();
  
  querySelector("#tick").setAttribute("src", "images/ticksmall.png");
  querySelector("#popupTitle").innerHtml = "Licence Created";
  OutputElement text = querySelector("#popupText");
  text.value = "The Licence Is: ";
  
  ButtonElement button = querySelector("#clipboard");
  button.hidden = false;
  ButtonElement button2 = querySelector("#dismiss");
  button2.hidden = false;
  ButtonElement button3 = querySelector("#yes");
  button3.hidden = true;
  ButtonElement button4 = querySelector("#no");
  button4.hidden = true;
  
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

void showAlert(MouseEvent e)
{
  popup("#popUpDiv");
}

void saveToClipboard(MouseEvent e)
{
  clipboardPrompt(licenceName);
}

void clipboardPrompt(String licence)
{
  var result = context.callMethod('prompt', ["Copy to clipboard: Ctrl+C, Enter", licence]);
  print(result);
  popup("#popUpDiv");
  main();
}

void dismissPrompt(MouseEvent e)
{
  popup("#popUpDiv");
  main();
}

void getResult(Function popup, String s)
{
  OutputElement licence = querySelector("#licence");
  licence.value = s;
  popup;
  licenceName = s;
}

popupFail(String popupId)
{
  PopupWindow p = new PopupWindow();
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "An Error Occurred: ";
  OutputElement licenceText = querySelector("#licence");
  licenceText.value = "";
  ButtonElement button = querySelector("#clipboard");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismiss");
  button2.hidden = false;
  ButtonElement button3 = querySelector("#yes");
  button3.hidden = true;
  ButtonElement button4 = querySelector("#no");
  button4.hidden = true;
  
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);
}

popupNoUserName(String popupId)
{
  PopupWindow p = new PopupWindow();
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "No Username Entered, Please Enter A Username.";
  OutputElement licenceText = querySelector("#licence");
  licenceText.value = "";
  ButtonElement button = querySelector("#clipboard");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismiss");
  button2.hidden = false;
  ButtonElement button3 = querySelector("#yes");
  button3.hidden = true;
  ButtonElement button4 = querySelector("#no");
  button4.hidden = true;
    
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId);  
}

popupInvalidDate(String popupId, String reason)
{
  PopupWindow p = new PopupWindow();
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = reason;
  OutputElement licenceText = querySelector("#licence");
  licenceText.value = "";
  ButtonElement button = querySelector("#clipboard");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismiss");
  button2.hidden = false;
  ButtonElement button3 = querySelector("#yes");
  button3.hidden = true;
  ButtonElement button4 = querySelector("#no");
  button4.hidden = true;
      
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId); 
}

popupLicenceFormat(String popupId)
{
  PopupWindow p = new PopupWindow();
  querySelector("#tick").setAttribute("src", "images/questionMark.png");
  querySelector("#popupTitle").innerHtml = "Username Format";
  OutputElement text = querySelector("#popupText");
  text.value = "The Username Is Not In The Recommended Email Format, Continue?";
  OutputElement licenceText = querySelector("#licence");
  licenceText.value = "";
  ButtonElement button = querySelector("#clipboard");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismiss");
  button2.hidden = true;
  ButtonElement button3 = querySelector("#yes");
  button3.hidden = false;
  ButtonElement button4 = querySelector("#no");
  button4.hidden = false;
  
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId); 
}

popupNoOptionSelected(String popupId)
{
  PopupWindow p = new PopupWindow();
  querySelector("#tick").setAttribute("src", "images/dialogWarning2.png");
  querySelector("#popupTitle").innerHtml = "Error";
  OutputElement text = querySelector("#popupText");
  text.value = "No Licence Length Option Selected, Please Pick An Option.";
  OutputElement licenceText = querySelector("#licence");
  licenceText.value = "";
  ButtonElement button = querySelector("#clipboard");
  button.hidden = true;
  ButtonElement button2 = querySelector("#dismiss");
  button2.hidden = false;
  ButtonElement button3 = querySelector("#yes");
  button3.hidden = true;
  ButtonElement button4 = querySelector("#no");
  button4.hidden = true;
        
  p.blanketSize(popupId);
  p.windowPosition(popupId);
  p.toggle('#blanket');
  p.toggle(popupId); 
}

void completeLicence(MouseEvent m)
{
  popup("#popUpDiv");
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
      "localhost",(s) => getResult(popup("#popUpDiv"), s),(s) => getResult(popupFail("#popUpDiv"), s));
        
  un.value = "";
  fe.value = "";
}
