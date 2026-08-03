import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../models/payment.dart';
import '../../services/customer_service.dart';
import '../../services/payment_service.dart';
import '../../services/telegram_service.dart';

class AddPaymentPage extends StatefulWidget {
  const AddPaymentPage({super.key});

  @override
  State<AddPaymentPage> createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  late List<Customer> customers;

Customer? selectedCustomer;

String paymentMethod = "Naqd";
@override
void initState() {
  super.initState();

  customers = CustomerService.customers;

  if (customers.isNotEmpty) {
    selectedCustomer = customers.first;
  }
}

  @override
void dispose() {
  _amountController.dispose();
  _noteController.dispose();
  super.dispose();
}

DateTime calculateNewEndDate(
  DateTime currentEndDate,
  String membership,
) {
  final start = currentEndDate.isAfter(DateTime.now())
      ? currentEndDate
      : DateTime.now();

  if (membership == "1 kun") {
    return start.add(const Duration(days: 1));
  }

  int months = 1;

  switch (membership) {
    case "3 oy":
      months = 3;
      break;
    case "6 oy":
      months = 6;
      break;
    case "9 oy":
      months = 9;
      break;
    case "12 oy":
      months = 12;
      break;
  }

  return DateTime(
    start.year,
    start.month + months,
    start.day,
  );
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To'lov qo'shish"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Customer>(
  initialValue: selectedCustomer,
  decoration: const InputDecoration(
    labelText: "Mijoz",
    border: OutlineInputBorder(),
  ),
  items: customers.map((customer) {
    return DropdownMenuItem<Customer>(
      value: customer,
      child: Text(customer.name),
    );
  }).toList(),
  onChanged: (Customer? value) {
    setState(() {
      selectedCustomer = value;
    });
  },
),

const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Summa",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
  initialValue: paymentMethod,
  decoration: const InputDecoration(
    labelText: "To'lov usuli",
    border: OutlineInputBorder(),
  ),
  items: const [
    DropdownMenuItem(
      value: "Naqd",
      child: Text("Naqd"),
    ),
    DropdownMenuItem(
      value: "Click",
      child: Text("Click"),
    ),
    DropdownMenuItem(
      value: "Payme",
      child: Text("Payme"),
    ),
    DropdownMenuItem(
      value: "Uzum Bank",
      child: Text("Uzum Bank"),
    ),
  ],
  onChanged: (String? value) {
  if (value == null) return;

  setState(() {
    paymentMethod = value;
  });
},
),

const SizedBox(height: 16),

            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: "Izoh",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
 onPressed: () async {
  if (selectedCustomer == null) return;
  if (_amountController.text.isEmpty) return;

  try {
    final payment = Payment(
      customerId: selectedCustomer!.id,
      amount: double.parse(_amountController.text),
      date: DateTime.now(),
      method: paymentMethod,
      note: _noteController.text,
    );

    await PaymentService.addPayment(payment);

    selectedCustomer!.endDate = calculateNewEndDate(
      selectedCustomer!.endDate,
      selectedCustomer!.membership,
    );

      final index = CustomerService.customers.indexWhere(
      (c) => c.id == selectedCustomer!.id,
    );

    if (index != -1) {
  await CustomerService.updateCustomer(
    index,
    selectedCustomer!,
  );

  await TelegramService().sendPayment(
    customer: selectedCustomer!,
    payment: payment,
  );
}

    if (!context.mounted) return;

    Navigator.of(context).pop();

  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Xatolik: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
},
child: const Text("Saqlash"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}