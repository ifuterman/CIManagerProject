import 'package:cim_client2/v2/model/model_state.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:cim_client2/v2/core/extensions.dart';
import 'package:vfx_flutter_common/getx_helpers.dart';
import 'package:vfx_flutter_common/utils.dart';
import 'package:easy_localization/easy_localization.dart';

import 'patients_view_controller.dart';

class PatientsView extends GetViewSim<PatientsViewController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          20.h,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => _buildPanelList(c.patientItems$())),
              ),
            ),
          ),
          20.h,
          ElevatedButton(
            onPressed: c.addNew,
            child: Text('add'),
          ),
          20.h,
        ],
      ),
    );
  }

  Widget _buildPanelList(ModelState<PatientItems> state) {
    return state.when(
      (value) => ExpansionPanelList(
        children: _getExpansionPanelList(value),
        expansionCallback: (index, isExpanded) {
          value[index].isExpanded = !isExpanded;
        },
      ),
      initial: () => Container(child: Text('initial')),
      loading: () => Container(child: CircularProgressIndicator()),
      error: ([message]) => Container(child: Text(message ?? 'error')),
    );
  }

  List<ExpansionPanel> _getExpansionPanelList(PatientItems items) {
    List<ExpansionPanel> list = List.empty(growable: true);
    for (PatientItem item in items)
      list.add(PatientExpansionPanel.patient(item));
    return list;
  }  
}

class PatientExpansionPanel implements ExpansionPanel {
  final PatientItem item;

  PatientExpansionPanel.patient(this.item);

  @override
  final Color? backgroundColor = Colors.grey[100];

  @override
  Widget get body => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            child: Text('${item.patient.status}'),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(item.patient.snils ?? 'snils??'),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(item.patient.phones ?? 'phones??'),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(item.patient.email ?? 'email??'),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(''),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
      ],
    ),
  );

  @override
  // TODO: implement canTapOnHeader
  bool get canTapOnHeader => true;

  Widget _headerBuilder(BuildContext context, bool isExpanded, bool refresh) {
    final age = now.difference(item.patient.birthDate ?? now).inDays ~/ 365;
    final ageAsString = age > 0 ? '$age' : 'неизв.';

    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: Text(item.patient.lastName),
              margin: EdgeInsets.only(right: 2.0),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(item.patient.name),
              margin: EdgeInsets.only(right: 2.0),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text(item.patient.middleName ?? ''),
              margin: EdgeInsets.only(right: 2.0),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text("USERINFO_AGE".tr() + ": $ageAsString"),
              margin: EdgeInsets.only(right: 2.0),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Text("user_sex".tr() +
                  ": " +
                  (item.patient.sex == Sex.male ? "male".tr() : "female".tr())),
              margin: EdgeInsets.only(right: 2.0),
            ),
          ),
          getParticipationIcon(item.patient.status),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, bool isExpanded) {
    return Obx(() => _headerBuilder(context, isExpanded, item.updated$()));
  }

  @override
  ExpansionPanelHeaderBuilder get headerBuilder => buildHeader;

  Icon getParticipationIcon(Participation p) {
    switch (p) {
      case Participation.free:
        {
          return Icon(
            Icons.check_circle,
            color: Colors.green,
          );
        }
      case Participation.holded:
        {
          return Icon(
            Icons.ac_unit_outlined,
            color: Colors.blue,
          );
        }
      case Participation.participate:
        {
          return Icon(
            Icons.access_time_sharp,
            color: Colors.yellow,
          );
        }
      case Participation.refuse:
        {
          return Icon(
            Icons.stop_circle_outlined,
            color: Colors.purple,
          );
        }
      case Participation.unknown:
        {
          return Icon(
            Icons.add_call,
            color: Colors.grey,
          );
        }
      default:
        return Icon(
          Icons.cancel,
          color: Colors.red,
        );
    }
  }

  @override
  bool get isExpanded => item.isExpanded;
}


class _TestWidget extends StatefulWidget {
  const _TestWidget({Key? key}) : super(key: key);

  @override
  __TestWidgetState createState() => __TestWidgetState();
}

class __TestWidgetState extends State<_TestWidget> {

  @override
  void initState() {
    super.initState();
    debugPrint('$now: __TestWidgetState.initState');
  }

  @override
  void dispose() {
    debugPrint('$now: __TestWidgetState.dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
