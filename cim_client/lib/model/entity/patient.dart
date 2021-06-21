import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'patient.freezed.dart';

///
@freezed
class Patient with _$Patient {
  factory Patient({
    required int id,
    required String name,
    required String middleName,
    required String lastName,
    required DateTime birthDate,
    required String phone,
    required String email,
    required String snils,
    required Participation status,
    required Sex sex,
  }) = _Patient;
}

@freezed
class Patients with _$Patients {
  factory Patients(IList<Patient> items) = _Patients;
}

enum Participation{
  refuse,
  holded,
  participate,
  free,
  blocked,
  unknown
}

enum Sex{
  male,
  female
}
