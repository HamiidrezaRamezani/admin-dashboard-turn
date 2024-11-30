import 'package:dio/dio.dart';

import '../../models/report_model/get_reports_data_model.dart';
import '../../utils/dio_config.dart';

class ReportApiServer {
  final Dio dio = DioConfig().dio;

  Future<GetReportsDataModel?> getReportFromServer() async {
    try {
      Response response = await dio.get('/ticket-reports-dashboard'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به مدل GetReportsDataModel
        GetReportsDataModel reportData = GetReportsDataModel.fromJson(response.data);
        return reportData;
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


}