import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class ConvertToExcel extends StatefulWidget {
  const ConvertToExcel({super.key});

  @override
  State<ConvertToExcel> createState() => _ConvertToExcelState();
}

class _ConvertToExcelState extends State<ConvertToExcel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              const String jsonResponse = '''
  [
    {
        "id": 2,
        "documentId": "l9p797nw6i2vivdfvg3y5eqn",
        "username": "09155621944",
        "email": "e09155621944@aa.com",
        "provider": null,
        "confirmed": true,
        "blocked": false,
        "createdAt": "2024-12-03T07:20:20.729Z",
        "updatedAt": "2024-12-03T07:20:20.729Z",
        "publishedAt": "2024-12-03T07:20:20.730Z",
        "name": "saeed1111",
        "national_code": "0651973724",
        "phone_number": "09155621944"
    },
    {
        "id": 4,
        "documentId": "vaecbk8uutz2b8uvn78r0ggo",
        "username": "09399962215",
        "email": "e09399962215@aa.com",
        "provider": null,
        "confirmed": true,
        "blocked": false,
        "createdAt": "2024-12-03T07:52:02.563Z",
        "updatedAt": "2024-12-03T07:52:02.563Z",
        "publishedAt": "2024-12-03T07:52:02.564Z",
        "name": "hamidreza",
        "national_code": "0925155365",
        "phone_number": "09399962215"
    },
    {
        "id": 6,
        "documentId": "uc1mt5jmn1fzrlufnltbuich",
        "username": "09362487893",
        "email": "e09362487893@aa.com",
        "provider": null,
        "confirmed": true,
        "blocked": false,
        "createdAt": "2024-12-03T08:30:33.859Z",
        "updatedAt": "2024-12-03T08:30:33.859Z",
        "publishedAt": "2024-12-03T08:30:33.861Z",
        "name": "خخخخخ",
        "national_code": "0924815957",
        "phone_number": "09362487893"
    },
    {
        "id": 7,
        "documentId": "recg01a2ljxx9r24kjfpv94m",
        "username": "09361296422",
        "email": "e09361296422@aa.com",
        "provider": null,
        "confirmed": true,
        "blocked": false,
        "createdAt": "2024-12-03T12:31:31.072Z",
        "updatedAt": "2024-12-03T12:31:31.072Z",
        "publishedAt": "2024-12-03T12:31:31.074Z",
        "name": "خشایار   ",
        "national_code": "2921957807",
        "phone_number": "09361296422"
    }
]
  
  ''';

              // تبدیل JSON به مدل
              final List<UserData> users = parseUserData(jsonResponse);

              // ایجاد اکسل
              await createExcelWithData(users);
            },
            child: Text("create")),
      ),
    );
  }

  List<UserData> parseUserData(String jsonResponse) {
    final List<dynamic> data = jsonDecode(jsonResponse);
    return data.map((json) => UserData.fromJson(json)).toList();
  }

  // Future<void> _createExcel() async {
  //   // Create a new Excel document
  //   final Workbook workbook = Workbook();
  //   final Worksheet sheet = workbook.worksheets[0];
  //
  //   // Add some text to the first cell
  //   sheet.getRangeByName('A1').setText("Hello Flutter Excel");
  //
  //   // Save the document to a list of bytes
  //   final List<int> bytes = workbook.saveAsStream();
  //
  //   // Dispose of the workbook to release resources
  //   workbook.dispose();
  //
  //   if (kIsWeb) {
  //     // Handle Excel file creation in the web environment
  //     final String base64Data = base64.encode(bytes);
  //     final String href = 'data:application/octet-stream;base64,$base64Data';
  //
  //     // Create a download link
  //     AnchorElement(href: href)
  //       ..setAttribute('download', 'CreateExcel.xlsx')
  //       ..click();
  //   } else {
  //     // Handle Excel file creation on Windows
  //     try {
  //       final Directory directory = await getApplicationSupportDirectory();
  //       final String path = directory.path;
  //       final String fileName = '$path/CreateExcel.xlsx';
  //       final File file = File(fileName);
  //
  //       // Write bytes to the file
  //       await file.writeAsBytes(bytes, flush: true);
  //
  //       // Open the file
  //       OpenFile.open(fileName);
  //     } catch (e) {
  //       debugPrint('Error saving Excel file: $e');
  //     }
  //   }
  // }

  Future<void> createExcelWithData(List<UserData> users) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // اضافه کردن سرستون‌ها
    sheet.getRangeByName('A1').setText("ID");
    sheet.getRangeByName('B1').setText("Name");
    sheet.getRangeByName('C1').setText("Username");
    sheet.getRangeByName('D1').setText("Email");
    sheet.getRangeByName('E1').setText("Phone Number");
    sheet.getRangeByName('F1').setText("National Code");
    sheet.getRangeByName('G1').setText("Created At");

    // اضافه کردن داده‌های کاربران
    for (int i = 0; i < users.length; i++) {
      final rowIndex =
          i + 2; // از ردیف دوم شروع می‌کنیم چون ردیف اول برای سرستون است
      sheet.getRangeByName('A$rowIndex').setNumber(users[i].id.toDouble());
      sheet.getRangeByName('B$rowIndex').setText(users[i].name);
      sheet.getRangeByName('C$rowIndex').setText(users[i].username);
      sheet.getRangeByName('D$rowIndex').setText(users[i].email);
      sheet.getRangeByName('E$rowIndex').setText(users[i].phoneNumber);
      sheet.getRangeByName('F$rowIndex').setText(users[i].nationalCode);
      sheet.getRangeByName('G$rowIndex').setText(users[i].createdAt);
    }

    // ذخیره فایل
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      final String base64Data = base64.encode(bytes);
      final String href = 'data:application/octet-stream;base64,$base64Data';
      AnchorElement(href: href)
        ..setAttribute('download', 'UserData.xlsx')
        ..click();
    } else {
      final Directory directory = await getApplicationSupportDirectory();
      final String path = directory.path;
      final String fileName = '$path/UserData.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}

class UserData {
  final int id;
  final String documentId;
  final String username;
  final String email;
  final bool confirmed;
  final bool blocked;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String name;
  final String nationalCode;
  final String phoneNumber;

  UserData({
    required this.id,
    required this.documentId,
    required this.username,
    required this.email,
    required this.confirmed,
    required this.blocked,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    required this.name,
    required this.nationalCode,
    required this.phoneNumber,
  });

  // Factory method for creating an instance from JSON
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      documentId: json['documentId'],
      username: json['username'],
      email: json['email'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      name: json['name'],
      nationalCode: json['national_code'],
      phoneNumber: json['phone_number'],
    );
  }
}
