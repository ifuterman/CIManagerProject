class CIMUser{
  String _login;
  String get login => _login;

  set login(String value) {
    _login = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String _password;

  CIMUser (this._login, this._password);
}