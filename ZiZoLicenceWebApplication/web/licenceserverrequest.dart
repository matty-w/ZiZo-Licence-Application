import 'soaprequest.dart';

class LicenceServerRequest extends SoapRequest
{
  static void checkAdminLogin(String name,String password,String host,Function onPass,Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("checkAdminLogin");
    result.addArgument(name);
    result.addArgument(password);
    result.getStringResult((s) => (s=="true")? onPass() : onFail ());
  }
  
  static void addLicence(String user,String date,String filter,String adminName,String password,
                         String host,Function onPass,Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("addLicence");
    result.addArgument(user);
    result.addArgument(date);
    result.addArgument(filter);
    result.addArgument(adminName);
    result.addArgument(password);
    result.getStringResult((String s) => (s.contains("-"))? onPass(s) : onFail (s));
  }
  
  static void regenerateLicence(String licenceId, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("regenerate-licence");
    result.addArgument(licenceId);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s == "true")? onPass() : onFail(s));
  }
  
  static void addAdminUser(String operation, String user, String password, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
  }
  
  static void removeUser(String operation, String user, String adminName, String adminPassword, String host, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
    result.addArgument(operation);
    result.addArgument(user);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.getStringResult((String s) => (s == "true")? onPass() : onFail(s));
  }
  
  static void addPermission(String operation, String user, String adminName, String adminPassword, String host, String permissionChoice, Function onPass, Function onFail)
  {
    LicenceServerRequest result;
    result = new LicenceServerRequest();
    result.setHost(host);
    result.setAction("perform");
    result.addArgument(operation);
    result.addArgument(user);
    result.addArgument(adminName);
    result.addArgument(adminPassword);
    result.addArgument(permissionChoice);
    result.getStringResult((String s) => (s == "true")? onPass() : onFail(s));
  }
  
  @override
  namespace()
  {
    return "licence.zizo.decsim.com";
  }
  
  String path()
  {
    return "DataReLicenceServer/LicenceServer";
  }
}