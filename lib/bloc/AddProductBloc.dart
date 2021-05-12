import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/AddProductEvent.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/repo/AddProductRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/DoneState.dart';
import 'package:glider/state/OtpState.dart';

class AddProductBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is AddProductEvent) {
      yield ProgressDialogState();
      var response;
      if (event.oldProduct != null) {
        response = await updateProduct(event.body, event.oldProduct.id);
      } else {
        response = await addProduct(event.body);
      }

      yield DoneState(response);
    }
  }
}
