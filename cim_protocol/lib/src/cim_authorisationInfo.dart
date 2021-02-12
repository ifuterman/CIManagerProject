import 'cim_user.dart';

class CIMAuthorisationInfo{
  static const grantTypeKey = 'grant_type';
  static const usernameKey = 'username';
  static const passwordKey = 'password';
  static const refreshTokenKey = 'refresh_token';
  static const accessTokenKey = 'access_token';
  static const String expiresInKey = 'expires_in';
  CIMAuthorisationInfo(CIMUser user){
    _username = user.login;
    _pwrd_hash = user.password;
  }
  String getPasswordAuthorisationBody(){
    return '$usernameKey=$_username&$passwordKey=$_pwrd_hash&$grantTypeKey=$passwordKey';
  }
  String getRefreshTokenBody()
  {
    return '$grantTypeKey=$refreshTokenKey&$refreshTokenKey=$_refreshToken';
  }
  bool parseResponse(Map<String, String> map){
    _token = map[accessTokenKey];
    _refreshToken = map[refreshTokenKey];
    if(_token == null || _refreshToken == null){
      return false;
    }
    var date = map[_expiresIn];
    if(date == null){return false;}
    _expiresIn = int.parse(date);
    return true;
  }
  String _username = '';
  String _pwrd_hash = '';
  String _token = '';
  String _refreshToken = '';
  int _expiresIn;
}