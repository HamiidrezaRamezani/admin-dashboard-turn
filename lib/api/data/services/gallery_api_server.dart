import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../models/gallery_models/get_gallery_data_model.dart';
import '../../utils/dio_config.dart';

class GalleryApiServer {
  final Dio dio = DioConfig().dio;

  Future<List<GetGalleryDataModel>?> getGalleryFromServer() async {
    try {
      Response response = await dio.get('/upload/files'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به لیست مدل
        List<GetGalleryDataModel> galleryData = (response.data as List)
            .map((item) => GetGalleryDataModel.fromJson(item))
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



// متد برای ارسال فایل به سرور
  Future<bool?> uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      FormData formData = FormData.fromMap({
        'files': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      // ارسال درخواست POST
      Response response = await dio.post('/upload', data: formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('File uploaded successfully!');

        return true;

        // اینجا می‌توانید پردازش‌های بعدی انجام دهید.
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
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


  // Future<bool?> createGalleryToServer(Map<String, dynamic> requestDataMap) async {
  //   try {
  //     // ارسال درخواست POST
  //     Response response = await dio.post('/services', data: requestDataMap);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // تبدیل داده‌های پاسخ به مدل
  //       return true;
  //     } else {
  //       print('Request failed: ${response.statusCode}');
  //       return false;
  //     }
  //   } catch (e) {
  //     if (e is DioError) {
  //       // مدیریت خطاهای مربوط به Dio
  //       print('DioError: ${e.response?.data ?? e.message}');
  //     } else {
  //       // مدیریت سایر خطاها
  //       print('Unexpected error: $e');
  //     }
  //     return false;
  //   }
  // }


  Future<bool?> deleteGalleryToServer(String imageId) async {
    try {
      // ارسال درخواست POST
      Response response = await dio.delete('/upload/files/$imageId');

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
