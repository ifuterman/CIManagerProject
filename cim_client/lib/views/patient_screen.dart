import 'package:cim_protocol/cim_protocol.dart';
import 'package:cim_client/cim_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:easy_localization/easy_localization.dart';
import 'main_view_controller.dart';
import 'patients_screen_controller.dart';


class PatientScreen extends StatelessWidget {
  final PatientsScreenController controller = Get.find();
  final scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Obx(() =>
            _buildPanelList(controller.updateScreen.value)),
      ),
    );
  }

  Widget _buildPanelList(bool update) {
    return ExpansionPanelList(
      children: getExpansionPanelList(),
      expansionCallback: (int index, bool isExpanded) {
        controller.patientItems[index].isExpanded =
        !isExpanded;
        controller.needUpdate();
      },
    );
  }

  List<ExpansionPanel> getExpansionPanelList() {
    List<ExpansionPanel> list = List();
    for (PatientItem item in controller.patientItems)
      list.add(PatientExpansionPanel.patient(item));
    return list;
  }
}

class PatientExpansionPanel implements ExpansionPanel {
  final PatientItem item;

  PatientExpansionPanel.patient(this.item);

  @override
  // TODO: implement body
  Widget get body => Container();

  @override
  // TODO: implement canTapOnHeader
  bool get canTapOnHeader => true;

  Widget _headerBuilder(BuildContext context, bool isExpanded, bool refresh) {
    return Row(
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
            child: Text(item.patient.firstName),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text(item.patient.middleName),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text("age".tr() + ": ${item.patient.age}"),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            child: Text("sex".tr() +
                ": " +
                (item.patient.sex == Sex.male ? "male".tr() : "female".tr())),
            margin: EdgeInsets.only(right: 2.0),
          ),
        ),
        getParticipationIcon(item.patient.participation),
      ],
    );
  }

  Widget buildHeader(BuildContext context, bool isExpanded) {
    return Obx(() => _headerBuilder(context, isExpanded, item.updated.value));
  }

  @override
  get headerBuilder => buildHeader;

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
  @override
  final Color backgroundColor = Colors.white;
}
