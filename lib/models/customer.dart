import 'package:hive/hive.dart';

part 'customer.g.dart';

@HiveType(typeId: 0)
class Customer extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String membership;

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime endDate;

  @HiveField(6)
  double payment;

  @HiveField(7)
  String note;

  @HiveField(8)
  String? photoPath;


  Customer({
  required this.id,
  required this.name,
  required this.phone,
  required this.membership,
  required this.startDate,
  required this.endDate,
  required this.payment,
  required this.note,
  this.photoPath,
});
}