import 'package:flutter/material.dart';

import '../../models/customer.dart';
import '../../services/customer_service.dart';

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

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _paymentController;
  late TextEditingController _noteController;

  late String _membership;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.customer.name);

    _phoneController =
        TextEditingController(text: widget.customer.phone);

    _paymentController =
        TextEditingController(
      text: widget.customer.payment.toString(),
    );

    _noteController =
        TextEditingController(text: widget.customer.note);

    _membership = widget.customer.membership;
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
    final updatedCustomer = Customer(
      id: widget.customer.id,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      membership: _membership,
      startDate: widget.customer.startDate,
      endDate: widget.customer.endDate,
      payment:
          double.tryParse(_paymentController.text) ?? 0,
      note: _noteController.text.trim(),
      photoPath: widget.customer.photoPath,
    );

    await CustomerService.updateCustomer(
      widget.index,
      updatedCustomer,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {    return Scaffold(
      appBar: AppBar(
        title: const Text("Mijozni tahrirlash"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Ism",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ismni kiriting";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Telefon",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _paymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "To'lov",
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: "Izoh",
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
  initialValue: _membership,
  decoration: const InputDecoration(
    labelText: "Abonement",
  ),
  items: const [
    DropdownMenuItem(
      value: "1 oy",
      child: Text("1 oy"),
    ),
    DropdownMenuItem(
      value: "3 oy",
      child: Text("3 oy"),
    ),
    DropdownMenuItem(
      value: "6 oy",
      child: Text("6 oy"),
    ),
    DropdownMenuItem(
      value: "12 oy",
      child: Text("12 oy"),
    ),
  ],
  onChanged: (String? value) {
    if (value == null) return;

    setState(() {
      _membership = value;
    });
  },
),

              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    await _updateCustomer();
                  },
                  child: const Text(
                    "Yangilash",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}