import 'package:cim_client2/core/getx_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_view_controller.dart';

class ConnectView extends AppGetView<HomeViewController> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Material(
      child: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Данные коннекта'),
                SizedBox(height: 60),
                _Input(
                  textController: c.addressCtrl,
                  items: addresses,
                  validatorText: 'Назначьте адрес',
                ),
                _Input(
                  textController: c.portCtrl,
                  items: ports,
                  validatorText: 'Назначьте порт',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            c.reconnect();
                            Get.back();
                          }
                        },
                        child: Text('Reconnect'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.back();
                            Future.delayed(Duration.zero)
                                .then((_) => c.excel());
                          }
                        },
                        child: Text('EXCEL'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  _Input({
    required this.textController,
    required this.validatorText,
    required this.items,
    this.hintText,
  });

  final String? hintText;
  final String validatorText;
  final TextEditingController textController;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        new Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: textController,
                decoration: InputDecoration(hintText: hintText),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return validatorText;
                  }
                  return null;
                },
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.arrow_drop_down),
              onSelected: (String value) {
                textController.text = value;
              },
              itemBuilder: (BuildContext context) {
                return items.map<PopupMenuItem<String>>((String value) {
                  return new PopupMenuItem(
                      child: new Text(value), value: value);
                }).toList();
              },
            ),
          ],
        ),
      ],
    );
  }
}
