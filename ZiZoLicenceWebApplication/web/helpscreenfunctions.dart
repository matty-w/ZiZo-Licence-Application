library helpPage;

import 'dart:html';

class HelpScreenFunctions
{
  
  showAddPermissionsScreen(MouseEvent m)
  { 
    window.open("helpPages/addPermissionsHelp.html","",'width=500,height=300,scrollbars=yes');  
  }
  
  showAddUsersScreen(MouseEvent m)
  {
    window.open("helpPages/addUserHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showCreateLicenceScreen(MouseEvent m)
  {
    window.open("helpPages/createLicenceHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showLogAccessScreen(MouseEvent m)
  {
    window.open("helpPages/logAccessHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showRegenerateLicenceScreen(MouseEvent m)
  {
    window.open("helpPages/regenerateLicenceHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showRemoveLicenceScreen(MouseEvent m)
  {
    window.open("helpPages/removeLicenceHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showRemoveUsersScreen(MouseEvent m)
  {
    window.open("helpPages/removeUserHelp.html","",'width=500,height=300,scrollbars=yes');
  }
  
  showViewLicencesScreen(MouseEvent m)
  {
    window.open("helpPages/viewLicencesHelp.html","",'width=500,height=300,scrollbars=yes');
  }
}  