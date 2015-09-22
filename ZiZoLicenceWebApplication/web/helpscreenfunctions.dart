library helpPage;

import 'dart:html';

class HelpScreenFunctions
{
  WindowBase helpWindow;
   
  showAddPermissionsScreen(MouseEvent m)
  { 
    showHelpScreen("helpPages/addPermissionsHelp.html");  
  }
  
  showAddUsersScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/addAdminHelp.html");
  }
  
  showChangePassword(MouseEvent m)
  {
    showHelpScreen("helpPages/changePasswordHelp.html");
  }
  
  showCreateLicenceScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/createLicenceHelp.html");
  }
  
  void showHelpScreen(String url)
  {
    if(helpWindow != null && !helpWindow.closed)
      helpWindow.location;
    else
      helpWindow = window.open(url, "",'width=500,height=300,scrollbars=yes');
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
    showHelpScreen("helpPages/removeAdminHelp.html");
  }
  
  showSearchScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/searchScreenHelp.html");
  }
  
  showViewLicencesScreen(MouseEvent m)
  {
    showHelpScreen("helpPages/viewLicencesHelp.html");
  }
}  