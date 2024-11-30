import 'package:dio/dio.dart';

import '../../models/services_models/get_services_model.dart';
import '../../utils/dio_config.dart';

class ServicesApiServer {
  final Dio dio = DioConfig().dio;

  Future<GetServicesModel?> getServicesFromServer() async {
    try {
      Response response = await dio.get('/services'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به مدل
        return GetServicesModel.fromJson(response.data);
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


  Future<bool?> createServicesToServer(Map<String, dynamic> requestDataMap) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.post('/services', data: requestDataMap);

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

  Future<bool?> deleteServicesToServer(String documentId) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.delete('/services/$documentId',);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
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

  Future<bool?> updateServicesToServer(String documentId, Map<String, dynamic> requestDataUpdate) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.put('/services/$documentId', data: requestDataUpdate);

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
