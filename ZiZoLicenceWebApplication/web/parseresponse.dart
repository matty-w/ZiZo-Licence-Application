library parse;

import 'parseinterior.dart';
import 'dart:html';

class ParseResponse
{
  static List parseLicenceList(String startTag, String endTag, String startTag2, String endTag2, String text)
  {
    List<String> registriesListTrim1 = new List<String>();
    List<String> registriesListTrim2 = new List<String>();
    List<String> registriesFinalList = new List<String>();
    List registries = text.split(startTag);
    registriesListTrim1 = ParseInterior.splitTag(registries, startTag, endTag);
    registriesListTrim2 = ParseInterior.parseSecondTag(registriesListTrim1, startTag2);
    registriesFinalList = ParseInterior.parseFinalLicenceList(registriesListTrim2, endTag2);
    return registriesFinalList;
  }
  
  static List parseLicence(String tag1, String text)
  {
    List<String> licences = text.split(tag1);
    licences.removeAt(0);
    return licences;
  }
  
  static String parseLicenceName(String licenceName)
  {
    int startTrim = licenceName.indexOf("</td>");
    String licenceName2 = licenceName.substring(startTrim);
    String licenceName3 = licenceName2.substring(9);
    int endTrim = licenceName3.indexOf("</td>");
    String licenceName4 = licenceName3.substring(0, endTrim);
    String finishedLicenceName = licenceName4;
    return finishedLicenceName;
  }
  
  static String parseLicenceKey(licenceKey)
  {
    int startTrim = licenceKey.indexOf("</td>");
    String licenceKey2 = licenceKey.substring(startTrim);
    String licenceKey3 = licenceKey2.substring(5);
    int trim2 = licenceKey3.indexOf("</td>");
    String licenceKey4 = licenceKey3.substring(trim2);
    String licenceKey5 = licenceKey4.substring(9);
    String licenceKey6 = licenceKey5.substring(0, 29);
    return licenceKey6;
  }
}