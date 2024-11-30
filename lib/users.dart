import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  List<ServiceItem> items = [
    ServiceItem(
        name: 'کاربر شماره یک', price: '50000', type: 'آموزش غواصی', turn: '5'),
    ServiceItem(
        name: 'کاربر شماره دو', price: '70000', type: 'آموزش غواصی', turn: '4'),
    ServiceItem(
        name: 'کاربر شماره سه', price: '60000', type: 'آموزش غواصی', turn: '6'),
    ServiceItem(
        name: 'کاربر شماره چهار', price: '110000', type: 'آموزش غواصی', turn: '7'),
    ServiceItem(
        name: 'کاربر شماره پنج', price: '20000', type: 'آموزش غواصی', turn: '9'),
  ];

  @override
  Widget build(BuildContext context) {
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
                          margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: (index % 2 == 0)
                                  ? Colors.grey
                                  : Colors.black26,
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
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

                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "regular",
                                          fontSize: 20.0),
                                    ),
                                    Text(
                                      item.turn,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "regular",
                                          fontSize: 20.0),
                                    ),
                                    Text(
                                      '${item.price} تومان',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "regular",
                                          fontSize: 20.0),
                                    ),
                                    Text(
                                      item.type,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "regular",
                                          fontSize: 20.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {},
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem(
                                      value: "Option 2",
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text("حذف",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "medium",
                                                  fontSize: 14.0))),
                                    ),
                                  ];
                                },
                                icon:
                                const Icon(Icons.more_vert), // آیکن سه‌نقطه
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
  }
}


class ServiceItem {
  String name;
  String price;
  String turn;
  String type;

  ServiceItem(
      {required this.name,
        required this.price,
        required this.type,
        required this.turn});
}
