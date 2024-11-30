import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:turn_rating_launcher/api/data/services/gallery_api_server.dart';
import 'package:turn_rating_launcher/api/models/gallery_models/get_gallery_data_model.dart';

import 'api/utils/config_network.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late Future<List<GetGalleryDataModel?>> _futureData;
  final GalleryApiServer _apiServer = GalleryApiServer(); // نمونه کلاس API

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
  }

  Future<List<GetGalleryDataModel?>> _fetchData() async {
    try {
      return await _apiServer.getGalleryFromServer() ?? [];
    } catch (e) {
      return [];
    }
  }

  Future<void> _deleteDataToServer(int documentId) async {
    loadingDialog(); // نمایش دیالوگ لودینگ

    try {
      var response =
          await _apiServer.deleteGalleryToServer(documentId.toString());
      if (response == true) {
        print('Data deleted successfully');
        // پس از موفقیت، داده‌ها را مجدد دریافت کنید
        setState(() {
          // به روز رسانی _futureData با داده‌های جدید
          _futureData = _fetchData(); // اینجا متغیر Future را به روز می‌کنید
        });
      } else {
        print("Delete request failed.");
      }
    } catch (e) {
      print("Error deleting data: $e");
    } finally {
      // بستن دیالوگ لودینگ
      if (mounted) Navigator.of(context).pop();
    }
  }

  Future<void> _pickImage() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // فقط فایل‌های تصویری انتخاب شوند
      allowMultiple: false, // اجازه انتخاب چند تصویر را نمی‌دهیم
    );

    if (result != null) {
      // گرفتن داده‌های بایت از فایل انتخاب‌شده
      Uint8List? fileBytes = result.files.single.bytes;
      String fileName = result.files.single.name;

      if (fileBytes != null) {
        loadingDialog(); // نمایش دیالوگ لودینگ
        // ارسال فایل به سرور
        bool? uploadSuccess = await _apiServer.uploadFile(fileBytes, fileName);

        if (uploadSuccess!) {
          print('File uploaded successfully.');

          setState(() {
            // به روز رسانی _futureData با داده‌های جدید
            _futureData = _fetchData(); // اینجا متغیر Future را به روز می‌کنید
          });
          if (mounted) Navigator.of(context).pop();
        } else {
          print('File upload failed.');
        }
      } else {
        print('No file bytes found.');
      }
    } else {
      print('No file selected.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GetGalleryDataModel?>>(
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
          final items = snapshot.data!;
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Row(
                    children: [
                      Text(
                        'گالری تصاویر',
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
                  (snapshot.data!.isEmpty)
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  'assets/images/png/galleryNotFound.png'),
                              const SizedBox(
                                height: 24.0,
                              ),
                              InkWell(
                                onTap: (){
                                  _pickImage();
                                },
                                child: Container(
                                  height: 56.0,
                                  width: 130.0,
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF628DFF),
                                      borderRadius: BorderRadius.circular(12.0)),
                                  child: const Center(
                                    child: Text(
                                      'بارگزاری فایل',
                                      style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontFamily: "bold",
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : LayoutBuilder(
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
                                            ConfigNetwork.baseUrlImage + item!.url,
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
                                              _deleteDataToServer(item.id);
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
            ),
            floatingActionButton: (items.isEmpty)? Container():FloatingActionButton.extended(
              onPressed: () {
                _pickImage();
              },
              label: const Text(
                'بارگزاری فایل',
                style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontFamily: "bold",
                    fontSize: 16.0),
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
