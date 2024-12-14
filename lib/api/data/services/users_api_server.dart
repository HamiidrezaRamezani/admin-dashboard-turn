import 'package:dio/dio.dart';

import '../../models/users_models/get_users_data_model.dart';
import '../../utils/dio_config.dart';

class UsersApiServer {
  final Dio dio = DioConfig().dio;

  Future<List<GetRegisteredUserDataModel>?>
      getRegisteredUsersFromServer() async {
    try {
      Response response =
          await dio.get('/user-reports-list'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به لیست مدل
        List<GetRegisteredUserDataModel> galleryData = (response.data as List)
            .map((item) => GetRegisteredUserDataModel.fromJson(item))
            .toList();
        return galleryData;
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

  Future<List<GetAllUserDataModel>?> getAllUsersFromServer() async {
    try {
      Response response = await dio.get('/users'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به لیست مدل
        List<GetAllUserDataModel> galleryData = (response.data as List)
            .map((item) => GetAllUserDataModel.fromJson(item))
            .toList();
        return galleryData;
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

  Future<bool?> deleteUsersToServer(String documentId) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.delete(
        '/users/$documentId',
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
}
