import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  List<ServiceItem> items = [
    ServiceItem(
        name: 'خدمت شماره یک', price: '50000', isActivated: false, turn: '5'),
    ServiceItem(
        name: 'خدمت شماره دو', price: '70000', isActivated: true, turn: '4'),
    ServiceItem(
        name: 'خدمت شماره سه', price: '60000', isActivated: false, turn: '6'),
    ServiceItem(
        name: 'خدمت شماره چهار', price: '110000', isActivated: true, turn: '7'),
    ServiceItem(
        name: 'خدمت شماره پنج', price: '20000', isActivated: false, turn: '9'),
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
                  'خدمات',
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
                                      '${item.price} تومان',
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
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          item.isActivated = !item.isActivated;
                                        });
                                      },
                                      child: Container(
                                        height: 42.0,
                                        width: 110.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            color: (item.isActivated == true)
                                                ? Colors.red
                                                : Colors.green),
                                        child: Center(
                                          child: Text(
                                              (item.isActivated == true)
                                                  ? 'غیرفعال سازی'
                                                  : 'فعال سازی',
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "medium",
                                                  fontSize: 14.0)),
                                        ),
                                      ),
                                    )
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
                                      value: "Option 1",
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("ویرایش",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "medium",
                                                fontSize: 14.0)),
                                      ),
                                    ),
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
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ایجاد یک خدمت'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('نام خدمت'),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'نام خدمت را وارد کنید',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('توضیحات'),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'توضیحات را وارد کنید',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('انتخاب تصویر'),
                      Row(
                        children: [
                          Icon(Icons.image),
                          TextButton(
                            onPressed: () {
                              // عملکرد انتخاب تصویر
                            },
                            child: Text('انتخاب تصویر'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Switch(
                            value: true, // وضعیت سوئیچ
                            onChanged: (bool value) {
                              // تغییر وضعیت سوئیچ
                            },
                          ),
                          Text('فعال برای همه')
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('هزینه هر لینک'),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'هزینه را وارد کنید',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('لغو'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // عملکرد ارسال اطلاعات
                    },
                    child: Text('ایجاد خدمت'),
                  ),
                ],
              );
            },
          );
        },
        label: const Text(
          'ایجاد خدمت',
          style: TextStyle(
              color: Color(0xFFFFFFFF), fontFamily: "bold", fontSize: 20.0),
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
  bool isActivated;

  ServiceItem(
      {required this.name,
      required this.price,
      required this.isActivated,
      required this.turn});
}
