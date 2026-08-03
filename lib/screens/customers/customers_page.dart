import 'package:flutter/material.dart';

import '../../services/customer_service.dart';
import '../../widgets/customer_card.dart';
import 'add_customer_page.dart';
import 'edit_customer_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
    
    String _search = "";

  Future<void> _openAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddCustomerPage(),
      ),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
final customers = CustomerService.customers;

final filteredCustomers = customers.where((customer) {
  final query = _search.toLowerCase();

  return customer.name.toLowerCase().contains(query) ||
      customer.phone.toLowerCase().contains(query);
}).toList();
filteredCustomers.sort((a, b) {
  final aDays = a.endDate.difference(DateTime.now()).inDays;
  final bDays = b.endDate.difference(DateTime.now()).inDays;

  return aDays.compareTo(bDays);
});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mijozlar"),
      ),
      body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Mijozni qidiring...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _search = value;
          });
        },
      ),
    ),

    Expanded(
      child: customers.isEmpty
          ? const Center(
              child: Text("Hozircha mijozlar yo'q"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                final originalIndex = customers.indexOf(customer);

                return CustomerCard(
                  customer: customer,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCustomerPage(
                          customer: customer,
                          index: originalIndex,
                        ),
                      ),
                    );

                    setState(() {});
                  },
                  onDelete: () async {
                    await CustomerService.deleteCustomer(originalIndex);
                    setState(() {});
                  },
                );
                          },
            ),
    ),
  ],
),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}