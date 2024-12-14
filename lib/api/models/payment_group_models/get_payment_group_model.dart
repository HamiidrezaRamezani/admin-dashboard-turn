import '../../common/meta_model.dart';
import 'get_payment_group_data_model.dart';

class GetPaymentGroupModel {
  final List<GetPaymentGroupDataModel> data;
  final MetaModel meta;

  GetPaymentGroupModel({required this.data, required this.meta});

  factory GetPaymentGroupModel.fromJson(Map<String, dynamic> json) {
    return GetPaymentGroupModel(
      data: (json['data'] as List).map((item) => GetPaymentGroupDataModel.fromJson(item)).toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
