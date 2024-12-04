import 'package:flutter/material.dart';

import 'api/data/services/report_api_server.dart';
import 'api/models/report_model/get_reports_data_model.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late Future<GetReportsDataModel?> _futureData;
  final ReportApiServer _apiServer = ReportApiServer(); // نمونه کلاس API

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();  // اطمینان از بازگشت نوع درست
  }

  Future<GetReportsDataModel?> _fetchData() async {
    try {
      return await _apiServer.getReportFromServer();  // بازگشت نوع صحیح
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetReportsDataModel?>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          var topServices = snapshot.data!.topServices;
          var item = snapshot.data!;
          // این بخش نمایش داده‌های صحیح خواهد بود
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Row(
                    children: [
                      Text(
                        'گزارشات',
                        style: TextStyle(
                            color: Colors.black, fontFamily: "bold", fontSize: 30.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                    child: Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: const BoxDecoration(
                                // color: Color(0xFF628DFF),
                              gradient: LinearGradient(colors: [
                                Color(0xFF007BFF),
                                Color(0xFF3C9AFF)
                              ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.all(Radius.circular(12.0))
                            ),
                            child: Padding(padding: EdgeInsets.all(24.0), child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(item.totalTickets.toString(), style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 56.0,
                                      color: Colors.white
                                  ),),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text('بلیط های گرفته شده', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                                )
                              ],
                            ),),
                          ),
                        ),
                        const SizedBox(
                          width: 36.0,
                        ),
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF413D99),
                                  Color(0xFF9996D8)
                                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.all(Radius.circular(12.0))
                            ),
                            child: Padding(padding: EdgeInsets.all(24.0), child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(item.totalUsers.toString(), style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 56.0,
                                      color: Colors.white
                                  ),),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text('کل کاربرانی که وارد سامانه شدند', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                                )
                              ],
                            ),),
                          ),
                        ),
                        const SizedBox(
                          width: 36.0,
                        ),
                        Flexible(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFFFF6D19),
                                  Color(0xFFFFA571)
                                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                                borderRadius: BorderRadius.all(Radius.circular(12.0))
                            ),
                            child: Padding(padding: EdgeInsets.all(24.0), child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(formatNumberManually(item.totalSale.toString()), style: TextStyle(
                                      fontFamily: "bold",
                                      fontSize: 56.0,
                                      color: Colors.white
                                  ),),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text('کل پرداختی', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text('تومان', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                                )
                              ],
                            ),),
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 36.0,
                  ),
                  const Row(
                    children: [
                      Text(
                        'لیست خدمات پر فروش',
                        style: TextStyle(
                            color: Colors.black, fontFamily: "bold", fontSize: 30.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 36.0, right: 36.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: topServices.length,
                        itemBuilder: (BuildContext context , int index){
                          var topServicesItem = topServices[index];
                          return Container(
                              margin: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: (index % 2 == 0)
                                    ? const Color(0xFF007BFF).withOpacity(0.2)
                                    : const Color(0xFF007BFF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 36.0,
                                    width: 36.0,
                                    child: Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: "bold",
                                            fontSize: 24.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 24.0,
                                  ),
                                  Flexible(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'نام خدمت : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "bold",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Text(
                                                      topServicesItem.service.name,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                          "regular",
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 24.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'توضیحات : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "bold",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Flexible(
                                                      // اضافه کردن Flexible برای کنترل فضای متغیر
                                                      child: Text(
                                                        topServicesItem.service.description,
                                                        maxLines: 2,
                                                        // محدود کردن به دو خط
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        // نشان دادن ... در صورت بلند بودن متن
                                                        style:
                                                        const TextStyle(
                                                            color: Colors
                                                                .black,
                                                            fontFamily:
                                                            "regular",
                                                            fontSize:
                                                            16.0),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 24.30,
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'هزینه خدمت : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "bold",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Text(
                                                      formatNumberManually(
                                                          topServicesItem.service.price),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                          "regular",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    const Text(
                                                      'تومان',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                          "regular",
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 24.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      'تعداد خدمت : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "bold",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Text(
                                                      topServicesItem.count.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                          "regular",
                                                          fontSize: 16.0),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 24.0,
                                  ),
                                ],
                              ));
                    }),
                  ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {},
              label: const Text(
                'دریافت فایل Excel',
                style: TextStyle(
                    color: Color(0xFFFFFFFF), fontFamily: "bold", fontSize: 16.0),
              ),
              backgroundColor: const Color(0xFF628DFF),
            ),
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }

  String formatNumberManually(String number) {
    // حذف ویرگول‌های قبلی (در صورت وجود)
    number = number.replaceAll(',', '');
    // تبدیل رشته به لیستی از کاراکترها
    List<String> characters = number.split('');
    // لیستی برای نگهداری نتیجه
    List<String> formattedCharacters = [];
    // اضافه کردن ویرگول هر سه کاراکتر
    for (int i = 0; i < characters.length; i++) {
      formattedCharacters.add(characters[characters.length - i - 1]);
      if ((i + 1) % 3 == 0 && i != characters.length - 1) {
        formattedCharacters.add(',');
      }
    }
    // معکوس کردن لیست برای برگرداندن ترتیب اصلی
    return formattedCharacters.reversed.join('');
  }

}

