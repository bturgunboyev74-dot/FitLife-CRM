import 'package:flutter/material.dart';
import '../../models/customer.dart';
import '../../services/customer_service.dart';
import 'dart:io';
import '../../models/membership.dart';
import '../../services/membership_service.dart';
import '../../services/telegram_service.dart';

import 'package:image_picker/image_picker.dart';
class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State<AddCustomerPage> createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _paymentController = TextEditingController();
  final _noteController = TextEditingController();


late List<Membership> memberships;

Membership? selectedMembership;

  File? _selectedImage;

final ImagePicker _picker = ImagePicker();

@override
void initState() {
  super.initState();

  memberships = MembershipService.memberships;

  if (memberships.isNotEmpty) {
    selectedMembership = memberships.first;
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
  Future<void> _pickImage() async {
  final XFile? image = await _picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (image == null) return;

  setState(() {
    _selectedImage = File(image.path);
  });
}
Future<void> _saveCustomer() async {
  if (!_formKey.currentState!.validate()) return;

  if (selectedMembership == null) return;

  final now = DateTime.now();

  final customer = Customer(
    id: now.millisecondsSinceEpoch.toString(),
    name: _nameController.text.trim(),
    phone: _phoneController.text.trim(),

    membership: selectedMembership!.name,

    startDate: now,

    endDate: selectedMembership!.months == 0
    ? now.add(const Duration(days: 1))
    : DateTime(
        now.year,
        now.month + selectedMembership!.months,
        now.day,
      ),

    payment: _paymentController.text.trim().isEmpty
    ? selectedMembership!.price
    : double.parse(_paymentController.text),

    note: _noteController.text.trim(),

    photoPath: _selectedImage?.path,
  );

  await CustomerService.addCustomer(customer);

// Telegramga avtomatik xabar yuborish
await TelegramService().sendNewCustomer(customer);

if (!mounted) return;

Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangi mijoz"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [Center(
  child: GestureDetector(
    onTap: _pickImage,
    child: CircleAvatar(
      radius: 55,
      backgroundImage:
          _selectedImage != null ? FileImage(_selectedImage!) : null,
      child: _selectedImage == null
          ? const Icon(
              Icons.camera_alt,
              size: 40,
            )
          : null,
    ),
  ),
),

const SizedBox(height: 20),
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

DropdownButtonFormField(
  initialValue: selectedMembership,
  decoration: const InputDecoration(
    labelText: "Abonement",
    border: OutlineInputBorder(),
  ),
  items: memberships.map((membership) {
    return DropdownMenuItem(
      value: membership,
      child: Text(
        "${membership.name} - ${membership.price.toStringAsFixed(0)} so'm",
      ),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedMembership = value;
    });
  },
),

const SizedBox(height: 16),
TextFormField(
  controller: _paymentController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: "To'lov",
    border: OutlineInputBorder(),
    prefixIcon: Icon(Icons.payments),
  ),
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

const SizedBox(height: 20),
SizedBox(
  height: 50,
  child: ElevatedButton.icon(
    onPressed: _saveCustomer,
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