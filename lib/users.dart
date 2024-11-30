import 'package:flutter/material.dart';

import 'api/data/services/users_api_server.dart';
import 'api/models/users_models/get_users_data_model.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {

  late Future<List<GetUserDataModel?>> _futureData;
  final UsersApiServer _apiServer = UsersApiServer(); // نمونه کلاس API

  @override
  void initState() {
    super.initState();
    _futureData = _fetchData();
  }

  Future<List<GetUserDataModel?>> _fetchData() async {
    try {
      return await _apiServer.getUsersFromServer() ?? [];
    } catch (e) {
      return [];
    }
  }


  Future<void> _deleteDataToServer(int documentId) async {
    loadingDialog(); // نمایش دیالوگ لودینگ

    try {
      var response =
      await _apiServer.deleteUsersToServer(documentId.toString());
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



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GetUserDataModel?>>(future: _futureData, builder: (context, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }else if(snapshot.hasError){
        return Center(
          child: Text('Error ${snapshot.error}'),
        );
      }else if(snapshot.hasData && snapshot.data != null){
        final items = snapshot.data!;
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  children: [
                    Text(
                      'کاربران',
                      style: TextStyle(
                          color: Colors.black, fontFamily: "bold", fontSize: 30.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = items[index];
                          return Container(
                              margin: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: (index % 2 == 0)
                                    ? const Color(0xFFBBBBBB)
                                    : const Color(0xFFD9D9D9),
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
                                                      'نام کاربر : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "bold",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Text(
                                                      item!.username,
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
                                                      'ایمیل کاربر : ',
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
                                                        item.email,
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
                                                      'کل پرداختی : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily: "bold",
                                                          fontSize: 16.0),
                                                    ),
                                                    const SizedBox(
                                                      width: 4.0,
                                                    ),
                                                    Text(
                                                      '121212',
                                                      // formatNumberManually(
                                                      //     item.price),
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
                                                      // item.count.toString(),
                                                      '12',
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
                                  PopupMenuButton<String>(
                                    onSelected: (value) {
                                      _deleteDataToServer(item.id);
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
                        })),
                const SizedBox(
                  height: 36.0,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
            },
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
    });
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
