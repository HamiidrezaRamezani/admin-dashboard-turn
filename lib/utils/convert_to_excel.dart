import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;

import '../api/models/users_models/get_users_data_model.dart';

Future<void> createExcelWithDataAllUsers(List<GetAllUserDataModel> users) async {
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


Future<void> createExcelWithDataRegisteredUsers(List<GetRegisteredUserDataModel> users) async {
  final Workbook workbook = Workbook();
  final Worksheet sheet = workbook.worksheets[0];

  // اضافه کردن سرستون‌ها
  sheet.getRangeByName('A1').setText("ID");
  sheet.getRangeByName('B1').setText("Name");
  sheet.getRangeByName('C1').setText("Username");
  sheet.getRangeByName('D1').setText("Total Amount Spent");
  sheet.getRangeByName('E1').setText("Total Ticket");
  sheet.getRangeByName('F1').setText("National Code");
  sheet.getRangeByName('G1').setText("Services");

  // اضافه کردن داده‌های کاربران
  for (int i = 0; i < users.length; i++) {
    final rowIndex =
        i + 2; // از ردیف دوم شروع می‌کنیم چون ردیف اول برای سرستون است
    sheet.getRangeByName('A$rowIndex').setNumber(users[i].id.toDouble());
    sheet.getRangeByName('B$rowIndex').setText(users[i].name);
    sheet.getRangeByName('C$rowIndex').setText(users[i].username);
    sheet.getRangeByName('D$rowIndex').setText(users[i].totalAmountSpent.toString());
    sheet.getRangeByName('E$rowIndex').setText(users[i].totalTickets.toString());
    sheet.getRangeByName('F$rowIndex').setText(users[i].nationalCode);
    sheet.getRangeByName('G$rowIndex').setText(users[i].serviceListString);
  }

  // ذخیره فایل
  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  if (kIsWeb) {
    final String base64Data = base64.encode(bytes);
    final String href = 'data:application/octet-stream;base64,$base64Data';
    AnchorElement(href: href)
      ..setAttribute('download', 'UserDataRegistered.xlsx')
      ..click();
  } else {
    final Directory directory = await getApplicationSupportDirectory();
    final String path = directory.path;
    final String fileName = '$path/UserDataRegistered.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    OpenFile.open(fileName);
  }
}