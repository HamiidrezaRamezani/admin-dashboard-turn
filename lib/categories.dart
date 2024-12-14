import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:turn_rating_launcher/api/models/category_model/get_category_model.dart';
import 'package:turn_rating_launcher/api/models/services_models/get_services_data_model.dart';

import 'api/data/services/category_api_server.dart';
import 'api/models/gallery_models/get_gallery_data_model.dart';
import 'api/models/services_to_server_model.dart';
import 'api/utils/config_network.dart';
import 'api/utils/dio_config.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();


  late Future<GetCategoryModel?> _futureData; // متغیر Future برای FutureBuilder
  final CategoryApiServer _apiServer = CategoryApiServer(); // نمونه کلاس API

  List<ImageItemList> imagesFromGalleryForSelect = [];

  List<ServicesItemList> serviceFromServicesForSelect = [];

  // لیست برای ذخیره آیتم‌های انتخاب شده
  List<Map<String, String>> selectedImages = [];

  List<Map<String, String>> selectedService = [];

  final Dio dio = DioConfig().dio;


  bool isImageGetLoading = false;

  @override
  void initState() {
    super.initState();
    getGalleryFromServer();
    getServicesFromServer();
    _fetchData(); // مقداردهی اولیه
  }

  // متد برای مقداردهی Future
  void _fetchData() {
    setState(() {
      _futureData = _apiServer.getCategoryFromServer(); // فراخوانی درخواست GET
    });
  }


  // متد ارسال داده به سرور و دریافت مجدد داده‌ها
  Future<void> _deleteDataToServer(String documentId) async {
    loadingDialog();

    try {
      var response = await _apiServer.deleteCategoryToServer(documentId);
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
      var response = await _apiServer.createCategoryToServer(requestData);
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
      body: FutureBuilder<GetCategoryModel?>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final items = snapshot.data!.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Row(
                    children: [
                      Text(
                        'دسته بندی ها',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "bold",
                            fontSize: 30.0),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      double screenWidth =
                          constraints.maxWidth; // عرض صفحه
                      double itemWidth = screenWidth / 3 -
                          16; // عرض هر آیتم (یک‌سوم عرض صفحه با فاصله)
                      int crossAxisCount =
                      screenWidth > 1024 ? 3 : 2; // تعداد ستون‌ها
                      double itemHeight = itemWidth /
                          (16 / 9); // ارتفاع هر آیتم بر اساس نسبت 16:9

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                            crossAxisCount, // تعداد ستون‌ها
                            crossAxisSpacing: 16.0, // فاصله افقی
                            mainAxisSpacing: 16.0, // فاصله عمودی
                            childAspectRatio:
                            itemWidth / itemHeight, // نسبت تصویر
                          ),
                          itemCount: items.length, // تعداد آیتم‌ها
                          itemBuilder: (context, index) {
                            var item = items[index];
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    child: Image.network(
                                      ConfigNetwork.baseUrlImage + item.pics[0].formats.medium.url,
                                      fit: BoxFit.cover,
                                      // تغییر fit به BoxFit.cover برای پر کردن کامل فضای موجود
                                      loadingBuilder:
                                          (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent?
                                          loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child:
                                            CircularProgressIndicator(
                                              value: loadingProgress
                                                  .expectedTotalBytes !=
                                                  null
                                                  ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                      .expectedTotalBytes ??
                                                      1)
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        // در صورت بروز خطا، تصویر پیش‌فرض را نمایش بده
                                        return ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          child: Image.asset(
                                            'assets/images/png/imageNotFound.png',
                                            fit: BoxFit
                                                .cover, // تغییر fit به BoxFit.cover برای پر کردن فضای موجود
                                          ),
                                        ); // تصویر پیش‌فرض
                                      },
                                    ),
                                  ),
                                ),
                                Positioned.fill(child: Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [
                                        Colors.black.withOpacity(0.5),
                                        Colors.black.withOpacity(0.05)
                                      ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter
                                      ),
                                      borderRadius: BorderRadius.circular(8.0)
                                  ),
                                )),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8.0),
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        // _deleteDataToServer(item.id);
                                        _deleteDataToServer(
                                            item.documentId);
                                      },
                                      itemBuilder:
                                          (BuildContext context) {
                                        return [
                                          const PopupMenuItem(
                                            value: "delete",
                                            child: Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: Text("حذف",
                                                    style: TextStyle(
                                                        color:
                                                        Colors.black,
                                                        fontFamily:
                                                        "medium",
                                                        fontSize: 14.0))),
                                          ),
                                        ];
                                      },
                                      icon: const Icon(Icons
                                          .more_vert, color: Colors.white,), // آیکن سه‌نقطه
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16.0, bottom: 16.0),
                                      child: Text(item.name, style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontFamily: "bold",
                                          fontSize: 24.0),)
                                  ),
                                ),
                              ],
                            );
                            // child: Image.asset(name
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addEditItemsDialog('');
        },
        label: const Text(
          'ایجاد دسته بندی',
          style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: "bold",
              fontSize: 16.0),
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
                  Text('ایجاد یک دسته بندی',
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
                          hintText: 'نام دسته را وارد کنید',
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
                          hintText: 'توضیحات دسته را وارد کنید',
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
                      const Row(
                        children: [
                          Text('انتخاب تصویر برای دسته',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "medium",
                                  color: Colors.black))
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120.0,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: imagesFromGalleryForSelect.length,
                          itemBuilder: (context, index) {
                            final image = imagesFromGalleryForSelect[index];
                            return InkWell(
                              onTap: () {
                                toggleSelection(image.imageId);
                                setState(() {
                                  image.isSelect = !image.isSelect;
                                });
                              },
                              child: Container(
                                  height: 120.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (image.isSelect == true)
                                            ? Colors.green
                                            : Colors.transparent,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: const EdgeInsets.only(left: 12.0),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            ConfigNetwork.baseUrlImage +
                                                image.url,
                                            placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                            const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: (image.isSelect == true)
                                            ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          ),
                                        )
                                            : Container(),
                                      )
                                    ],
                                  )),
                            );
                            // ListTile(
                            //
                            //   title: Text("تصویر ${image["id"]}"),
                            //   trailing: Checkbox(
                            //     value: isSelected,
                            //     onChanged: (value) {
                            //       toggleSelection(image["id"]!);
                            //     },
                            //   ),
                            // );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Row(
                        children: [
                          Text('انتخاب سرویس مد نظر',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "medium",
                                  color: Colors.black))
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 120.0,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: serviceFromServicesForSelect.length,
                          itemBuilder: (context, index) {
                            final service = serviceFromServicesForSelect[index];
                            return InkWell(
                              onTap: () {
                                toggleSelectionServices(service.serviceId);
                                setState(() {
                                  service.isSelect = !service.isSelect;
                                });
                              },
                              child: Container(
                                  height: 120.0,
                                  width: 120.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: (service.isSelect == true)
                                            ? Colors.green
                                            : Colors.transparent,
                                        width: 2.0),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  margin: const EdgeInsets.only(left: 12.0),
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            ConfigNetwork.baseUrlImage +
                                                service.imageUrl,
                                            placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                            const Icon(Icons.error),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          width: 120.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                              borderRadius:
                                              BorderRadius.circular(12.0),
                                            gradient: LinearGradient(colors: [
                                              Colors.black,
                                              Colors.transparent
                                            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                                          ),
                                        )
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(service.serviceName, style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: "bold",
                                                  color: Colors.white
                                          ),),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: (service.isSelect == true)
                                            ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.check_box,
                                            color: Colors.green,
                                          ),
                                        )
                                            : Container(),
                                      )
                                    ],
                                  )),
                            );
                            // ListTile(
                            //
                            //   title: Text("تصویر ${image["id"]}"),
                            //   trailing: Checkbox(
                            //     value: isSelected,
                            //     onChanged: (value) {
                            //       toggleSelection(image["id"]!);
                            //     },
                            //   ),
                            // );
                          },
                        ),
                      ),
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
                          "pics": selectedImages,
                          "services": selectedService,
                        }
                      };

                      _postDataToServer(requestData);
                      Navigator.of(context).pop();

                    }

                    // عملکرد ارسال اطلاعات
                    // _postDataToServer();
                    // if (documentId == '') {
                    //   if (_formKey.currentState!.validate()) {
                    //     // اگر اعتبارسنجی موفق بود
                    //
                    //     String numberOfTicketText =
                    //         numberOfTicketController.text;
                    //     int ticketCount = 0;
                    //
                    //     if (numberOfTicketText.isNotEmpty &&
                    //         int.tryParse(numberOfTicketText) != null) {
                    //       ticketCount = int.parse(numberOfTicketText);
                    //     } else {
                    //       ticketCount = 0;
                    //     }
                    //
                    //     Map<String, dynamic> requestData = {
                    //       "data": {
                    //         "name": nameController.text,
                    //         "description": describeController.text,
                    //         "price": costOfTicketController.text,
                    //         "count": ticketCount,
                    //         "isactive": ticketIsActivated,
                    //         "pic": selectedImages
                    //       }
                    //     };
                    //
                    //     Navigator.of(context).pop();
                    //     _postDataToServer(requestData);
                    //   }
                    // } else {
                    //   if (_formKey.currentState!.validate()) {
                    //     // اگر اعتبارسنجی موفق بود
                    //
                    //     String numberOfTicketText =
                    //         numberOfTicketController.text;
                    //     int ticketCount = 0;
                    //
                    //     if (numberOfTicketText.isNotEmpty &&
                    //         int.tryParse(numberOfTicketText) != null) {
                    //       ticketCount = int.parse(numberOfTicketText);
                    //     } else {
                    //       ticketCount = 0;
                    //     }
                    //
                    //     Map<String, dynamic> requestData = {
                    //       "data": {
                    //         "name": nameController.text,
                    //         "description": describeController.text,
                    //         "price": costOfTicketController.text,
                    //         "count": ticketCount,
                    //         "isactive": ticketIsActivated,
                    //         "pic": selectedImages
                    //       }
                    //     };
                    //
                    //     Navigator.of(context).pop();
                    //     _updateDataToServer(documentId, requestData);
                    //   }
                    // }
                  },
                  child: (documentId == '')? const Text('ایجاد دسته بندی',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "regular",
                          color: Colors.white)):const Text('ویرایش دسته بندی',
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


  Future<List<GetGalleryDataModel>?> getGalleryFromServer() async {
    setState(() {
      imagesFromGalleryForSelect.clear();
      isImageGetLoading = false;
    });
    try {
      Response response = await dio.get('/upload/files'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به لیست مدل
        List<GetGalleryDataModel> galleryData = (response.data as List)
            .map((item) => GetGalleryDataModel.fromJson(item))
            .toList();

        setState(() {
          isImageGetLoading = true;
        });
        for (var elements in galleryData) {
          imagesFromGalleryForSelect.add(ImageItemList(
              imageId: elements.id.toString(),
              name: elements.name,
              url: elements.url,
              isSelect: false));
        }

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

  void toggleSelection(String id) {
    // بررسی وجود آیتم در لیست
    final existingIndex =
    selectedImages.indexWhere((element) => element["id"] == id);

    if (existingIndex != -1) {
      // اگر آیتم موجود باشد، حذف کن
      selectedImages.removeAt(existingIndex);
    } else {
      // اگر آیتم موجود نباشد، اضافه کن
      selectedImages.add({
        "id": id,
      });
    }
  }



  Future<List<GetServicesDataModel>?> getServicesFromServer() async {


    setState(() {
      serviceFromServicesForSelect.clear();
      isImageGetLoading = false;
    });
    try {
      Response response = await dio.get('/services?populate=*'); // مسیر درخواست
      if (response.statusCode == 200) {
        // تبدیل داده‌های پاسخ به لیست مدل
        final data = response.data['data'] as List<dynamic>;
        List<GetServicesDataModel> galleryData = data
            .map((item) => GetServicesDataModel.fromJson(item))
            .toList();

        setState(() {
          isImageGetLoading = true;
        });

        for (var elements in galleryData) {
          serviceFromServicesForSelect.add(ServicesItemList(
              serviceId: elements.id.toString(),
              serviceName: elements.name,
              imageUrl: elements.pics![0].url,
              isSelect: false));
        }

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



  void toggleSelectionServices(String id) {
    // بررسی وجود آیتم در لیست
    final existingIndex =
    selectedService.indexWhere((element) => element["id"] == id);

    if (existingIndex != -1) {
      // اگر آیتم موجود باشد، حذف کن
      selectedService.removeAt(existingIndex);
    } else {
      // اگر آیتم موجود نباشد، اضافه کن
      selectedService.add({
        "id": id,
      });
    }
  }


}


class ImageItemList {
  String name;
  String imageId;
  String url;
  bool isSelect;

  ImageItemList(
      {required this.name,
        required this.imageId,
        required this.url,
        required this.isSelect});
}


class ServicesItemList {
  String serviceName;
  String serviceId;
  String imageUrl;
  bool isSelect;

  ServicesItemList(
      {required this.serviceName,
        required this.serviceId,
        required this.imageUrl,
        required this.isSelect});
}
