import 'package:glider/model/category/CategoryList.dart';
import 'package:glider/model/subscription/CheckSubscriptionModel.dart';
import 'package:glider/state/BaseState.dart';

class CategoryListState extends BaseState {
  final CategoryList categoryList;
  final CheckSubscriptionModel checkuser;

  CategoryListState(this.categoryList, {this.checkuser});
}
