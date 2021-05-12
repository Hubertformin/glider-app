import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glider/event/BaseEvent.dart';
import 'package:glider/event/CategoryDetailEvent.dart';
import 'package:glider/event/CategoryListEvent.dart';
import 'package:glider/event/ChangeSubCategory.dart';
import 'package:glider/event/SubCategoryDetailEvent.dart';
import 'package:glider/event/SubCategoryEvent.dart';
import 'package:glider/repo/CategoryRepo.dart' as categoryRepo;
import 'package:glider/repo/SubscriptionRepo.dart';
import 'package:glider/state/BaseState.dart';
import 'package:glider/state/CategoryDetailState.dart';
import 'package:glider/state/CategoryListState.dart';
import 'package:glider/state/ChangeSubCategoryState.dart';
import 'package:glider/state/OtpState.dart';
import 'package:glider/state/SubCategoryDetailState.dart';
import 'package:glider/state/SubCategoryListState.dart';

class CategoryListBloc extends Bloc<BaseEvent, BaseState> {
  @override
  // TODO: implement initialState
  BaseState get initialState => LoadingState();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is CategoryListEvent) {
      yield LoadingState();
      var subscripeResponse = await checkSubscription();
      var response = await categoryRepo.getCategoryList();
      yield CategoryListState(response, checkuser: subscripeResponse);
    } else if (event is CategoryDetailEvent) {
      yield LoadingState();
      var response = await categoryRepo.getCategoryDetails(event.id);
      yield CategoryDetailState(response);
    } else if (event is SubCategoryEvent) {
      yield LoadingState();
      await categoryRepo.getSubCategory();
      yield SubCategoryListState(event.category.subCategory);
    } else if (event is ChangeSubCategory) {
      yield LoadingState();
      await categoryRepo.getSubCategory();
      yield ChangeSubCategoryState(event.category);
    } else if (event is SubCategoryDetailEvent) {
      yield LoadingState();
      var res = await categoryRepo.getSubCategoryDetail(event.id, event.page);
      yield SubCategoryDetailState(res);
    }
  }
}
