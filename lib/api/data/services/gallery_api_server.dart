import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../../models/gallery_models/get_gallery_data_model.dart';
import '../../utils/config_network.dart';
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
//   Future<bool?> uploadFile(Uint8List fileBytes, String fileName) async {
//     try {
//       FormData formData = FormData.fromMap({
//         'files': MultipartFile.fromBytes(fileBytes, filename: fileName),
//       });
//
//       // ارسال درخواست POST
//       Response response = await dio.post('/upload', data: formData);
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print('File uploaded successfully!');
//
//         return true;
//
//         // اینجا می‌توانید پردازش‌های بعدی انجام دهید.
//       } else {
//         print('Failed to upload file. Status code: ${response.statusCode}');
//         return false;
//       }
//     } catch (e) {
//       if (e is DioError) {
//         // مدیریت خطاهای مربوط به Dio
//         print('DioError: ${e.response?.data ?? e.message}');
//       } else {
//         // مدیریت سایر خطاها
//         print('Unexpected error: $e');
//       }
//       return false;
//     }
//   }



  Future<bool?> uploadFile(Uint8List fileBytes, String fileName) async {
    try {
      // ایجاد یک نمونه از Dio
      Dio dio = Dio();

      // آماده‌سازی داده‌های فرم
      FormData formData = FormData.fromMap({
        "files": MultipartFile.fromBytes(
          fileBytes,
          filename: fileName, // نام فایل
        ),
      });
      const token =
          '3ed165ed0410c05301f75fbf2f9b4d01ae623aeb433a448c11a4de9bafd9490dff884076f47311cb0a867f16eb408d301d50c4c3d16080aef91f99aaef52b7c91537863192c8d28e8a9122b7df566dad4d425aecb83ef6340e6dc13eae2f3934f1692192a2d4c2787dea4f9c62a457fbd3e3b532f5b761260fc72c58cf2d60e2'; // باید مقدار واقعی Token را قرار دهید

      // ارسال درخواست POST
      Response response = await dio.post(
        ConfigNetwork.baseUrl + '/upload', // آدرس API را جایگزین کنید
        data: formData,
        options: Options(
          headers: {
            'Host': '<calculated when request is sent>', // مقدار Host را تغییر دهید
            'User-Agent': 'PostmanRuntime/7.43.0',
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate, br',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data; boundary=<calculated when request is sent>',
            'Content-Length': '<calculated when request is sent>',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      // بررسی پاسخ سرور
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("File uploaded successfully!");
        return true;
      } else {
        print("Failed to upload file: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        print("DioError: ${e.response?.data ?? e.message}");
      } else {
        print("Unexpected error: $e");
      }
      return false;
    }
  }






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