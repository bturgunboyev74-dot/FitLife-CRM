import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/customer.dart';
import 'models/payment.dart';
import 'models/membership.dart';

import 'services/telegram_notification_service.dart';

import 'screens/splash/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CustomerAdapter());
  Hive.registerAdapter(PaymentAdapter());
  Hive.registerAdapter(MembershipAdapter());

  await Hive.openBox<Customer>('customers');
  await Hive.openBox<Payment>('payments');
  await Hive.openBox<Membership>('memberships');

  await TelegramNotificationService().checkExpiringMemberships();

  runApp(const FitLifeCRM());
}

class FitLifeCRM extends StatelessWidget {
  const FitLifeCRM({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitLife CRM',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const SplashPage(),
    );
  }
}