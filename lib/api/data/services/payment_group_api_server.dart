import 'package:dio/dio.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_data_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_data_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_data_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_model.dart';

import '../../models/users_models/get_users_data_model.dart';
import '../../utils/dio_config.dart';

class PaymentGroupApiServer {
  final Dio dio = DioConfig().dio;

  Future<GetPaymentGroupModel?> getPaymentGroupFromServer() async {
    try {
      Response response = await dio.get('/pay-groups?populate=*'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به مدل
        return GetPaymentGroupModel.fromJson(response.data);
      } else {
        print('Request failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      if (e is DioError) {
        // مدیریت خطاهای مربوط به Dio
        print('DioError: ${e.response?.data ?? e.message}');
      } else {
        // مدیریت سایر خطاها
        print('Unexpected error: $e');
      }
      return null;
    }
  }

  Future<bool?> deletePaymentGroupToServer(String documentId) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.delete(
        '/pay-groups/$documentId',
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        // تبدیل داده‌های پاسخ به مدل
        return true;
      } else {
        print('Request failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        // مدیریت خطاهای مربوط به Dio
        print('DioError: ${e.response?.data ?? e.message}');
      } else {
        // مدیریت سایر خطاها
        print('Unexpected error: $e');
      }
      return false;
    }
  }


  Future<bool?> createPaymentGroupToServer(Map<String, dynamic> requestDataMap) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.post('/pay-groups', data: requestDataMap);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // تبدیل داده‌های پاسخ به مدل
        return true;
      } else {
        print('Request failed: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        // مدیریت خطاهای مربوط به Dio
        print('DioError: ${e.response?.data ?? e.message}');
      } else {
        // مدیریت سایر خطاها
        print('Unexpected error: $e');
      }
      return false;
    }
  }

}
