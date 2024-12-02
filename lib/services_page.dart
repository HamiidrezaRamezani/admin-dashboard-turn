import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turn_rating_launcher/api/data/services/services_api_server.dart';
import 'package:turn_rating_launcher/api/utils/config_network.dart';
import 'api/models/gallery_models/get_gallery_data_model.dart';
import 'api/models/services_models/get_services_model.dart';
import 'api/utils/dio_config.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<ImageItemList> imagesFromGalleryForSelect = [];
  List<ImageItemList> selectedImages = []; // لیست تصاویر انتخاب‌شده


  final Dio dio = DioConfig().dio;

  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  TextEditingController numberOfTicketController = TextEditingController();
  TextEditingController costOfTicketController = TextEditingController();
  bool ticketIsActivated = false;
  bool isImageGetLoading = false;

  late Future<GetServicesModel?> _futureData; // متغیر Future برای FutureBuilder
  final ServicesApiServer _apiServer = ServicesApiServer(); // نمونه کلاس API

  @override
  void initState() {
    super.initState();
    getGalleryFromServer();
    _fetchData(); // مقداردهی اولیه
  }

  // متد برای مقداردهی Future
  void _fetchData() {
    setState(() {
      _futureData = _apiServer.getServicesFromServer(); // فراخوانی درخواست GET
    });
  }

  // متد ارسال داده به سرور و دریافت مجدد داده‌ها
  Future<void> _postDataToServer(Map<String, dynamic> requestData) async {
    loadingDialog();

    try {
      var response = await _apiServer.createServicesToServer(requestData);
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
  Future<void> _deleteDataToServer(String documentId) async {
    loadingDialog();

    try {
      var response = await _apiServer.deleteServicesToServer(documentId);
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
  Future<void> _updateDataToServer(
      String documentId, Map<String, dynamic> requestDataUpdate) async {
    loadingDialog();

    try {
      var response = await _apiServer.updateServicesToServer(
          documentId, requestDataUpdate);
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
      body: FutureBuilder<GetServicesModel?>(
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
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          'خدمات',
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
                    Expanded(
                      child: (items.isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/png/notFound.png',
                                  height: 200.0,
                                  width: 200.0,
                                ),
                                const SizedBox(
                                  height: 36.0,
                                ),
                                const SizedBox(
                                  width: 300.0,
                                  child: Text(
                                    'خدمتی ایجاد نشده است ، لطفا با استفاده از دکمه ایجاد خدمت ، یک خدمت جدید ایجاد کنید.',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "bold",
                                        fontSize: 14.0),
                                  ),
                                )
                              ],
                            )
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = items[index];
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
                                    child: Column(
                                      children: [
                                        Row(
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
                                                                item.name,
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
                                                    const SizedBox(
                                                      width: 24.30,
                                                    ),
                                                    Expanded(
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
                                                                    item.price),
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
                                                                item.count.toString(),
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
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: 42.0,
                                                width: 110.0,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(12.0),
                                                    color: (item.isActive ==
                                                        false ||
                                                        item.isActive == null)
                                                        ? Colors.red
                                                        : Colors.green),
                                                child: Center(
                                                  child: Text(
                                                      (item.isActive == false ||
                                                          item.isActive == null)
                                                          ? 'غیر فعال'
                                                          : 'فعال',
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: "medium",
                                                          fontSize: 14.0)),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 24.0,
                                            ),
                                            PopupMenuButton<String>(
                                              onSelected: (value) {
                                                if (value == 'edit') {
                                                  setState(() {
                                                    nameController.text = item.name;
                                                    describeController.text =
                                                        item.description;
                                                    costOfTicketController.text =
                                                        item.price;
                                                    numberOfTicketController.text =
                                                        item.count.toString();
                                                    ticketIsActivated =
                                                    item.isActive!;
                                                  });
                                                  addEditItemsDialog(
                                                      item.documentId);
                                                } else if (value == 'delete') {
                                                  _deleteDataToServer(
                                                      item.documentId);
                                                }
                                              },
                                              itemBuilder: (BuildContext context) {
                                                return [
                                                  const PopupMenuItem(
                                                    value: "edit",
                                                    child: Align(
                                                      alignment:
                                                      Alignment.centerRight,
                                                      child: Text("ویرایش",
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontFamily: "medium",
                                                              fontSize: 14.0)),
                                                    ),
                                                  ),
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
                                        ),
                                        SizedBox(height: 24.0,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            for(var imageItem in item.pics)
                                              Container(
                                                height: 120.0,
                                                width: 120.0,
                                                margin: EdgeInsets.only(left: 12.0),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(12.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ConfigNetwork.baseUrlImage + imageItem.url,
                                                    placeholder: (context, url) => CircularProgressIndicator(),
                                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                                  ),
                                                ),
                                              )
                                          ],
                                        )
                                      ],
                                    ));
                              },
                            ),
                    )
                  ],
                ));
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            nameController.clear();
            describeController.clear();
            costOfTicketController.clear();
            numberOfTicketController.clear();
            ticketIsActivated = false;
          });

          addEditItemsDialog('');
        },
        label: const Text(
          'ایجاد خدمت',
          style: TextStyle(
              color: Color(0xFFFFFFFF), fontFamily: "bold", fontSize: 16.0),
        ),
        backgroundColor: const Color(0xFF628DFF),
      ),
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
                  Text('ایجاد یک خدمت',
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
                          hintText: 'نام خدمت را وارد کنید',
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
                          hintText: 'توضیحات خدمت را وارد کنید',
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
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //         height: 48.0,
                      //         width: MediaQuery.of(context).size.width * 0.24,
                      //         decoration: BoxDecoration(
                      //             color: const Color(0xFFD9D9D9),
                      //             borderRadius: BorderRadius.circular(12.0)),
                      //         child: Padding(
                      //           padding: const EdgeInsets.only(
                      //               left: 12.0, right: 12.0),
                      //           child: Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //             children: [
                      //               const Text(
                      //                 'انتخاب تصویر',
                      //                 style: TextStyle(
                      //                     fontSize: 14.0,
                      //                     fontFamily: "regular",
                      //                     color: Colors.black),
                      //               ),
                      //               IconButton(
                      //                 icon: const Icon(Icons.attach_file),
                      //                 onPressed: () {},
                      //               ),
                      //             ],
                      //           ),
                      //         )),
                      //   ],
                      // ),
                      const Row(
                        children: [
                          Text('انتخاب تصویر برای خدمت',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "medium",
                                  color: Colors.black))
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          for(var images in imagesFromGalleryForSelect)
                            InkWell(
                              onTap: (){

                                print(images.imageId);
                                setState((){
                                  images.isSelect = !images.isSelect;

                                });

                                // در رابط کاربری:
                                setState(() {
                                  images.isSelect = !images.isSelect; // تغییر وضعیت
                                  toggleSelection(images); // بروزرسانی لیست انتخابی‌ها
                                });





                              },
                              child: Container(
                                height: 120.0,
                                width: 120.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: (images.isSelect == true)?Colors.green:Colors.transparent,
                                    width: 2.0
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                margin: const EdgeInsets.only(left: 12.0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: CachedNetworkImage(
                                          imageUrl: ConfigNetwork.baseUrlImage + images.url,
                                          placeholder: (context, url) => const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: (images.isSelect == true)?const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(Icons.check_box, color: Colors.green,),
                                      ): Container(),
                                    )
                                  ],
                                )
                              ),
                            )
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: costOfTicketController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          // رنگ پس‌زمینه
                          hintText: 'هزینه هر بلیط',
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
                            borderSide:
                            const BorderSide(color: Colors.grey),
                            // حاشیه هنگام فوکوس
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
                            return 'هزینه هر بلیط نباید خالی باشد';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.24,
                            child: TextFormField(
                              controller: numberOfTicketController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // محدود کردن به اعداد
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFD9D9D9),
                                // رنگ پس‌زمینه
                                hintText: 'تعداد بلیط',
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
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  // حاشیه هنگام فوکوس
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
                                  return 'تعداد بلیط نباید خالی باشد';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 24.0,
                          ),
                          Container(
                              height: 48.0,
                              width: MediaQuery.of(context).size.width * 0.24,
                              decoration: BoxDecoration(
                                  color: const Color(0xFFD9D9D9),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12.0, right: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'فعال برای همه',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: "regular",
                                          color: Colors.black),
                                    ),
                                    Switch(
                                      value: ticketIsActivated,
                                      // وضعیت سوئیچ
                                      activeColor: const Color(0xFF628DFF),
                                      onChanged: (bool value) {
                                        setState(() {
                                          ticketIsActivated =
                                              !ticketIsActivated;
                                        });
                                        // تغییر وضعیت سوئیچ
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        ],
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
                    // عملکرد ارسال اطلاعات
                    // _postDataToServer();
                    if (documentId == '') {
                      if (_formKey.currentState!.validate()) {
                        // اگر اعتبارسنجی موفق بود

                        String numberOfTicketText =
                            numberOfTicketController.text;
                        int ticketCount = 0;

                        if (numberOfTicketText.isNotEmpty &&
                            int.tryParse(numberOfTicketText) != null) {
                          ticketCount = int.parse(numberOfTicketText);
                        } else {
                          ticketCount = 0;
                        }

                        Map<String, dynamic> requestData = {
                          "data": {
                            "name": nameController.text,
                            "description": describeController.text,
                            "price": costOfTicketController.text,
                            "count": ticketCount,
                            "isactive": ticketIsActivated,
                            "pic": null
                          }
                        };

                        Navigator.of(context).pop();
                        _postDataToServer(requestData);
                      }
                    } else {
                      if (_formKey.currentState!.validate()) {
                        // اگر اعتبارسنجی موفق بود

                        String numberOfTicketText =
                            numberOfTicketController.text;
                        int ticketCount = 0;

                        if (numberOfTicketText.isNotEmpty &&
                            int.tryParse(numberOfTicketText) != null) {
                          ticketCount = int.parse(numberOfTicketText);
                        } else {
                          ticketCount = 0;
                        }

                        Map<String, dynamic> requestData = {
                          "data": {
                            "name": nameController.text,
                            "description": describeController.text,
                            "price": costOfTicketController.text,
                            "count": ticketCount,
                            "isactive": ticketIsActivated,
                            "pic": null
                          }
                        };

                        Navigator.of(context).pop();
                        _updateDataToServer(documentId, requestData);
                      }
                    }
                  },
                  child: const Text('ایجاد خدمت',
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
              isSelect : false
          ));
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


  // مدیریت وضعیت انتخاب
  void toggleSelection(ImageItemList image) {
    if (image.isSelect) {
      if (!selectedImages.any((selectedImage) => selectedImage.imageId == image.imageId)) {
        selectedImages.add(image);
      }
    } else {
      selectedImages.removeWhere((selectedImage) => selectedImage.imageId == image.imageId);
    }
  }



}

class ImageItemList {
  String name;
  String imageId;
  String url;
  bool isSelect;

  ImageItemList({required this.name, required this.imageId, required this.url, required this.isSelect});
}
