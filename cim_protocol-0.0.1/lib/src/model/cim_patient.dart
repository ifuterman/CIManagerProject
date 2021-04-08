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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMPatient &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          middleName == other.middleName &&
          lastName == other.lastName &&
          birthDate == other.birthDate &&
          phones == other.phones &&
          email == other.email &&
          snils == other.snils &&
          status == other.status &&
          sex == other.sex;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      middleName.hashCode ^
      lastName.hashCode ^
      birthDate.hashCode ^
      phones.hashCode ^
      email.hashCode ^
      snils.hashCode ^
      status.hashCode ^
      sex.hashCode;
}