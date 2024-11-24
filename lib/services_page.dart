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
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  title: const Row(
                    children: [
                      Text('ایجاد یک خدمت', style: TextStyle(fontSize: 16.0, fontFamily: "bold", color: Colors.black))
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 56.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: 'نام خدمت را وارد کنید',
                                hintStyle: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Colors.grey),
                                border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0)
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 156.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: TextField(
                            maxLines: 5,
                            decoration: InputDecoration(
                                hintText: 'توضیحات خدمت را وارد کنید',
                                hintStyle: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0)
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          height: 56.0,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('انتخاب تصویر', style: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Colors.black),),
                                IconButton(icon: Icon(Icons.attach_file),onPressed: (){},),
                              ],
                            ),
                          )
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 56.0,
                                width: MediaQuery.of(context).size.width * 0.24,
                                decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                  child: TextField(
                                    decoration: InputDecoration(
                                        hintText: 'هزینه هر بلیط',
                                        hintStyle: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Colors.grey),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0)
                                    ),
                                  ),
                                )
                            ),
                            Container(
                                height: 56.0,
                                width: MediaQuery.of(context).size.width * 0.24,
                                decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('فعال برای همه', style: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Colors.black),),
                                      Switch(
                                        value: true, // وضعیت سوئیچ
                                        activeColor: Color(0xFF628DFF),
                                        onChanged: (bool value) {
                                          // تغییر وضعیت سوئیچ
                                        },
                                      ),

                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF628DFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)
                        )
                      ),
                      onPressed: () {
                        // عملکرد ارسال اطلاعات
                      },
                      child: Text('ایجاد خدمت',  style: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Colors.white)),
                    ),
                    TextButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(color: Color(0xFF628DFF), width: 1.0)
                          )
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('لغو', style: TextStyle(fontSize: 14.0, fontFamily: "regular", color: Color(0xFF628DFF))),
                    ),
                  ],
                ),
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
