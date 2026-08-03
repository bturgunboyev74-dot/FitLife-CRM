import 'package:hive/hive.dart';

part 'membership.g.dart';

@HiveType(typeId: 2)
class Membership extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int months;

  @HiveField(2)
  double price;

  Membership({
    required this.name,
    required this.months,
    required this.price,
  });
}