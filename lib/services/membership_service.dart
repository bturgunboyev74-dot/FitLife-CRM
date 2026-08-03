import 'package:hive/hive.dart';
import '../models/membership.dart';

class MembershipService {
  static Box<Membership> get box =>
      Hive.box<Membership>('memberships');

  static List<Membership> get memberships =>
      box.values.toList();

  static Future<void> addMembership(
      Membership membership) async {
    await box.add(membership);
  }

  static Future<void> updateMembership(
      int index,
      Membership membership) async {
    await box.putAt(index, membership);
  }

  static Future<void> deleteMembership(
      int index) async {
    await box.deleteAt(index);
  }
}