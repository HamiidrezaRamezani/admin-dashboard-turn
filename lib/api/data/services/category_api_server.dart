import 'package:dio/dio.dart';
import '../../models/category_model/get_category_model.dart';
import '../../utils/dio_config.dart';

class CategoryApiServer {
  final Dio dio = DioConfig().dio;

  Future<GetCategoryModel?> getCategoryFromServer() async {
    try {
      Response response = await dio.get('/categories?populate=*'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به مدل
        return GetCategoryModel.fromJson(response.data);
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


  Future<bool?> createCategoryToServer(Map<String, dynamic> requestDataMap) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.post('/categories', data: requestDataMap);

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

  Future<bool?> deleteCategoryToServer(String documentId) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.delete('/categories/$documentId',);

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

  Future<bool?> updateCategoryToServer(String documentId, Map<String, dynamic> requestDataUpdate) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.put('/categories/$documentId', data: requestDataUpdate);

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
