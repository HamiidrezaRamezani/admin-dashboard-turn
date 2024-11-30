import 'package:flutter/material.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Row(
              children: [
                Text(
                  'گزارشات',
                  style: TextStyle(
                      color: Colors.black, fontFamily: "bold", fontSize: 30.0),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                        color: Color(0xFF628DFF),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: const Padding(padding: EdgeInsets.all(24.0), child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text('15', style: TextStyle(
                              fontFamily: "bold",
                              fontSize: 56.0,
                              color: Colors.white
                            ),),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text('بلیط های گرفته شده', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                          )
                        ],
                      ),),
                    ),
                  ),
                  const SizedBox(
                    width: 36.0,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                          color: Color(0xFF58fcec),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: const Padding(padding: EdgeInsets.all(24.0), child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text('36', style: TextStyle(
                                fontFamily: "bold",
                                fontSize: 56.0,
                                color: Colors.white
                            ),),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text('کاربران ثبت نام شده', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                          )
                        ],
                      ),),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 36.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36.0, right: 36.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                          color: Color(0xFF303A2B),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: const Padding(padding: EdgeInsets.all(24.0), child: Column(
                        children: [
                          Row(
                            children: [
                              Text('خدمات پر استفاده', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 14.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('آموزش غواصی 100', style: TextStyle(fontSize: 12.0, fontFamily: "regular", color: Colors.white),),
                              Text('پدل 100', style: TextStyle(fontSize: 12.0, fontFamily: "regular", color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 12.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('شاتل سواری 100', style: TextStyle(fontSize: 12.0, fontFamily: "regular", color: Colors.white),),
                              Text('اسکی روی آب 50', style: TextStyle(fontSize: 12.0, fontFamily: "regular", color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: 12.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('بنانا سواری 250', style: TextStyle(fontSize: 12.0, fontFamily: "regular", color: Colors.white),),
                            ],
                          )
                        ],
                      ),),
                    ),
                  ),
                  const SizedBox(
                    width: 36.0,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFF99C9),
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: const Padding(padding: EdgeInsets.all(24.0), child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text('500.000', style: TextStyle(
                                fontFamily: "bold",
                                fontSize: 56.0,
                                color: Colors.white
                            ),),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text('کل پرداختی', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text('تومان', style: TextStyle(fontSize: 16.0, fontFamily: "regular", color: Colors.white),),
                          )
                        ],
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
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
