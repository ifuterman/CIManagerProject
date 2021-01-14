enum Sex{
  male,
  female
}

enum Participation{
  refuse,
  holded,
  participate,
  free,
  blocked,
  unknown
}

class CIMPatient{
  String _firstName;
  String get firstName => _firstName;

  String _lastName;
  String get lastName => _lastName;

  String _middleName;
  String get middleName => _middleName;

  DateTime _birthDate;
  DateTime get birthDate => _birthDate;
  int get age => DateTime.now().year - _birthDate.year;

  Sex _sex;
  Sex get sex => _sex;

  Participation _participation;
  Participation get participation => _participation;

  CIMPatient(this._lastName, this._firstName, this._middleName, this._birthDate,
      this._sex, this._participation);
}