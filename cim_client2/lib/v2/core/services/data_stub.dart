import 'package:cim_client2/v2/apps/main/src/patients/patients_view_controller.dart';
import 'package:cim_protocol/cim_protocol.dart';

final patientItemsStub = <CIMPatient>[
    CIMPatient(1, 'Куликов', 'Валерий', Sex.male,
        status: Participation.free,
        snils: '222-333-444',
        phones: '+7(900)333-222-11',
        email: 'me@ya.ru',
        birthDate: DateTime(1965),
        middleName: 'Петрович'),
    CIMPatient(2, 'Футерман', 'Иосиф', Sex.male,
        status: Participation.refuse,
        snils: '999-555-000',
        phones: '+7(910)111-333-77',
        email: 'futer@gmail.com',
        birthDate: DateTime(1980),
        middleName: 'Владимирович'),
    CIMPatient(3, 'Футерман', 'Елена', Sex.female,
        status: Participation.free,
        snils: '5656-1313-888',
        phones: '+7(904)656-06-90',
        email: 'she@ya.ru',
        birthDate: DateTime(1982),
        middleName: 'Ивановна'),
];
