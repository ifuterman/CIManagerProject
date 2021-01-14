import 'dart:async';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'view_model.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      title: 'Flutter Demo',
      title: 'title'.tr(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: new MainHorizontalLayout(),
      ),
//      home: MyHomePage(title: 'title'.tr()),
    );
  }
}

class MainHorizontalLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Container(
              color: Colors.black,
              child: new MainViewLeftList(),
            ),
            flex: 1),
        Expanded(
          child: MainViewRightScreen(),
          flex: 4,
        )
      ],
    );
  }
}

class MainViewLeftList extends StatefulWidget {
  @override
  createState() => new _MainViewLeftListState();
}

class _MainViewLeftListState extends State<MainViewLeftList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ViewEvent>(
//      stream: viewModel.onAuthorizedChanged,
        stream: viewModel.onEventRised,
        builder: (context, snapshot) {
          return ListView(
            children: [
              ListTileTheme(
//          selectedColor: Colors.black,
//          selectedTileColor: Colors.white,
                child: Material(
                  color: viewModel.isMenuItemSelected(LeftListViewID.ITEM_USER)
                      ? Colors.blue
                      : Colors.black,
                  textStyle: TextStyle(color: Colors.white),
                  child: ListTile(
                    title: Text(
                      'MAINVIEWLEFTLIST_ITEM_AUTORIZATION_TITLE'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    hoverColor: Colors.blue,
                    onTap: () {
                      viewModel.onMenuItemSelected(LeftListViewID.ITEM_USER);
//                setState(() { viewModel.viewRegime = RightViewRegime.REGIME_USER; });
                      setState(() {});
                    },
                    trailing: Icon(
                      Icons.account_circle,
                      color:
                          viewModel.isAuthorized() ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
              ListTileTheme(
                child: Material(
                  color: viewModel
                          .isMenuItemSelected(LeftListViewID.ITEM_PATIENTSLIST)
                      ? Colors.blue
                      : Colors.black,
                  textStyle: TextStyle(color: Colors.white),
                  child: ListTile(
                    title: Text(
                      'MAINVIEWLEFTLIST_ITEM_PATIENTSLIST_TITLE'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    hoverColor: Colors.blue,
                    onTap: () {
                      viewModel
                          .onMenuItemSelected(LeftListViewID.ITEM_PATIENTSLIST);
//                setState(() { viewModel.viewRegime = RightViewRegime.REGIME_PATIENT; });
                      setState(() {});
                    },
                  ),
                ),
              ),
              ListTileTheme(
                child: Material(
                  color:
                      viewModel.isMenuItemSelected(LeftListViewID.ITEM_SCHEDULE)
                          ? Colors.blue
                          : Colors.black,
                  textStyle: TextStyle(color: Colors.white),
                  child: ListTile(
                    title: Text(
                      'MAINVIEWLEFTLIST_ITEM_SCHEDULE_TITLE'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    hoverColor: Colors.blue,
                    onTap: () {
                      viewModel
                          .onMenuItemSelected(LeftListViewID.ITEM_SCHEDULE);
//                setState(() { viewModel.viewRegime = RightViewRegime.REGIME_SCHEDULE; });
                      setState(() {});
                    },
                  ),
                ),
              ),
              ListTileTheme(
                child: Material(
                  color: viewModel
                          .isMenuItemSelected(LeftListViewID.ITEM_PROTOCOLS)
                      ? Colors.blue
                      : Colors.black,
                  textStyle: TextStyle(color: Colors.white),
                  child: ListTile(
                    title: Text(
                      'MAINVIEWLEFTLIST_ITEM_PROTOCOLS_TITLE'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    hoverColor: Colors.blue,
                    onTap: () {
                      viewModel
                          .onMenuItemSelected(LeftListViewID.ITEM_PROTOCOLS);
//                setState(() { viewModel.viewRegime = RightViewRegime.REGIME_PROTOCOL; });
                      setState(() {});
                    },
                  ),
                ),
              ),
              ListTileTheme(
                child: Material(
                  color:
                      viewModel.isMenuItemSelected(LeftListViewID.ITEM_SETTINGS)
                          ? Colors.blue
                          : Colors.black,
                  textStyle: TextStyle(color: Colors.white),
                  child: ListTile(
                    trailing: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    title: Text(
                      'MAINVIEWLEFTLIST_ITEM_SETTINGS_TITLE'.tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                    hoverColor: Colors.blue,
                    onTap: () {
                      viewModel
                          .onMenuItemSelected(LeftListViewID.ITEM_SETTINGS);
//                setState(() { viewModel.viewRegime = RightViewRegime.REGIME_PROTOCOL; });
                      setState(() {});
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }

/*  @override
  void setState(VoidCallback fn) => super.setState(fn);*/
}

class MainViewRightScreen extends StatefulWidget {
  @override
  State createState() {
    return MainViewRightScreenState();
  }
}

class MainViewRightScreenState extends State<MainViewRightScreen> {
  TextEditingController _controller_usrename = TextEditingController();
  TextEditingController _controller_password = TextEditingController();
  TextEditingController _controller_phone = TextEditingController();
  TextEditingController _controller_email = TextEditingController();

  @override
  void dispose() {
    _controller_password.dispose();
    _controller_usrename.dispose();
    _controller_email.dispose();
    _controller_phone.dispose();
    super.dispose();
    _itemSelectSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: StreamBuilder<ViewEvent>(
      stream: viewModel.onEventRised,
      builder: (context, snapshot) => getRightScreenWidget(context,
          snapshot.data == null ? InitialisationViewEvent() : snapshot.data),
    ));
  }

  Widget getRightScreenWidget(BuildContext context, ViewEvent event) {
    if (event is! ItemSelectedViewEvent &&
        event is! AuthorizationViewEvent &&
        event is! InitialisationViewEvent) return Container(color: Colors.grey);

    switch (viewModel.selectedID) {
      case LeftListViewID.ITEM_USER:
        {
          if (viewModel.isAuthorized()) return getUserInfoScreen();
          return getUserAuthorizationScreen();
        }
      default:
        {
          return Container(color: Colors.grey);
        }
    }
  }

  Widget getUserAuthorizationScreen() {
    return Align(
//          alignment: Alignment.topLeft,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'USERAUTHORIZATIONSCREEN_USERNAME_TITLE'.tr(),
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.right,
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.headline6.fontSize * 1.2,
                width: Theme.of(context).textTheme.bodyText1.fontSize * 15),
            child: TextField(
              controller: _controller_usrename,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                viewModel.authorizationViewModel.userName = value;
              },
              onTap: () {
                _controller_usrename.text =
                    viewModel.authorizationViewModel.userName;
              },
            ),
          ),
          Text(
            'USERAUTHORIZATIONSCREEN_PASSWORD_TITLE'.tr(),
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.right,
          ),
          Container(
            constraints: BoxConstraints.expand(
                height: Theme.of(context).textTheme.headline6.fontSize * 1.2,
                width: Theme.of(context).textTheme.bodyText1.fontSize * 15),
            child: TextField(
              controller: _controller_password,
              textAlignVertical: TextAlignVertical.top,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                viewModel.authorizationViewModel.userPassword = value;
              },
              onTap: () {
                _controller_password.text =
                    viewModel.authorizationViewModel.userPassword;
              },
            ),
          ),
          SizedBox(height: 5),
          ElevatedButton(
            child: Text("USERAUTHORIZATIONSCREEN_BUTTON_AUTHORIZE_TITLE".tr()),
            onPressed: () => viewModel.authorizeUser(),
          ),
        ],
      ),
    );
  }

  Widget getUserInfoScreen() {
    int maxLength = viewModel.getMaxLength([
      "USERINFOSCREEN_LASTNAME_TITLE".tr(),
      "USERINFOSCREEN_FIRSTNAME_TITLE".tr(),
      "USERINFOSCREEN_MIDDLENAME_TITLE".tr(),
      "USERINFOSCREEN_POSITION_TITLE".tr(),
      "USERINFOSCREEN_PHONE_TITLE".tr(),
      "USERINFOSCREEN_EMAIL_TITLE".tr()
    ]);
    double labelWidth =
        Theme.of(context).textTheme.bodyText1.fontSize * maxLength.toDouble();
    TextStyle style = Theme.of(context).textTheme.bodyText1;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CircleAvatar(
                backgroundColor: Colors.red,
              ),
              flex: 1,
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          "USERINFOSCREEN_LASTNAME_TITLE".tr() +
                              ": " +
                              viewModel.userInfoViewModel.lastName,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          "USERINFOSCREEN_FIRSTNAME_TITLE".tr() +
                              ": " +
                              viewModel.userInfoViewModel.firstName,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          "USERINFOSCREEN_MIDDLENAME_TITLE".tr() +
                              ": " +
                              viewModel.userInfoViewModel.userMiddleName,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          "USERINFOSCREEN_POSITION_TITLE".tr() +
                              ": " +
                              viewModel.userInfoViewModel.position,
                          style: style,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          "USERINFOSCREEN_PHONE_TITLE".tr() + ": ",
                          style: style,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints.expand(
                            height:
                                Theme.of(context).textTheme.headline6.fontSize *
                                    1.2,
                            width:
                                Theme.of(context).textTheme.bodyText1.fontSize *
                                    15),
                        child: TextField(
                          controller: _controller_phone,
                          onChanged: (String) =>
                              viewModel.userInfoViewModel.setChanged(true),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: labelWidth,
                        child: Text(
                          "USERINFOSCREEN_EMAIL_TITLE".tr() + ": ",
                          style: style,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints.expand(
                            height:
                                Theme.of(context).textTheme.headline6.fontSize *
                                    1.2,
                            width:
                                Theme.of(context).textTheme.bodyText1.fontSize *
                                    15),
                        child: TextField(
                          controller: _controller_email,
                          onChanged: (String) =>
                              viewModel.userInfoViewModel.setChanged(true),
                        ),
                      ),
                      SizedBox.fromSize(size:  Size(10, 0),),
                      StreamBuilder<bool>(
                        stream: viewModel.userInfoViewModel.userInfoChanged,
                        builder: (context, snapshot) {
                          return ElevatedButton(
                            child: Text("USERINFOSCREEN_SAVE_BUTTON".tr()),
                            onPressed: !viewModel.userInfoViewModel.isChanged() ? null : () {
                              viewModel.userInfoViewModel.email =
                                  _controller_email.text;
                              viewModel.userInfoViewModel.phoneNumber =
                                  _controller_phone.text;
                              viewModel.userInfoViewModel.saveUserInfo();
                            },
                          );
                        }
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  StreamSubscription _itemSelectSubscription;
  @override
  void initState() {
    _itemSelectSubscription = viewModel.getItemSelectSubscription(onLeftItemChanging);
  }

  void onLeftItemChanging(ItemPreselectViewEvent event) {
    if(event is! ItemPreselectViewEvent)
      return;
    ItemPreselectViewEvent e = event as ItemPreselectViewEvent;
    if(e.oldItem != LeftListViewID.ITEM_USER)
      return;
    if(!viewModel.userInfoViewModel.isChanged())
      return;
    AlertDialog dialog = AlertDialog(
      title: Text("Тестовый диалог"),
      actions:
        <Widget>[
          TextButton(
            child: Text("Да"),
            onPressed: () => viewModel.userInfoViewModel.saveUserInfo(),
          ),
          TextButton(
            child: Text("Нет"),
            onPressed: () {},
          )
        ],
    );
  }
}
