import 'package:glider/model/UploadPicsModel.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/util/TypeEnum.dart';

class UploadPhotoDoneState extends BaseState {
  final UploadPicsModel home;
  final TypeEnum typeEnum;

  UploadPhotoDoneState(this.home, this.typeEnum);
}
