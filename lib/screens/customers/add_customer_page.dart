import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/customer.dart';
import '../../models/membership.dart';

import '../../services/customer_service.dart';
import '../../services/membership_service.dart';
import '../../services/telegram_service.dart';

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

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  late List<Membership> memberships;

  Membership? selectedMembership;

  bool useDefaultPrice = true;

  @override
  void initState() {
    super.initState();

    memberships = MembershipService.memberships;

    if (memberships.isNotEmpty) {
      selectedMembership = memberships.first;

      _paymentController.text =
          selectedMembership!.price.toStringAsFixed(0);
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
    final image = await _picker.pickImage(
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
      endDate: DateTime(
        now.year,
        now.month + selectedMembership!.months,
        now.day,
      ),
      payment: double.parse(_paymentController.text),
      note: _noteController.text.trim(),
      photoPath: _selectedImage?.path,
    );

    await CustomerService.addCustomer(customer);

    await TelegramService().sendNewCustomer(customer);

    if (!mounted) return;

    Navigator.pop(context);
  }
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yangi mijoz"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // =======================
            // MIJOZ RASMI
            // =======================

            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : null,
                      child: _selectedImage == null
                          ? const Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // =======================
            // ISM
            // =======================

            TextFormField(
              controller: _nameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Ismni kiriting";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "Mijoz ismi",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // =======================
            // TELEFON
            // =======================

            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Telefon",
                hintText: "+998901234567",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 18),

            // =======================
            // ABONEMENT
            // =======================

            DropdownButtonFormField<Membership>(
              value: selectedMembership,
              decoration: const InputDecoration(
                labelText: "Abonement",
                prefixIcon: Icon(Icons.workspace_premium),
                border: OutlineInputBorder(),
              ),
              items: memberships.map((membership) {
                return DropdownMenuItem(
                  value: membership,
                  child: Text(
                    membership.name,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMembership = value;

                  if (useDefaultPrice && value != null) {
                    _paymentController.text =
                        value.price.toStringAsFixed(0);
                  }
                });
              },
            ),

            const SizedBox(height: 20),

            // =======================
            // STANDART NARX
            // =======================

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Standart narx",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "${selectedMembership?.price.toStringAsFixed(0) ?? "0"} so'm",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                                        const SizedBox(height: 15),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Standart narxdan foydalanish",
                      ),
                      value: useDefaultPrice,
                      onChanged: (value) {
                        setState(() {
                          useDefaultPrice = value!;

                          if (useDefaultPrice &&
                              selectedMembership != null) {
                            _paymentController.text =
                                selectedMembership!
                                    .price
                                    .toStringAsFixed(0);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // MIJOZ NARXI
            // =======================

            TextFormField(
              controller: _paymentController,
              enabled: !useDefaultPrice,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Narxni kiriting";
                }

                if (double.tryParse(value) == null) {
                  return "To'g'ri narx kiriting";
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: "Mijoz narxi",
                prefixIcon: Icon(Icons.payments),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // TUGASH SANASI
            // =======================

            Card(
              color: Colors.blue.shade50,
              elevation: 0,
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_month,
                  color: Colors.blue,
                ),
                title: const Text("Abonement tugash sanasi"),
                subtitle: Text(
                  selectedMembership == null
                      ? "-"
                      : "${DateTime(
                          DateTime.now().year,
                          DateTime.now().month +
                              selectedMembership!.months,
                          DateTime.now().day,
                        ).day}."
                        "${DateTime(
                          DateTime.now().year,
                          DateTime.now().month +
                              selectedMembership!.months,
                          DateTime.now().day,
                        ).month}."
                        "${DateTime(
                          DateTime.now().year,
                          DateTime.now().month +
                              selectedMembership!.months,
                          DateTime.now().day,
                        ).year}",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // =======================
            // IZOH
            // =======================

            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Izoh",
                prefixIcon: Icon(Icons.note_alt),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),            SizedBox(
              width: double.infinity,
              height: 55,
              child: FilledButton.icon(
                onPressed: _saveCustomer,
                icon: const Icon(Icons.save),
                label: const Text(
                  "Mijozni saqlash",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}