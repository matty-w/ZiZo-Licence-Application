import 'dart:html';
import 'onloadfunctions.dart';

void main()
{
  window.onContentLoaded.listen(refresh);
  refresh(null);
}

void refresh(Event e)
{
  OnLoadFunctions o = new OnLoadFunctions();
  o.addPermissions();
}
