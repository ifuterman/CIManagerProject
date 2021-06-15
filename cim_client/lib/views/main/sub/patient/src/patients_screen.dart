import 'package:cim_protocol/cim_protocol.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/utils.dart';

import 'patients_screen_controller.dart';

class PatientScreen extends GetView<PatientsScreenController> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => _buildPanelList(c.updateScreen.value)),
      ),
    );
  }

  Widget _buildPanelList(bool update) {
    return ExpansionPanelList(
      children: getExpansionPanelList(),
      expansionCallback: (int index, bool isExpanded) {
        controller.patientItems[index].isExpanded = !isExpanded;
        controller.needUpdate();
      },
    );
  }

  List<ExpansionPanel> getExpansionPanelList() {
    List<ExpansionPanel> list = List.empty(growable: true);
    for (PatientItem item in controller.patientItems)
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
    return Obx(() => _headerBuilder(context, isExpanded, item.updated.value));
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

// class _Item extends StatelessWidget {
//   const _Item({Key key, this.item}) : super(key: key);
//
//   final Faq item;
//
//   @override
//   Widget build(BuildContext context) {
//     final now = DateFormat('dd.MM.yyyy').format(item.createdAt);
//     return ExpandableNotifier(
//       child: Builder(
//         builder: (context) {
//           final controller = ExpandableController.of(context);
//           return Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             clipBehavior: Clip.antiAlias,
//             elevation: 0,
//             color: controller.expanded ? AppColors.grayEF : Colors.white,
//             child: ScrollOnExpand(
//               scrollOnExpand: true,
//               scrollOnCollapse: false,
//               child: ExpandablePanel(
//                 theme: const ExpandableThemeData(
//                   headerAlignment: ExpandablePanelHeaderAlignment.center,
//                   tapBodyToCollapse: true,
//                   expandIcon: Icons.arrow_circle_down,
//                   collapseIcon: Icons.arrow_circle_up,
//                 ),
//                 header: Padding(
//                   padding: const EdgeInsets.only(left: 12),
//                   child: Row(
//                     children: [
//                       Text(
//                         item.question,
//                         style: const TextStyle(fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                 ),
//                 collapsed: Container(),
//                 expanded: ListTile(
//                   subtitle: Text(item.answer),
//                   trailing: Text(now),
//                 ),
//                 builder: (_, collapsed, expanded) {
//                   return Expandable(
//                     collapsed: collapsed,
//                     expanded: expanded,
//                     theme: const ExpandableThemeData(crossFadePoint: 0),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
