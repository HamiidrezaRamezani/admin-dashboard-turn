import 'package:flutter/material.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_data_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_model.dart';
import 'package:turn_rating_launcher/api/models/payment_group_models/get_payment_group_model.dart';

import 'api/data/services/payment_group_api_server.dart';

class PaymentGroupScreen extends StatefulWidget {
  const PaymentGroupScreen({super.key});

  @override
  State<PaymentGroupScreen> createState() => _PaymentGroupScreenState();
}

class _PaymentGroupScreenState extends State<PaymentGroupScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();

  late Future<GetPaymentGroupModel?> _futureData; // متغیر Future برای FutureBuilder

  final PaymentGroupApiServer _apiServer = PaymentGroupApiServer(); // نمونه کلاس API

  @override
  void initState() {
    _fetchData(); // مقداردهی اولیه
    super.initState();
  }

  // متد برای مقداردهی Future
  void _fetchData() {
    setState(() {
      _futureData = _apiServer.getPaymentGroupFromServer(); // فراخوانی درخواست GET
    });
  }

  // متد ارسال داده به سرور و دریافت مجدد داده‌ها
  Future<void> _deleteDataToServer(String documentId) async {
    loadingDialog();

    try {
      var response = await _apiServer.deletePaymentGroupToServer(documentId);
      if (response == true) {
        // در صورت موفقیت، داده‌ها را مجدد دریافت کنید
        _fetchData();
      } else {
        print("POST request failed.");
      }
    } catch (e) {
      print("Error posting data: $e");
    } finally {
      // بستن دیالوگ لودینگ
      if (mounted) Navigator.of(context).pop();
    }
  }


  // متد ارسال داده به سرور و دریافت مجدد داده‌ها
  Future<void> _postDataToServer(Map<String, dynamic> requestData) async {
    loadingDialog();

    try {
      var response = await _apiServer.createPaymentGroupToServer(requestData);
      if (response == true) {
        // در صورت موفقیت، داده‌ها را مجدد دریافت کنید
        _fetchData();
      } else {
        print("POST request failed.");
      }
    } catch (e) {
      print("Error posting data: $e");
    } finally {
      // بستن دیالوگ لودینگ
      if (mounted) Navigator.of(context).pop();
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'نحوه پرداخت',
          style: TextStyle(
              color: Colors.black, fontFamily: "bold", fontSize: 30.0),
        ),
      ),
      body: FutureBuilder<GetPaymentGroupModel?>(
          future: _futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // itemsForGetExcel.clear();
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error ${snapshot.error}'),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final items = snapshot.data!.data;
              for (var element in items) {
                // itemsForGetExcel.add(GetAllUserDataModel(
                //   id: element!.id,
                //   name: element.name,
                //   username: element.username,
                //   email: element.email,
                //   phoneNumber: element.phoneNumber,
                //   nationalCode: element.nationalCode,
                //   blocked: element.blocked,
                //   confirmed: element.confirmed,
                //   documentId: element.documentId,
                //   provider: element.provider,
                //   publishedAt: element.publishedAt,
                //   updatedAt: element.updatedAt,
                //   createdAt: element.createdAt,
                // ));
              }
              return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                      itemCount: items.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        var item = items[index];
                        return Container(
                            margin: const EdgeInsets.only(
                                top: 8.0, bottom: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: (index % 2 == 0)
                                  ? const Color(0xFF007BFF)
                                  .withOpacity(0.2)
                                  : const Color(0xFF007BFF)
                                  .withOpacity(0.1),
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
                                Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    'نام نوع پرداخت : ',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily: "bold",
                                                        fontSize: 16.0),
                                                  ),
                                                  const SizedBox(
                                                    width: 4.0,
                                                  ),
                                                  Text(
                                                    (item!.name == null)
                                                        ? 'ندارد'
                                                        : item.name!,
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
                                                    'توضیحات نوع پرداخت : ',
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
                                                      item.description,
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
                                      ],
                                    )),
                                const SizedBox(
                                  width: 24.0,
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    _deleteDataToServer(item.documentId.toString());
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      const PopupMenuItem(
                                        value: "delete",
                                        child: Align(
                                            alignment:
                                            Alignment.centerRight,
                                            child: Text("حذف",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                    "medium",
                                                    fontSize: 14.0))),
                                      ),
                                    ];
                                  },
                                  icon: const Icon(
                                      Icons.more_vert), // آیکن سه‌نقطه
                                ),
                              ],
                            ));
                      }));
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            nameController.clear();
            describeController.clear();
          });

          addEditItemsDialog('');
        },
        label: const Text(
          'ایجاد نوع پرداخت',
          style: TextStyle(
              color: Color(0xFFFFFFFF), fontFamily: "bold", fontSize: 16.0),
        ),
        backgroundColor: const Color(0xFF628DFF),
      ),
    );
  }


  addEditItemsDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: const Row(
                children: [
                  Text('ایجاد یک نوع پرداخت',
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "bold",
                          color: Colors.black))
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          // رنگ پس‌زمینه
                          hintText: 'نام پرداخت را وارد کنید',
                          hintStyle: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: "regular",
                              color: Colors.grey),
                          border: InputBorder.none,
                          // بدون حاشیه
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            // بدون حاشیه در حالت عادی
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey), // حاشیه هنگام فوکوس
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.red), // حاشیه قرمز در خطا
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors
                                    .red), // حاشیه قرمز در خطا هنگام فوکوس
                          ),
                          errorStyle: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: "regular",
                              color: Colors.red),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 16.0),
                        ),
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: "regular",
                            color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'نام خدمت نباید خالی باشد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: describeController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          // رنگ پس‌زمینه
                          hintText: 'توضیحات پرداخت را وارد کنید',
                          hintStyle: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: "regular",
                              color: Colors.grey),
                          border: InputBorder.none,
                          // بدون حاشیه
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            // بدون حاشیه در حالت عادی
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey), // حاشیه هنگام فوکوس
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors.red), // حاشیه قرمز در خطا
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Colors
                                    .red), // حاشیه قرمز در خطا هنگام فوکوس
                          ),
                          errorStyle: const TextStyle(
                              fontSize: 12.0,
                              fontFamily: "regular",
                              color: Colors.red),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 16.0),
                        ),
                        style: const TextStyle(
                            fontSize: 14.0,
                            fontFamily: "regular",
                            color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'توضیحات خدمت نباید خالی باشد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF628DFF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0))),
                  onPressed: () {

                    if (_formKey.currentState!.validate()) {

                      Map<String, dynamic> requestData = {
                        "data": {
                          "name": nameController.text,
                          "description": describeController.text,
                        }
                      };

                      _postDataToServer(requestData);
                      Navigator.of(context).pop();

                    }
                  },
                  child: (documentId == '')? const Text('ایجاد نوع پرداخت',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "regular",
                          color: Colors.white)):const Text('ویرایش نوع پرداخت',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "regular",
                          color: Colors.white)),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: const BorderSide(
                              color: Color(0xFF628DFF), width: 1.0))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('لغو',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "regular",
                          color: Color(0xFF628DFF))),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  loadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          content: Container(
            height: 120.0,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  Text('در حال دریافت اطلاعات',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "bold",
                          fontSize: 16.0))
                ],
              ),
            ),
          ),
        ));
  }
}
