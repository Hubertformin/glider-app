import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/UpdateUserDetailEvent.dart';
import 'package:glider/event/UserDetailEvent.dart';
import 'package:glider/model/UserModel.dart';
import 'package:glider/repo/UserRepo.dart' as product;
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/UserDetailState.dart';
import 'package:glider/util/Utils.dart';

class UserDetailBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is UserDetailEvent) {
      yield LoadingState();
      var response = await product.getUserDetail();
      yield UserDetailState(response);
    } else if (event is UpdateUserDetailEvent) {
      yield ProgressDialogState();
      var response = await product.updateUserDetails(event.body);
      var details = await product.getUserDetail();
      UserModel model = await Utils.getUser();
      model.data.profileImage = details.data.profilePic;
      await Utils.save(jsonEncode(model.toJson()));
      yield DoneState(response);
    }
  }
}
