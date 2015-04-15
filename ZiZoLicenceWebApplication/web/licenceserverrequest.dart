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