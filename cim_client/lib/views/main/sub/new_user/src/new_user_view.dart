import 'package:cim_client/views/shared/getx_helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_user_view_controller.dart';

class NewUserView extends AppGetView<NewUserViewController> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Center(
        child: Container(
          width: 500,
          margin: EdgeInsets.all(64),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.grey[200],
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          // color: Colors.yellow[400],
          child: Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(48.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Вводим, вводим, не стесняемся!'),
                    SizedBox(height: 60),
                    TextFormField(
                      onChanged: c.changeName,
                      decoration: InputDecoration(
                        hintText: 'Имя'
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      onChanged: c.changePassword,
                      decoration: InputDecoration(
                        hintText: 'Фамилия'
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter роль';
                        }
                        return null;
                      },
                      value: null,
                      items: ['Админ','Врачелло','Терпила',]
                          .map((label) => DropdownMenuItem(
                        child: Text(label.toString()),
                        value: label,
                      ))
                          .toList(),
                      hint: Text('Роль'),
                      onChanged: (value) {
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState.validate()) {
                                c.processing();
                              }
                            },
                            child: Text('Submit'),
                          ),
                          ElevatedButton(
                            onPressed: c.cancel,
                            child: Text('Cancel'),
                          ),
                        ],
                      ),
                    ),

                ],),
              ),
            ) ,
          ),
        ),
      ),
    );
  }
}

