import 'package:rentors/model/category/CategoryList.dart';
import 'package:rentors/model/subscription/CheckSubscriptionModel.dart';
import 'package:rentors/state/BaseState.dart';

class CategoryListState extends BaseState {
  final CategoryList categoryList;
  final CheckSubscriptionModel checkuser;

  CategoryListState(this.categoryList, {this.checkuser});
}
