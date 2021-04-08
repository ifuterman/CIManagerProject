enum UserRoles{
  administrator,
  doctor,
  patient
}

class CIMUser{
  UserRoles role;
  int _id = 0;
  int get id => _id;

  set id(int value) {
    _id = value;
  }

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

  CIMUser (this._login, this._password,[this.role = UserRoles.administrator]);
  CIMUser.fromJson (this._id, this._login, this._password, this.role);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMUser &&
          runtimeType == other.runtimeType &&
          _id == other._id &&
          _login == other._login &&
          role == other.role;

  @override
  int get hashCode => _id.hashCode ^ _login.hashCode;
}