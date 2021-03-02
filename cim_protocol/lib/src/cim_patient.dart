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
  CIMPatient(this.id, this.lastName, this.name, this.sex,
      {
        this.status = Participation.unknown,
        this.snils,
        this.phones,
        this.email,
        this.birthDate,
        this.middleName
      });
  int id;
  String name;
  String middleName;
  String lastName;
  DateTime birthDate;
  String phones;
  String email;
  String snils;
  Participation status;
  Sex sex;
}