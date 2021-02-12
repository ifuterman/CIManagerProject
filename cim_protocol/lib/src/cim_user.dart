class CIMUser{
  int _id = 0;
  int get id => _id;

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
  CIMUser.fromJson (this._id, this._login, this._password);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMUser &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _login == other._login;

  @override
  int get hashCode => _id.hashCode ^ _login.hashCode;
  int role;
}