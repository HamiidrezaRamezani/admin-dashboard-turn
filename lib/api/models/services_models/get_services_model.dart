import 'package:turn_rating_launcher/api/models/services_models/get_services_data_model.dart';
import '../../common/meta_model.dart';

class GetServicesModel {
  final List<GetServicesDataModel> data;
  final MetaModel meta;

  GetServicesModel({required this.data, required this.meta});

  factory GetServicesModel.fromJson(Map<String, dynamic> json) {
    return GetServicesModel(
      data: (json['data'] as List).map((item) => GetServicesDataModel.fromJson(item)).toList(),
      meta: MetaModel.fromJson(json['meta']),
    );
  }
}
