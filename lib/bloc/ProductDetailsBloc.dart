import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/AllProductEvent.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/ProductDetailsEvent.dart';
import 'package:glider/repo/ProductDetailRepo.dart' as product;
import 'package:glider/state/AllProductState.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/ProductDetailsState.dart';

class ProductDetailsBloc extends Bloc<BaseEvent, BaseState> {
  @override
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is ProductDetailsEvent) {
      yield LoadingState();
      var response = await product.getProductDetails(event.id);
      yield ProductDetailsState(response);
    } else if (event is AllProductEvent) {
      yield LoadingState();
      var response = await product.getAllProduct(event.id, event.page);
      yield AllProductState(response);
    }
  }
}
