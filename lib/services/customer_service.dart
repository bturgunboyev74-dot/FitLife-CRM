import 'package:hive/hive.dart';

import '../models/customer.dart';

class CustomerService {
  static Box<Customer> get box =>
      Hive.box<Customer>('customers');

  static List<Customer> get customers =>
      box.values.toList();

  static Future<void> addCustomer(Customer customer) async {
    await box.add(customer);
  }

  static Future<void> deleteCustomer(int index) async {
    await box.deleteAt(index);
  }

  static Future<void> updateCustomer(
    int index,
    Customer customer,
  ) async {
    await box.putAt(index, customer);
  }

  static Customer? getCustomerById(String id) {
    try {
      return customers.firstWhere(
        (customer) => customer.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}