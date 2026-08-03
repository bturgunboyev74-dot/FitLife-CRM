import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId: 1)
class Payment extends HiveObject {
  @HiveField(0)
  String customerId;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String method;

  @HiveField(4)
  String note;

  Payment({
    required this.customerId,
    required this.amount,
    required this.date,
    required this.method,
    required this.note,
  });
}