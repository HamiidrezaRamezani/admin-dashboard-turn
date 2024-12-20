import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:turn_rating_launcher/api/data/services/services_api_server.dart';
import 'package:turn_rating_launcher/api/utils/config_network.dart';
import 'api/models/services_to_server_model.dart';
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
  List<OptionServices> optionsForServices = [];

  // لیست برای ذخیره آیتم‌های انتخاب شده
  List<Map<String, String>> selectedImages = [];
  // List<Map<String, String>> selectOptionsForService = [];

  final Dio dio = DioConfig().dio;

  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();
  TextEditingController numberOfTicketController = TextEditingController();
  TextEditingController costOfTicketController = TextEditingController();
  bool ticketIsActivated = false;
  bool isImageGetLoading = false;
  bool isOptionsBoxOpen = false;

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
                                          ? const Color(0xFF007BFF)
                                              .withOpacity(0.2)
                                          : const Color(0xFF007BFF)
                                              .withOpacity(0.1),
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
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "bold",
                                                                fontSize: 16.0),
                                                          ),
                                                          const SizedBox(
                                                            width: 4.0,
                                                          ),
                                                          Text(
                                                            item.name,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "bold",
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
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              // نشان دادن ... در صورت بلند بودن متن
                                                              style: const TextStyle(
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
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "bold",
                                                                fontSize: 16.0),
                                                          ),
                                                          const SizedBox(
                                                            width: 4.0,
                                                          ),
                                                          item.options!.isEmpty?Text(
                                                           formatNumberManually(
                                                                item.basePrice),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "regular",
                                                                fontSize: 16.0),
                                                          ):Row(
                                                            children: [
                                                              Text(
                                                                formatNumberManually(
                                                                    item.options![0].price.toString()),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                    "regular",
                                                                    fontSize: 16.0),
                                                              ),
                                                              Text(
                                                               ' تا ',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                    "regular",
                                                                    fontSize: 16.0),
                                                              ),
                                                              Text(
                                                                formatNumberManually(
                                                                    item.options![1].price.toString()),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                    "regular",
                                                                    fontSize: 16.0),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            width: 4.0,
                                                          ),
                                                          const Text(
                                                            'ریال',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "bold",
                                                                fontSize: 16.0),
                                                          ),
                                                          const SizedBox(
                                                            width: 4.0,
                                                          ),
                                                          Text(
                                                            item.count
                                                                .toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
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
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: (item.isActive ==
                                                                false ||
                                                            item.isActive ==
                                                                null)
                                                        ? Colors.red
                                                        : Colors.green),
                                                child: Center(
                                                  child: Text(
                                                      (item.isActive == false ||
                                                              item.isActive ==
                                                                  null)
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
                                                  optionsForServices.clear();
                                                  setState(() {
                                                    nameController.text = item.name;
                                                    describeController.text = item.description;
                                                    costOfTicketController.text = item.basePrice;
                                                    numberOfTicketController.text = item.count.toString();
                                                    ticketIsActivated = item.isActive!;
                                                    isOptionsBoxOpen = item.options!.isNotEmpty;

                                                  });
                                                  for(var optionsInServer in item.options!){
                                                    optionsForServices.add(OptionServices(name: optionsInServer.name, price: optionsInServer.price));
                                                  }
                                                  addEditItemsDialog(
                                                      item.documentId);
                                                } else if (value == 'delete') {
                                                  _deleteDataToServer(
                                                      item.documentId);
                                                }
                                              },
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return [
                                                  const PopupMenuItem(
                                                    value: "edit",
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text("ویرایش",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  "medium",
                                                              fontSize: 14.0)),
                                                    ),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: "delete",
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text("حذف",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    "medium",
                                                                fontSize:
                                                                    14.0))),
                                                  ),
                                                ];
                                              },
                                              icon: const Icon(Icons
                                                  .more_vert), // آیکن سه‌نقطه
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 24.0,
                                        ),
                                        const Divider(),
                                        const SizedBox(
                                          height: 24.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            for (var imageItem in item.pics!)
                                              Container(
                                                height: 120.0,
                                                width: 120.0,
                                                margin: const EdgeInsets.only(
                                                    left: 12.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ConfigNetwork
                                                            .baseUrlImage +
                                                        imageItem.url,
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
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
            isOptionsBoxOpen = false;
            selectedImages.clear();
            // imagesFromGalleryForSelect.clear();
            optionsForServices.clear();
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
                      // Row(
                      //   children: [
                      //     for(var images in imagesFromGalleryForSelect)
                      //       InkWell(
                      //         onTap: () {
                      //           setState(() {
                      //             images.isSelect = !images.isSelect;
                      //           });
                      //
                      //           final isSelected =
                      //           selectedImages.any((element) =>
                      //           element["id"] == images.imageId);
                      //         },
                      //         child: Container(
                      //             height: 120.0,
                      //             width: 120.0,
                      //             decoration: BoxDecoration(
                      //               border: Border.all(
                      //                   color: (images.isSelect == true)
                      //                       ? Colors.green
                      //                       : Colors.transparent,
                      //                   width: 2.0
                      //               ),
                      //               borderRadius: BorderRadius.circular(12.0),
                      //             ),
                      //             margin: const EdgeInsets.only(left: 12.0),
                      //             child: Stack(
                      //               children: [
                      //                 Align(
                      //                   alignment: Alignment.center,
                      //                   child: ClipRRect(
                      //                     borderRadius: BorderRadius.circular(
                      //                         12.0),
                      //                     child: CachedNetworkImage(
                      //                       imageUrl: ConfigNetwork
                      //                           .baseUrlImage + images.url,
                      //                       placeholder: (context,
                      //                           url) => const CircularProgressIndicator(),
                      //                       errorWidget: (context, url,
                      //                           error) => Icon(Icons.error),
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Align(
                      //                   alignment: Alignment.topRight,
                      //                   child: (images.isSelect == true)
                      //                       ? const Padding(
                      //                     padding: EdgeInsets.all(8.0),
                      //                     child: Icon(Icons.check_box,
                      //                       color: Colors.green,),
                      //                   )
                      //                       : Container(),
                      //                 )
                      //               ],
                      //             )
                      //         ),
                      //       )
                      //   ],
                      // ),
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
                            borderSide: const BorderSide(color: Colors.grey),
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
                      const SizedBox(height: 16),
                      Container(
                          height: 48.0,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'نوع خدمت',
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "regular",
                                      color: Colors.black),
                                ),
                                Switch(
                                  value: isOptionsBoxOpen,
                                  // وضعیت سوئیچ
                                  activeColor: const Color(0xFF628DFF),
                                  onChanged: (bool value) {
                                    setState(() {
                                      isOptionsBoxOpen = !isOptionsBoxOpen;
                                    });
                                    // تغییر وضعیت سوئیچ
                                  },
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 16),
                      Container(
                          height: (isOptionsBoxOpen) ? 200 : 0.0,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: (optionsForServices.isEmpty)
                                    ? const Center(
                                        child: Text(
                                        "آپشنی برای این خدمت وجود ندارد!",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: "medium",
                                            color: Colors.black),
                                      ))
                                    : ListView.builder(
                                        itemCount: optionsForServices.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var item = optionsForServices[index];
                                          return Card(
                                              color: Colors.green,
                                              elevation: 8.0,
                                              child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'نام : ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.0,
                                                                ),
                                                                Text(
                                                                  item.name,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "medium",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  'هزینه : ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.0,
                                                                ),
                                                                Text(
                                                                  item.price.toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "medium",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      PopupMenuButton<String>(
                                                        onSelected: (value) {
                                                          setState(() {
                                                            optionsForServices
                                                                .removeAt(
                                                                    index);
                                                          });
                                                        },
                                                        itemBuilder:
                                                            (BuildContext
                                                                context) {
                                                          return [
                                                            const PopupMenuItem(
                                                              value: "delete",
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Text(
                                                                      "حذف",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontFamily:
                                                                              "medium",
                                                                          fontSize:
                                                                              14.0))),
                                                            ),
                                                          ];
                                                        },
                                                        icon: const Icon(Icons
                                                            .more_vert), // آیکن سه‌نقطه
                                                      ),
                                                    ],
                                                  )));
                                        },
                                      ),
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: InkWell(
                                  onTap: () {
                                    final TextEditingController nameController =
                                        TextEditingController();
                                    final TextEditingController
                                        priceController =
                                        TextEditingController();

                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AlertDialog(
                                            title: const Row(
                                              children: [
                                                Text('ایجاد نوع خدمت',
                                                    style: TextStyle(
                                                        fontSize: 16.0,
                                                        fontFamily: "bold",
                                                        color: Colors.black))
                                              ],
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller: nameController,
                                                  decoration: const InputDecoration(
                                                      labelText: 'نوع خدمت',
                                                      hintText:
                                                          'نوع خدمت خود را وارد کنید',
                                                      hintStyle: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: "regular",
                                                          color: Colors.black),
                                                      labelStyle: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: "regular",
                                                          color: Colors.black)),
                                                ),
                                                const SizedBox(height: 10),
                                                TextField(
                                                  controller: priceController,
                                                  decoration: const InputDecoration(
                                                      labelText: 'قیمت خدمت',
                                                      hintText:
                                                          'قیمت خدمت خود را وارد کنید',
                                                      hintStyle: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: "regular",
                                                          color: Colors.black),
                                                      labelStyle: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: "regular",
                                                          color: Colors.black)),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // بستن دیالوگ
                                                },
                                                child: const Text(
                                                  'لغو',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: "bold",
                                                      color: Colors.black),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (nameController
                                                          .text.isNotEmpty &&
                                                      priceController
                                                          .text.isNotEmpty) {
                                                    setState(() {
                                                      optionsForServices.add(
                                                          OptionServices(
                                                              name:
                                                                  nameController
                                                                      .text,
                                                              price:
                                                                  int.parse(priceController
                                                                      .text))
                                                      );
                                                    });
                                                  }
                                                  Navigator.of(context)
                                                      .pop(); // بستن دیالوگ
                                                },
                                                child: const Text(
                                                  'ایجاد',
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontFamily: "bold",
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 12.0, bottom: 12.0),
                                    height: 36.0,
                                    width: 36.0,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF628DFF)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))
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
                            "base_price": costOfTicketController.text,
                            "count": ticketCount,
                            "isactive": ticketIsActivated,
                            "pic": selectedImages,
                            "options": optionsForServices
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
                            "base_price": costOfTicketController.text,
                            "count": ticketCount,
                            "isactive": ticketIsActivated,
                            "pic": selectedImages,
                            "options": optionsForServices
                          }
                        };

                        Navigator.of(context).pop();
                        _updateDataToServer(documentId, requestData);
                      }
                    }
                  },
                  child: (documentId == '')
                      ? const Text('ایجاد خدمت',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "regular",
                              color: Colors.white))
                      : const Text('ویرایش خدمت',
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

class OptionItemList {
  String name;
  String price;

  OptionItemList({required this.name, required this.price});
}