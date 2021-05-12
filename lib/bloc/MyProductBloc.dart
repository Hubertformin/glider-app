import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/ChangeProductStatusEvent.dart';
import 'package:glider/event/DeleteProductEvent.dart';
import 'package:glider/event/GetMyProductEvent.dart';
import 'package:glider/repo/MyProductRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/MyProductState.dart';
import 'package:glider/state/OtpState.dart';

class MyProductBloc extends Bloc<BaseEvent, BaseState> {
  @override
// TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is GetMyProductEvent) {
      yield LoadingState();
      var response = await getMyProduct();
      yield MyProductState(response);
    } else if (event is DeleteProductEvent) {
      yield ProgressDialogState();
      var response = await deleteProduct(event.productId);
      yield DoneState(response);
    } else if (event is ChangeProductStatusEvent) {
      yield ProgressDialogState();
      var response = await changeStatus(event.id, event.status);
      yield DoneState(response);
    }
  }
}
