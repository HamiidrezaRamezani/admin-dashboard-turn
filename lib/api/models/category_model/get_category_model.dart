import '../../common/meta_model.dart';
import 'get_category_data_model.dart';

class GetCategoryModel {
  final List<GetCategoryDataModel> data;
  final MetaModel meta;

  GetCategoryModel({required this.data, required this.meta});

  factory GetCategoryModel.fromJson(Map<String, dynamic> json) {
    return GetCategoryModel(
      data: (json['data'] as List).map((item) => GetCategoryDataModel.fromJson(item)).toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
