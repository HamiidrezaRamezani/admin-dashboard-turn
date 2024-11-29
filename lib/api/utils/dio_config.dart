import 'package:dio/dio.dart';

class DioConfig {
  // Singleton Pattern برای دسترسی یکپارچه به Dio
  static final DioConfig _instance = DioConfig._internal();

  factory DioConfig() {
    return _instance;
  }

  late Dio dio;

  DioConfig._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://bqheshm-tickets.liara.run/api', // آدرس پایه API
      connectTimeout: const Duration(seconds: 10), // زمان اتصال
      receiveTimeout: const Duration(seconds: 10), // زمان دریافت
      headers: {
        'Host': '<calculated when request is sent>', // مقدار Host را تغییر دهید
        'User-Agent': 'PostmanRuntime/7.43.0',
        'Connection': 'keep-alive',
        'Accept-Encoding': 'gzip, deflate, br',
        'Accept': 'application/json',
      },
    ));

    // اضافه کردن Interceptor برای افزودن Token به همه درخواست‌ها
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // افزودن Token به هدر Authorization
        const token =
            '3ed165ed0410c05301f75fbf2f9b4d01ae623aeb433a448c11a4de9bafd9490dff884076f47311cb0a867f16eb408d301d50c4c3d16080aef91f99aaef52b7c91537863192c8d28e8a9122b7df566dad4d425aecb83ef6340e6dc13eae2f3934f1692192a2d4c2787dea4f9c62a457fbd3e3b532f5b761260fc72c58cf2d60e2'; // باید مقدار واقعی Token را قرار دهید
        options.headers['Authorization'] = 'Bearer $token';

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // مدیریت پاسخ‌ها (اختیاری)
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        // مدیریت خطاها (اختیاری)
        print('Dio Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }
}
