import 'package:cim_client/views/shared/extensions.dart';
import 'package:cim_protocol/cim_protocol.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:vfx_flutter_common/utils.dart';
import 'package:vfx_flutter_common/vfx_flutter_common.dart';

import 'patients_screen_controller.dart';

class PatientScreenMain extends WithController<PatientsScreenController> {
  PatientScreenMain() : super(() => PatientsScreenController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          debugPrint('$now: PatientScreenMain.build: animation = $animation');

          var begin = Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween = Tween(begin: begin, end: end);
          var curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        },
        duration: const Duration(milliseconds: 500),
        // reverseDuration: const Duration(milliseconds: 2),
        child: c.subWidgetPlacer$(),
      ),
    );
  }
}

class _TextEditor extends StatelessWidget {
  const _TextEditor(this.controller, this.label, {Key? key}) : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(label),
      enabled: true,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10.0),
        labelText: label,
      ),
    );
  }
}

class AddNew extends GetViewSim<PatientsScreenController> {
  const AddNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _TextEditor(c.nameController, 'Фамилия'),
                _TextEditor(c.nameController, 'Имя'),
                _TextEditor(c.nameController, 'Отчество'),
                TextFormField(
                  key: const ValueKey('name'),
                  enabled: true,
                  controller: c.nameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Имя:',
                  ),
                ),
                TextFormField(
                  key: const ValueKey('surname'),
                  enabled: true,
                  controller: c.nameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    labelText: 'Фамилия:',
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: c.confirmAdding,
          child: Text('Back'),
        ),
        20.h,
      ],
    );
  }
}

// class AddNew2 extends GetViewSim<PatientsScreenController> {
//   const AddNew2({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.green[300],
//       child: Center(
//         child: ElevatedButton(
//           onPressed: c.confirmAdding,
//           child: Text('Back2'),
//         ),
//       ),
//     );
//   }
// }

class PatientScreen extends GetViewSim<PatientsScreenController> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        20.h,
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => _buildPanelList(c.updateScreen.value)),
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
    );
  }

  Widget _buildPanelList(bool update) {
    return ExpansionPanelList(
      children: getExpansionPanelList(),
      expansionCallback: (int index, bool isExpanded) {
        c.patientItems[index].isExpanded = !isExpanded;
        c.needUpdate();
      },
    );
  }

  List<ExpansionPanel> getExpansionPanelList() {
    List<ExpansionPanel> list = List.empty(growable: true);
    for (PatientItem item in c.patientItems)
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
//             color: c.expanded ? AppColors.grayEF : Colors.white,
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
