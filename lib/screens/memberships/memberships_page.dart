import 'package:flutter/material.dart';

import '../../services/membership_service.dart';
import 'add_membership_page.dart';

class MembershipsPage extends StatefulWidget {
  const MembershipsPage({super.key});

  @override
  State<MembershipsPage> createState() => _MembershipsPageState();
}

class _MembershipsPageState extends State<MembershipsPage> {
  @override
  Widget build(BuildContext context) {
    final memberships = MembershipService.memberships;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Abonementlar"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMembershipPage(),
            ),
          );

          setState(() {});
        },
      ),
      body: memberships.isEmpty
          ? const Center(
              child: Text("Hozircha abonementlar mavjud emas"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: memberships.length,
              itemBuilder: (context, index) {
                final membership = memberships[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.card_membership),
                    ),
                    title: Text(
                      membership.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "${membership.months} oy\n"
                      "${membership.price.toStringAsFixed(0)} so'm",
                    ),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // keyin qo'shamiz
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            await MembershipService.deleteMembership(index);

                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}