import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:turn_rating_launcher/utils/convert_to_excel.dart';
import 'api/data/services/payment_group_api_server.dart';
import 'api/data/services/users_api_server.dart';
import 'api/models/payment_group_models/get_payment_group_model.dart';
import 'api/models/users_models/get_users_data_model.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> with SingleTickerProviderStateMixin {
  late Future<List<GetRegisteredUserDataModel?>> _futureDataUsers;
  late Future<List<GetAllUserDataModel?>> _futureDataAllUsers;

  late Future<GetPaymentGroupModel?>
      _getPaymentItems; // متغیر Future برای FutureBuilder

  final UsersApiServer _apiServer = UsersApiServer(); // نمونه کلاس API
  final PaymentGroupApiServer _apiPaymentServer =
      PaymentGroupApiServer(); // نمونه کلاس API

  // لیست آیتم‌ها (این لیست از سرور دریافت می‌شود)
  final List<DropdownItem> _items = [];

  // ذخیره آیتم انتخاب‌شده
  DropdownItem? _selectedItem;

  // متد برای مقداردهی Future
  void _fetchPayment() {
    setState(() {
      _getPaymentItems =
          _apiPaymentServer.getPaymentGroupFromServer(); // فراخوانی درخواست GET
    });
  }

  late TabController tabController;

  List<GetAllUserDataModel> itemsForGetExcel = [];
  List<GetRegisteredUserDataModel> itemsRegisteredForGetExcel = [];

  @override
  void initState() {
    super.initState();
    _futureDataUsers = _fetchRegisteredUsersData('');
    _futureDataAllUsers = _fetchDataAllUser();
    tabController = TabController(length: 2, vsync: this);
    _fetchPayment();
  }

  Future<List<GetRegisteredUserDataModel?>> _fetchRegisteredUsersData(
      String paymentGroupId) async {
    try {
      return await _apiServer.getRegisteredUsersFromServer(paymentGroupId) ??
          [];
    } catch (e) {
      return [];
    }
  }

  Future<List<GetAllUserDataModel?>> _fetchDataAllUser() async {
    try {
      return await _apiServer.getAllUsersFromServer() ?? [];
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
          _futureDataUsers = _fetchRegisteredUsersData(
              ''); // اینجا متغیر Future را به روز می‌کنید
          _futureDataAllUsers = _fetchDataAllUser();
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'کاربران',
              style: TextStyle(
                  color: Colors.black, fontFamily: "bold", fontSize: 30.0),
            ),
            bottom: TabBar(
              controller: tabController,
              labelStyle: const TextStyle(
                  color: Colors.black, fontFamily: "medium", fontSize: 16.0),
              tabs: const [
                Tab(text: 'کل کاربران'),
                Tab(text: 'کاربران ثبت نام شده'),
              ],
            ),
          ),
          body: TabBarView(controller: tabController, children: [
            Expanded(
              flex: 4,
              child: FutureBuilder<List<GetAllUserDataModel?>>(
                  future: _futureDataAllUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      itemsForGetExcel.clear();
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData && snapshot.data != null) {
                      final items = snapshot.data!;
                      for (var element in items) {
                        itemsForGetExcel.add(GetAllUserDataModel(
                          id: element!.id,
                          name: element.name,
                          username: element.username,
                          email: element.email,
                          phoneNumber: element.phoneNumber,
                          nationalCode: element.nationalCode,
                          blocked: element.blocked,
                          confirmed: element.confirmed,
                          documentId: element.documentId,
                          provider: element.provider,
                          publishedAt: element.publishedAt,
                          updatedAt: element.updatedAt,
                          createdAt: element.createdAt,
                        ));
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
                                              width: 24.0,
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'کد ملی : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "bold",
                                                            fontSize: 16.0),
                                                      ),
                                                      const SizedBox(
                                                        width: 4.0,
                                                      ),
                                                      Text(
                                                        (item.nationalCode ==
                                                                null)
                                                            ? 'ندارد'
                                                            : item
                                                                .nationalCode!,
                                                        // formatNumberManually(
                                                        //     item.price),
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
                                                        'شماره تلفن : ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily: "bold",
                                                            fontSize: 16.0),
                                                      ),
                                                      const SizedBox(
                                                        width: 4.0,
                                                      ),
                                                      Text(
                                                        (item.nationalCode ==
                                                                null)
                                                            ? 'ندارد'
                                                            : item
                                                                .nationalCode!,
                                                        // formatNumberManually(
                                                        //     item.price),
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
                              }));
                    } else {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                  }),
            ),
            Expanded(
                flex: 4,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'برای نمایش کاربران بر اساس نوع پرداخت لطفا از فیلتر مد نظر استفاده کنید!',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "bold",
                                  fontSize: 16.0),
                            ),
                            FutureBuilder<GetPaymentGroupModel?>(
                                future: _getPaymentItems,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    _items.clear();
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                      child: Text('Error ${snapshot.error}'),
                                    );
                                  } else if (snapshot.hasData &&
                                      snapshot.data != null) {
                                    if (_items.isEmpty) {
                                      // فقط زمانی که لیست خالی است، آن را پر می‌کنیم
                                      final items = snapshot.data!.data;
                                      for (var element in items) {
                                        print(element.name);
                                        _items.add(DropdownItem(
                                          id: element.id.toString(),
                                          name: element.name,
                                        ));
                                      }
                                    }
                                    return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Container(
                                          height: 46.0,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF007BFF)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(8.0))),
                                          child: _items.isEmpty
                                              ? const CircularProgressIndicator() // در حال بارگذاری
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: DropdownButton<
                                                      DropdownItem>(
                                                    hint: const Text(
                                                        'یک گزینه انتخاب کنید'),
                                                    value: _selectedItem,
                                                    onChanged: (DropdownItem?
                                                        newValue) {
                                                      setState(() {
                                                        _selectedItem =
                                                            newValue;
                                                      });

                                                      // چاپ ID یونیک آیتم انتخاب‌شده
                                                      if (newValue != null) {
                                                        print(
                                                            'Selected Item: ${newValue.name}');
                                                        print(
                                                            'Unique ID: ${newValue.id}');
                                                        _futureDataUsers =
                                                            _fetchRegisteredUsersData(
                                                                newValue.id);
                                                      }
                                                    },
                                                    items: _items.map(
                                                        (DropdownItem item) {
                                                      return DropdownMenuItem<
                                                          DropdownItem>(
                                                        value: item,
                                                        child: Text(item.name),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                        ));
                                  } else {
                                    return const Center(
                                      child: Text('No data available'),
                                    );
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                    FutureBuilder<List<GetRegisteredUserDataModel?>>(
                        future: _futureDataUsers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            itemsRegisteredForGetExcel.clear();
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error ${snapshot.error}'),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data != null) {
                            final items = snapshot.data!;
                            for (var element in items) {
                              itemsRegisteredForGetExcel.add(
                                  GetRegisteredUserDataModel(
                                      id: element!.id,
                                      documentId: element.documentId,
                                      username: element.username,
                                      email: element.email,
                                      provider: element.provider,
                                      password: element.password,
                                      confirmed: element.confirmed,
                                      blocked: element.blocked,
                                      createdAt: element.createdAt,
                                      updatedAt: element.updatedAt,
                                      publishedAt: element.publishedAt,
                                      totalTickets: element.totalTickets,
                                      totalAmountSpent:
                                          element.totalAmountSpent,
                                      serviceListString:
                                          element.serviceListString));
                            }
                            return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: (items.isEmpty)
                                    ? const Center(
                                        child: SizedBox(
                                          height: 120.0,
                                          child: Column(
                                            children: [
                                              Text(
                                                "کاربری در این گروه موجود نیست!",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: "medium",
                                                    fontSize: 16.0),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        itemCount: items.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var item = items[index];
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  top: 8.0, bottom: 8.0),
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                color: (index % 2 == 0)
                                                    ? const Color(0xFF007BFF)
                                                        .withOpacity(0.2)
                                                    : const Color(0xFF007BFF)
                                                        .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
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
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                Text(
                                                                  (item!.name ==
                                                                          null)
                                                                      ? 'ندارد'
                                                                      : item
                                                                          .name!,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "regular",
                                                                      fontSize:
                                                                          16.0),
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
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
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
                                                                  'کل پرداختی : ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                Text(
                                                                  formatNumberManually(item
                                                                      .totalAmountSpent
                                                                      .toString()),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "regular",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                const Text(
                                                                  'تومان',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "regular",
                                                                      fontSize:
                                                                          16.0),
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
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                Text(
                                                                  item.totalTickets
                                                                      .toString(),
                                                                  // '12',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "regular",
                                                                      fontSize:
                                                                          16.0),
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
                                                                  'کد ملی : ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                Text(
                                                                  (item.nationalCode ==
                                                                          null)
                                                                      ? 'ندارد'
                                                                      : item
                                                                          .nationalCode!,
                                                                  // formatNumberManually(
                                                                  //     item.price),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "regular",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 24.0,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
                                                                  'شماره تلفن : ',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "bold",
                                                                      fontSize:
                                                                          16.0),
                                                                ),
                                                                const SizedBox(
                                                                  width: 4.0,
                                                                ),
                                                                Text(
                                                                  (item.nationalCode ==
                                                                          null)
                                                                      ? 'ندارد'
                                                                      : item
                                                                          .nationalCode!,
                                                                  // formatNumberManually(
                                                                  //     item.price),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "regular",
                                                                      fontSize:
                                                                          16.0),
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
                                                      _deleteDataToServer(
                                                          item.id);
                                                    },
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return [
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
                                              ));
                                        }));
                          } else {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }
                        }),
                  ],
                )),
            // Padding(
            //   padding: EdgeInsets.only(left: 16.0, right: 16.0),
            //   child: ListView(
            //     shrinkWrap: true,
            //     children: [
            //       const SizedBox(
            //         height: 24.0,
            //       ),
            //       const Row(
            //         children: [
            //           Text(
            //             'کل کاربران',
            //             style: TextStyle(
            //                 color: Colors.black, fontFamily: "bold", fontSize: 30.0),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(
            //         height: 24.0,
            //       ),
            //
            //       const SizedBox(
            //         height: 24.0,
            //       ),
            //       const Row(
            //         children: [
            //           Text(
            //             'کاربران ثبت نام شده',
            //             style: TextStyle(
            //                 color: Colors.black, fontFamily: "bold", fontSize: 30.0),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(
            //         height: 24.0,
            //       ),
            //
            //     ],
            //   ),
            // ),
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              print(tabController.index);
              if (tabController.index == 0) {
                await createExcelWithDataAllUsers(itemsForGetExcel);
              } else {
                await createExcelWithDataRegisteredUsers(
                    itemsRegisteredForGetExcel);
              }
            },
            label: const Text(
              'دریافت فایل Excel',
              style: TextStyle(
                  color: Color(0xFFFFFFFF), fontFamily: "bold", fontSize: 16.0),
            ),
            backgroundColor: const Color(0xFF628DFF),
          ),
        ));
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

  List<GetAllUserDataModel> parseUserData(String jsonResponse) {
    final List<dynamic> data = jsonDecode(jsonResponse);
    return data.map((json) => GetAllUserDataModel.fromJson(json)).toList();
  }
}

// مدل آیتم‌ها
class DropdownItem {
  final String id;
  final String name;

  DropdownItem({required this.id, required this.name});
}
