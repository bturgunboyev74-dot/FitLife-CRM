import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../models/membership.dart';
import '../../services/customer_service.dart';
import '../../services/membership_service.dart';

class EditCustomerPage extends StatefulWidget {
  final Customer customer;
  final int index;

  const EditCustomerPage({
    super.key,
    required this.customer,
    required this.index,
  });

  @override
  State<EditCustomerPage> createState() => _EditCustomerPageState();
}

class _EditCustomerPageState extends State<EditCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _paymentController;
  late final TextEditingController _noteController;

  late List<Membership> memberships;
  Membership? selectedMembership;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.customer.name,
    );

    _phoneController = TextEditingController(
      text: widget.customer.phone,
    );

    _paymentController = TextEditingController(
      text: widget.customer.payment.toStringAsFixed(0),
    );

    _noteController = TextEditingController(
      text: widget.customer.note,
    );

    memberships = MembershipService.memberships;

    // Mijozning hozirgi abonementini topamiz
    try {
      selectedMembership = memberships.firstWhere(
        (membership) => membership.name == widget.customer.membership,
      );
    } catch (_) {
      selectedMembership = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _paymentController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _updateCustomer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedMembership == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Abonementni tanlang"),
        ),
      );
      return;
    }

    final payment = double.tryParse(
      _paymentController.text.trim(),
    );

    if (payment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("To'lov summasini to'g'ri kiriting"),
        ),
      );
      return;
    }

    final updatedCustomer = Customer(
      id: widget.customer.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      membership: selectedMembership!.name,

      // Mavjud boshlanish sanasini saqlaymiz
      startDate: widget.customer.startDate,

      // Abonement o'zgarsa ham muddatni qayta hisoblaymiz
      endDate: selectedMembership!.months == 0
          ? widget.customer.startDate.add(
              const Duration(days: 1),
            )
          : DateTime(
              widget.customer.startDate.year,
              widget.customer.startDate.month +
                  selectedMembership!.months,
              widget.customer.startDate.day,
            ),

      // Har bir mijoz uchun individual narx
      payment: payment,

      note: _noteController.text.trim(),
      photoPath: widget.customer.photoPath,
    );

    await CustomerService.updateCustomer(
      widget.index,
      updatedCustomer,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mijoz ma'lumotlari yangilandi"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mijozni tahrirlash"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Mijoz ismi",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Ismni kiriting";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Telefon",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<Membership>(
              initialValue: selectedMembership,
              decoration: const InputDecoration(
                labelText: "Abonement",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.card_membership),
              ),
              items: memberships.map((membership) {
                return DropdownMenuItem<Membership>(
                  value: membership,
                  child: Text(
                    "${membership.name} - "
                    "${membership.price.toStringAsFixed(0)} so'm",
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedMembership = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return "Abonementni tanlang";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _paymentController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "To'lov",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments),
                suffixText: "so'm",
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "To'lov summasini kiriting";
                }

                if (double.tryParse(value.trim()) == null) {
                  return "Summani to'g'ri kiriting";
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Izoh",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _updateCustomer,
                icon: const Icon(Icons.save),
                label: const Text(
                  "Yangilash",
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}