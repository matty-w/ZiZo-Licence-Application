library helpPage;

import 'dart:html';

class HelpScreenFunctions
{
  WindowBase helpWindow;
   
  void showHelpScreen(String url)
  {
    if(helpWindow != null && !helpWindow.closed)
      helpWindow.location;
    else
      helpWindow = window.open(url, "",'width=500,height=300,scrollbars=yes');
  }
  
  showAddPermissionsScreen(MouseEvent m)
  { 
    showHelpScreen("helpPages/addPermissionsHelp.html");  
  }
  
  showAddUsersScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/addAdminHelp.html");
  }
  
  showCreateLicenceScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/createLicenceHelp.html");
  }
  
  showLogAccessScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/logAccessHelp.html");
  }
  
  showRegenerateLicenceScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/regenerateLicenceHelp.html");
  }
  
  showRemoveLicenceScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/removeLicenceHelp.html");
  }
  
  showRemoveUsersScreen(MouseEvent m)
  {
    window.open("helpPages/removeAdminHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showViewLicencesScreen(MouseEvent m)
  {
    window.open("helpPages/viewLicencesHelp.html","",'width=500,height=300,scrollbars=yes');
  }
}  