enum DoctorSpeciality{
  therapist
}

class CIMDoctor{
  CIMDoctor(this.name, this.lastName, this.speciality, {this.middleName, this.birthDate, this.email, this.phones, this.userId = 0, this.id = 0});
  int id;
  String name;
  String? middleName;
  String lastName;
  DateTime? birthDate;
  String? email;
  String? phones;
  DoctorSpeciality speciality;
  int userId = 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CIMDoctor &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          middleName == other.middleName &&
          lastName == other.lastName &&
          birthDate == other.birthDate &&
          email == other.email &&
          phones == other.phones &&
          speciality == other.speciality &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      middleName.hashCode ^
      lastName.hashCode ^
      birthDate.hashCode ^
      email.hashCode ^
      phones.hashCode ^
      speciality.hashCode ^
      userId.hashCode;
}