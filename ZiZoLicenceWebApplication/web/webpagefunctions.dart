library webPageFunctions;

import 'dart:html';
import 'loginfunctions.dart';
import 'popup.dart';
import 'popupconstruct.dart';
import 'createlicence.dart';
import 'dart:js';
import 'licenceserverrequest.dart';
import 'createtable.dart';
import 'parseresponse.dart';

String isoDate;
String licenceLength;
String licenceLengthError;
List<String> licenceNames;
List<String> licenceDates;
List<String> licenceKeys;
List<int> tableRows = new List<int>();
HttpRequest request = new HttpRequest();
int checkboxLength = null;
int nullRows = 0;
int deletedRows = 0;
int deletedRows2 = 0;

class GlobalFunctions
{
  void setLogOut()
  {
    LoginAndOut log = new LoginAndOut();
    querySelector("#showLogOut").onClick.listen(log.logout);
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
  }
  
  void clipboardPrompt(String licence)
  {
    SelectPopup sp = new SelectPopup();
    var result = context.callMethod('prompt', ["Copy to clipboard: Ctrl+C, Enter", licence]);
    print(result);
    sp.popupLicence("add-licence","#popUpDiv");
    main();
  }
  
  void clearTable(Event e)
  {
    TableElement table = querySelector("#searchTable");
    table.hidden = true;
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
      sp.popupOther("no-licence","#popUpDiv");
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
    
    LicenceServerRequest.removeLicence(licenceValue, window.sessionStorage['username'],window.sessionStorage['password'], LicenceServerRequest.defaultUri(),
        (s) => p.getResult(sp.popup("remove-licence","#popUpDiv"), s),(s) => p.getResult(sp.popupFail("#popUpDiv"), s));
  }
  
  void searchLicences(MouseEvent m)
  {
    SelectPopup sp = new SelectPopup();
    PopupWindow p = new PopupWindow();    
    InputElement search = querySelector("#licenceSearch");
    String licenceSearch;
    licenceSearch = search.value;
    if(!(licenceSearch.trim() == "") && !licenceSearch.contains(".*"))
    {
      licenceSearch = licenceSearch+".*";
    }
    
    if(licenceSearch == null || licenceSearch.trim() == "")
    {
      sp.popupOther("no-search-value", "#popUpDiv");
      return;
    }
    
    LicenceServerRequest.searchForLicences(licenceSearch, window.sessionStorage['username'],window.sessionStorage['password'], LicenceServerRequest.defaultUri(),
           (s) => goToSearchResultPage(s), (s) => p.getResult(sp.popupFail("#popUpDiv"), s));
  }
  
  goToSearchResultPage(String responseText)
  {
    List keyAndDate = ParseResponse.parseLicence("key=", responseText);
    List<String> keysList = new List<String>(); 
    List<String> dates = new List<String>();
    List<String> licenceName = new List<String>();
    window.sessionStorage['rows'] = "";

    for(int i = 0; i < keyAndDate.length; i++)
    {
      String keyDate = keyAndDate[i];
      String key = keyDate.substring(0, 29);
      keysList.add(key);
      window.sessionStorage['licenceKey$i'] = keysList[i];
    }
    for(int i = 0; i < keyAndDate.length; i++)
    {
      String keyDate = keyAndDate[i];
      String date = keyDate.substring(keyDate.lastIndexOf('date=') + 5);
      dates.add(date);
      window.sessionStorage['licenceDate$i'] = dates[i];
    }
    for(int i = 0; i < keyAndDate.length; i++)
    {
      String keyName = keyAndDate[i];
      String nameAndDate = keyName.substring(34);
      String date = nameAndDate.substring(nameAndDate.lastIndexOf('date='));
      int dateLength = date.length;
      int nameAndDateLength = nameAndDate.length;
      int nameLength = nameAndDateLength - dateLength;
      String name = nameAndDate.substring(0, nameLength);
      licenceName.add(name);
      window.sessionStorage['licenceName$i'] = licenceName[i];
    }
    window.sessionStorage['rows'] = licenceName.length.toString();
    window.location.href = "searchResults.html";
  }
}

class SearchResults
{
  void loadTable(Event e)
  {
    TableElement table = querySelector("#searchTable");
    Storage local = window.sessionStorage;
    int rows = int.parse(local['rows']);
    List<String> keysList = new List<String>(); 
    List<String> dates = new List<String>();
    List<String> licenceName = new List<String>();
    for(int i = 0; i < rows; i++)
    {
      String date = local['licenceDate$i'];
      dates.add(date);
    }
    for(int i = 0; i < rows; i++)
    {
      String name = local['licenceName$i'];
      licenceName.add(name);
    }
    for(int i = 0; i < rows; i++)
    {
      String key = local['licenceKey$i'];
      keysList.add(key);
    }

    for(int i = 0; i < licenceName.length; i++)
    {
      TableRowElement row = table.insertRow(-1);
      TableCellElement checkboxCell = row.insertCell(0);
      TableCellElement lName = row.insertCell(1);
      TableCellElement lKey = row.insertCell(2);
      TableCellElement lDate = row.insertCell(3);
      checkboxCell.innerHtml = "<input id=checkbox$i type='checkbox'>";
      lName.text = licenceName[i];
      lKey.text = keysList[i];
      if(dates[i].trim() == "" || dates[i] == null)
      {
        lDate.text = "Unlimited Licence Length";
      }
      else
      {
        lDate.text = dates[i];
      }
     }
    CreateTable.createTable();
  }
  
  void returnToPage(MouseEvent m)
  {
    Storage local = window.sessionStorage;
    int rows = int.parse(local['rows']);
    TableElement table = querySelector("#searchTable");
    int tableLength = table.rows.length;
    table.remove();
    if(tableLength > 0)
    {
      for(int i = 0; table.rows.length > 0; i++)
      {
        table.deleteRow(0);
      }
    }
    for(int i = 0; i < rows; i++)
    {
      local['licenceDate$i'] = "";
      local['licenceName$i'] = "";
      local['licenceKey$i'] = "";
    }
    local['rows'] = "";
    checkboxLength == null;
    window.location.href = "removeLicence.html";
  }
  
  void deleteLicences(MouseEvent m)
  {
    List<String> licencesForDeletion = new List<String>();
    SelectPopup sp = new SelectPopup();
    licencesForDeletion = SearchResults.licencesForDeletion();

    if(licencesForDeletion.length == 0 || licencesForDeletion.length == null)
    {
      sp.popupOther("no-licences-selected", "#popUpDiv");
    }
    if(licencesForDeletion.length > 0)
    {
      completeDeletion();
    }
  }
  
  void completeDeletion()
  {
    TableElement table = querySelector("#searchTable");
    PopupWindow p = new PopupWindow();
    SelectPopup sp = new SelectPopup();
    
    for(int i = 0; i < checkboxLength-1; i++)
    {
      CheckboxInputElement checkbox = querySelector("#checkbox$i");
      
      if(checkbox == null)
      {
        deletedRows = deletedRows+1;
        continue;
      }
      
      if(checkbox.checked == true)
      {
        String licenceKey = ParseResponse.parseLicenceKey(table.rows[i+1-deletedRows].innerHtml);
        LicenceServerRequest.removeLicence(licenceKey, window.sessionStorage['username'],window.sessionStorage['password'],
                       LicenceServerRequest.defaultUri(), moveToNext(), (s) => p.getResult(sp.popupFail("#popUpDiv"), s));
      }
    }
    removeRows();
    p.getResult(sp.popup("remove-licence", "#popUpDiv"), "");
    nullRows = 0;
    deletedRows = 0;
    deletedRows2 = 0;
  }
  
  removeRows()
  {
    TableElement table = querySelector("#searchTable");
    int deletedRows1 = 0;
    
    for(int i = 0; i < checkboxLength-1; i++)
    {
      CheckboxInputElement checkbox = querySelector("#checkbox$i");
      
      if(checkbox == null)
      {
        deletedRows2 = deletedRows2+1;
        continue;
      }
        
      if(checkbox.checked == true && i == 0 && deletedRows2 == 0)
      {
        table.rows[i+1].remove();
        deletedRows1++;
        continue;
      }
      if(checkbox.checked == true && i-deletedRows1 == 0 && deletedRows2 == 0)
      {
        table.rows[1].remove();
        deletedRows1++;
        continue;
      }
      if(checkbox.checked == true && i != 0 && deletedRows2 == 0)
      {
        int row = i-deletedRows1;
        table.rows[row+1].remove();
        deletedRows1++;
        continue;
      }
      if(checkbox.checked == true && i == 0 && deletedRows2 != 0)
      {
        table.rows[1].remove();
        deletedRows1++;
        continue;
      }
      if(checkbox.checked == true && i != 0 && deletedRows2 != 0)
      {
        int row = i-deletedRows1-deletedRows2;
        table.rows[row+1].remove();
        deletedRows1++;
        continue;
      }
    }
  }
  
  moveToNext()
  {
    return;
  }
  
  static List licencesForDeletion()
  {
    TableElement table = querySelector("#searchTable");
    List<String> licences = new List<String>();
    if(checkboxLength == null)
    {
      checkboxLength = table.rows.length;      
    }
    
    for(int i = 0; i < checkboxLength-1; i++)
    {
      CheckboxInputElement checkbox = querySelector("#checkbox$i");
      
      if(checkbox == null)
      {
        nullRows = nullRows+1;
        continue;
      }
      
      if(checkbox.checked == true && nullRows  != 0)
      {
        String licenceName = ParseResponse.parseLicenceName(table.rows[i+1-nullRows].innerHtml);
        licences.add(licenceName);
      }
      
      if(checkbox.checked == true && nullRows == 0)
      {
        String licenceName = ParseResponse.parseLicenceName(table.rows[i+1].innerHtml);
        licences.add("LICENCE NAME: "+licenceName);
      }
    }
    return licences;
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