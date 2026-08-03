import 'package:flutter/material.dart';

import '../../models/membership.dart';
import '../../services/membership_service.dart';

class AddMembershipPage extends StatefulWidget {
  const AddMembershipPage({super.key});

  @override
  State<AddMembershipPage> createState() => _AddMembershipPageState();
}

class _AddMembershipPageState extends State<AddMembershipPage> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  int _selectedMonths = 1;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveMembership() async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty) {
      return;
    }

    final membership = Membership(
      name: _nameController.text.trim(),
      months: _selectedMonths,
      price: double.parse(_priceController.text),
    );

    await MembershipService.addMembership(membership);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangi abonement"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Abonement nomi",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              initialValue: _selectedMonths,
              decoration: const InputDecoration(
                labelText: "Abonement muddati",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text("1 kun"),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text("1 oy"),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text("3 oy"),
                ),
                DropdownMenuItem(
                  value: 6,
                  child: Text("6 oy"),
                ),
                DropdownMenuItem(
                  value: 9,
                  child: Text("9 oy"),
                ),
                DropdownMenuItem(
                  value: 12,
                  child: Text("12 oy"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedMonths = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: "Narxi",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveMembership,
                icon: const Icon(Icons.save),
                label: const Text("Saqlash"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}