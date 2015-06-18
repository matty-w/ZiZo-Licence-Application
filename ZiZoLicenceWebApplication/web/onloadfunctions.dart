library onload;

import 'dart:html';
import 'webpagefunctions.dart';
import 'helpscreenfunctions.dart';
import 'popupconstruct.dart';
import 'viewablepages.dart';

class OnLoadFunctions
{ 
  GlobalFunctions g = new GlobalFunctions();
  
  void createLicence()
  {
    CreateLicenceFunctions c = new CreateLicenceFunctions();
    HelpScreenFunctions help = new HelpScreenFunctions();
    PopupWindow p = new PopupWindow();   
    querySelector("#clipboard").onClick.listen(g.saveToClipboard);
    querySelector("#dismissSuccess").onClick.listen(c.completeLicence);     
    querySelector("#helpButton").onClick.listen(help.showCreateLicenceScreen); 
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
    querySelector("#dismissFail").onClick.listen(p.dismissPrompt);
    g.setLogOut();
    g.setDefaultIpAddress();
    c.disableDateLengthTextBox();
    c.createDefaultDate();
    c.setRadioButtons();
    c.listenToRadioButtons();   
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    querySelector("#default_submitButton").onClick.listen(c.submitForm);
    ViewablePages.revealOptions();
  }
  
  void addAdmin()
  {
    AddAdminFucntions a = new AddAdminFucntions();
    g.setLogOut();
    PopupWindow p = new PopupWindow();
    HelpScreenFunctions help = new HelpScreenFunctions();    
    querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);     
    querySelector("#helpButton").onClick.listen(help.showAddUsersScreen);
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    querySelector("#addUser_submitButton").onClick.listen(a.addAdmin);     
    ViewablePages.revealOptions();
  }
  
  void addPermissions()
  {
    AddPermissionsFunctions a = new AddPermissionsFunctions();
    g.setLogOut();
    PopupWindow p = new PopupWindow();
    HelpScreenFunctions help = new HelpScreenFunctions();     
    querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);    
    querySelector("#helpButton").onClick.listen(help.showAddPermissionsScreen);
    querySelector("#addPermissions_button").onClick.listen(a.addPermission);
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];   
    a.setDescriptionText();
    ViewablePages.revealOptions();
  }
  
  void regenerateLicence()
  {
    RegenerateLicenceFunctions r = new RegenerateLicenceFunctions();
    g.setLogOut();
    g.setDefaultIpAddress();
    PopupWindow p = new PopupWindow();
    HelpScreenFunctions help = new HelpScreenFunctions();
    querySelector("#clipboard").onClick.listen(g.saveToClipboard);
    querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
    querySelector("#regenerateLicence_button").onClick.listen(r.regenerateLicence);            
    querySelector("#helpButton").onClick.listen(help.showRegenerateLicenceScreen);
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];        
    ViewablePages.revealOptions();
  }
  
  void removeAdmin()
  {
    RemoveAdminFunctions r = new RemoveAdminFunctions();
    g.setLogOut();
    PopupWindow p = new PopupWindow();
    HelpScreenFunctions help = new HelpScreenFunctions();   
    querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);     
    querySelector("#helpButton").onClick.listen(help.showRemoveUsersScreen);
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    querySelector("#removeUser_button").onClick.listen(r.removeUser);     
    ViewablePages.revealOptions();
  }
  
  void removeLicence()
  {
    RemoveLicenceFunctions r = new RemoveLicenceFunctions();
    g.setLogOut();
    PopupWindow p = new PopupWindow();
    HelpScreenFunctions help = new HelpScreenFunctions();  
    querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
    querySelector("#removeLicence_button").onClick.listen(r.removeLicence);   
    querySelector("#helpButton").onClick.listen(help.showRemoveLicenceScreen);
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];   
    ViewablePages.revealOptions();
  }
  
  void changePassword()
  {
    InputElement username = querySelector("#username");
    Storage local = window.sessionStorage;
    String response = local['permissions'];
    List<String> permissions = null;
    
    if(response != null)
      permissions = response.split(",");
    if ((permissions!=null)&&(permissions.contains('change-password')))
    {  
      username.disabled = false;
      username.value = window.sessionStorage['username'];
    }  
    else
    {  
      username.disabled = true;
      username.value = window.sessionStorage['username'];
    }  
      
    
    ChangePassword cp = new ChangePassword();
    g.setLogOut();
    HelpScreenFunctions help = new HelpScreenFunctions(); 
    querySelector("#helpButton").onClick.listen(help.showChangePassword);
    PopupWindow p = new PopupWindow();
    
    querySelector("#username-output").innerHtml = window.sessionStorage['username'];
    querySelector("#changePassword_submitButton").onClick.listen(cp.changePassword);
    querySelector("#dismissFinal").onClick.listen(p.dismissPrompt);
    querySelector("#dismissSuccess").onClick.listen(p.dismissPrompt);
    ViewablePages.revealOptions();
  }
}