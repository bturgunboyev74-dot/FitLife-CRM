import 'dart:io';
import 'package:flutter/material.dart';
import '../models/customer.dart';


class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CustomerCard({
    super.key,
    required this.customer,
    this.onTap,
    this.onDelete,
  });

  Color getStatusColor() {
    final days = customer.endDate.difference(DateTime.now()).inDays;

    if (days < 0) {
      return Colors.red;
    }

    if (days <= 7) {
      return Colors.orange;
    }

    return Colors.green;
  }

  String getStatusText() {
    final days = customer.endDate.difference(DateTime.now()).inDays;

    if (days < 0) {
      return "Abonement tugagan";
    }

    return "$days kun qoldi";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [

      CircleAvatar(
      radius: 28,
      backgroundImage: customer.photoPath != null
      ? FileImage(File(customer.photoPath!))
      : null,
      child: customer.photoPath == null
      ? const Icon(Icons.person)
      : null,
),

              const SizedBox(width:15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [

                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize:18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height:6),

                    Text(customer.phone),

                    const SizedBox(height:5),

                    Text(
                      customer.membership,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height:5),

                    Text(
                      "${customer.payment.toStringAsFixed(0)} so'm",
                    ),const SizedBox(height: 5),

Text(
  "Tugaydi: "
  "${customer.endDate.day.toString().padLeft(2, '0')}."
  "${customer.endDate.month.toString().padLeft(2, '0')}."
  "${customer.endDate.year}",
  style: const TextStyle(
    fontWeight: FontWeight.w600,
  ),
),

                    const SizedBox(height:8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal:12,
                        vertical:6,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: Text(
                        getStatusText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}