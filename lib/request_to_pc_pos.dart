import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RequestToPcPos extends StatefulWidget {
  const RequestToPcPos({super.key});

  @override
  State<RequestToPcPos> createState() => _RequestToPcPosState();
}

class _RequestToPcPosState extends State<RequestToPcPos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120.0,
                width: 340.0,
                color: Colors.red,
              ),
              SizedBox(
                height: 84.0,
              ),
              InkWell(
                onTap: (){
                  sendPostRequest();
                },
                child: Container(
                  height: 120.0,
                  width: 340.0,
                  color: Colors.blueGrey,
                  child: Center(
                    child: Text(
                      "Connection to PC-POS",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendPostRequest() async {
    // ایجاد یک نمونه از Dio
    final dio = Dio();

    // آدرس سرور
    const url = 'http://127.0.0.1:8050/api/sale';


    final body = {
      "DeviceIp": "192.168.100.92",
      "DevicePort": "8888",
      "ConnectionType": "Lan",
      "DivideType": "3",
      "Amount": "11111",
      "RequestId": "6ADDA412",
      "OrderId": "951236547",
      "RetryTimeOut": "5000,5000,5000",
      "ResponseTimeout": "180000,5000,5000"
    };

    try {
      // ارسال درخواست POST
      final response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json', // تنظیم صحیح MIME type
          },
        ),

      );

      // بررسی پاسخ
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('پاسخ موفقیت‌آمیز: ${response.data}');
      } else {
        print('خطا در پاسخ: ${response.statusCode}');
      }
    } catch (e) {
      print('خطا در ارسال درخواست: $e');
    }
  }



}
