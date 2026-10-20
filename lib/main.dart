import 'package:finpay/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // final storage = GetStorage();
  // await storage.remove('walletBalance');
  // await storage.remove('transactions');
  runApp(const FinPayApp());
}
