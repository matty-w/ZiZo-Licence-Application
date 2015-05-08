import 'loginfunctions.dart';
import 'dart:html';
import 'licenceserverrequest.dart';
import 'helpscreenfunctions.dart';
import 'viewablepages.dart';
import 'dart:js';

String licenceLength;
String defaultDate = today(3);
String licenceName;
String isoDate;
bool continueWithLicence;

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
  String userValue;
  
  Event e;
  
  if(specifiedChoice.checked)
    if(checkDateValue(e) == false)
      return;   
  
  if(un.value == null || un.value.trim() == "")
  {
    return;
  }  
  else
  {
    if(checkUsername(e) == true)
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
          "localhost",(s) => getLicence(popup("#popUpDiv"), s),(s) => popupFail("#popUpDiv"));
      
      un.value = "";
      fe.value = "";
    }
  }
  un.value = "";
  fe.value = "";
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
    dateInput.setCustomValidity("Invalid Date : Licence Cannot Expire On Current Day");
    return false;
  }  
  else if(shortDate == null)
  {  
    dateInput.setCustomValidity("Please Enter A Date");
    return false;
  }  
  else if(!(shortDate.isAfter(nowWithoutTime)))
  {  
    dateInput.setCustomValidity("Invalid Date: Licence Cannot Be Set Before Current Day");
    return false;
  }  
  else if(!(shortDate.isAfter(nowPlusThree)))
  {  
    dateInput.setCustomValidity("Invalid Date: Licence Must Have Minimum Length Of Three Days");
    return false;
  }  
  else
    dateInput.setCustomValidity("");
  return true;
}

bool checkUsername(Event e)
{
  InputElement input = querySelector("#username");
  String username = input.value;
  
  RegExp exp = new RegExp("[a-zA-Z0-9][a-zA-Z0-9-_\s]+@[a-zA-Z0-9-\s].+\.[a-zA-Z]{2,5}");
  
   
  if(!(exp.hasMatch(username)))
  {  
    bool confirmWindow = window.confirm("The Username You Have Created Is Not In An Email Format (Test@Account.co.uk)"+ 
                                        "Which Is Recommended, Are You Sure You Wish To Use This Username?");
    confirmWindow;
      if(confirmWindow == true)
      {
        return true;
      }
      else
      {
        window.location.reload();
        return false;
      }  
  }
  else
    return true;
}

void toggle(div_id)
{
  DivElement el = querySelector(div_id);
  
  if(el.style.display == "none")
    el.style.display = "block";
  else
    el.style.display = "none";   
}

Rectangle blanketSize(String popupId)
{
  int viewportHeight, blanketHeight, popupHeight;
  HtmlHtmlElement frame = document.body.parentNode;
  viewportHeight = window.innerHeight;
  
  if ((viewportHeight > frame.scrollHeight) && (viewportHeight > frame.clientHeight))
    blanketHeight = viewportHeight;
  else if(frame.clientHeight > frame.scrollHeight)
    blanketHeight = frame.clientHeight;
  else
    blanketHeight = frame.scrollHeight;
  
  DivElement blanket = querySelector('#blanket');
  blanket.style.height = blanketHeight.toString() + 'px';
  DivElement popUpDiv = querySelector(popupId);
  popupHeight = (blanketHeight/2-200).floor();
  popUpDiv.style.top = popupHeight.toString() + 'px';
 
  return new Rectangle(0, 0, 0, viewportHeight);
}

Point windowPosition(String popupId)
{
  int windowWidth;
  int viewportWidth = window.innerHeight;
  HtmlHtmlElement frame = document.body.parentNode;
  
  if ((viewportWidth > frame.scrollWidth) && (viewportWidth > frame.clientWidth))
    windowWidth = viewportWidth;
  else if(frame.clientWidth > frame.scrollWidth)
    windowWidth = frame.clientWidth;
  else
    windowWidth = frame.scrollWidth;
     
  DivElement popUpDiv = querySelector(popupId);
  windowWidth = (windowWidth/2-200).floor();
  popUpDiv.style.left = windowWidth.toString() + 'px';
  
  return new Point(windowWidth, 0);
}

popup(String popupId)
{
  blanketSize(popupId);
  windowPosition(popupId);
  toggle('#blanket');
  toggle(popupId);
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

void getLicence(Function popup, String s)
{
  OutputElement licence = querySelector("#licence");
  licence.value = s;
  popup;
  licenceName = s;
}

popupFail(String popupId)
{
  ImageElement image = querySelector("#tick");
  image.src.replaceAll("images/ticksmall.png", "images/errorLogoSmall.png");
  blanketSize(popupId);
  windowPosition(popupId);
  toggle('#blanket');
  toggle(popupId);
}
