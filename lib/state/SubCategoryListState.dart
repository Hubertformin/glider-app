import 'package:glider/model/category/CategoryDetailModel.dart';
import 'package:glider/state/BaseState.dart';

class SubCategoryListState extends BaseState {
  final List<SubCategory> categoryList;

  SubCategoryListState(this.categoryList);
}
