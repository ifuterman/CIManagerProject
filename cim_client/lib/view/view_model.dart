
import 'dart:async';
import 'dart:io';

import 'package:filepicker_windows/filepicker_windows.dart';
import 'package:rxdart/rxdart.dart';




enum LeftListViewID{
  ITEM_PATIENTSLIST,
  ITEM_SCHEDULE,
  ITEM_USER,
  ITEM_PROTOCOLS,
  ITEM_SETTINGS
}

class ViewEvent{
}

class ItemSelectedViewEvent extends ViewEvent{
  LeftListViewID id;
  ItemSelectedViewEvent(this.id);
}

class AuthorizationViewEvent extends ViewEvent{
  bool authorized;
  AuthorizationViewEvent(this.authorized);
}

class InitialisationViewEvent extends ViewEvent{

}

class ItemPreselectViewEvent extends ViewEvent{
  LeftListViewID oldItem;
  LeftListViewID newItem;
  ItemPreselectViewEvent(this.newItem, this.oldItem);
}

class ViewModel {

  StreamController _itemSelectController = StreamController<ItemPreselectViewEvent>();
  StreamSubscription getItemSelectSubscription(Function callback(ItemPreselectViewEvent)){
    return _itemSelectController.stream.listen(callback);
  }


  int getMaxLength(List<String> list){
    int maxLength = 0;
    for(String str in list){
      if(str.length > maxLength)
        maxLength = str.length;
    }
    return maxLength;
  }

  LeftListViewID _selectedID = LeftListViewID.ITEM_USER;
  LeftListViewID get selectedID => _selectedID;

  Future<void> onMenuItemSelected(LeftListViewID id) async {
    _itemSelectController.add(ItemPreselectViewEvent(id, _selectedID));
    if(_selectedID == id)
      return;
    _selectedID = id;
//
    onEventRised.add(ItemSelectedViewEvent(id));
  }

  bool isMenuItemSelected(LeftListViewID id) => id == _selectedID ? true : false;

  bool _authorized = false;
  bool isAuthorized() => _authorized;

  /*final BehaviorSubject<ViewEvent> onMenuChanged = BehaviorSubject<ViewEvent>.seeded(ItemSelectedViewEvent(LeftListViewID.ITEM_USER));
  final BehaviorSubject<ViewEvent> onAuthorizedChanged = BehaviorSubject<ViewEvent>.seeded(AuthorizationViewEvent(false));*/
  final BehaviorSubject<ViewEvent> onEventRised = BehaviorSubject<ViewEvent>();


  UserAuthorizationViewModel _authorizationViewModel = UserAuthorizationViewModel();

  UserAuthorizationViewModel get authorizationViewModel =>
      _authorizationViewModel;

  UserInfoViewModel _userInfoViewModel = UserInfoViewModel();
  UserInfoViewModel get userInfoViewModel => _userInfoViewModel;

  Future authorizeUser() async{

    //TODO:Implement user authorization
    _authorized = true;
//    onAuthorizedChanged.add(AuthorizationViewEvent(_authorized));
    onEventRised.add(AuthorizationViewEvent(_authorized));
  }
}
final viewModel = ViewModel();//Типа синглтон

class UserAuthorizationViewModel
{
  String userName = "";
  String userPassword = "";
}

class UserInfoViewModel {
  String firstName = "";
  String lastName = "";
  String userMiddleName  = "";
  String position = "";
  String phoneNumber = "";
  String email = "";
  bool _changed = false;
  bool isChanged() => _changed;
  final BehaviorSubject<bool> userInfoChanged = BehaviorSubject<bool>();
  void setChanged(bool flag) {
    _changed = flag;
    userInfoChanged.add(_changed);
  }
  Future<void> saveUserInfo () async{
    _changed = false;
    userInfoChanged.add(_changed);
    //TODO: Realise save user info in database
  }
}