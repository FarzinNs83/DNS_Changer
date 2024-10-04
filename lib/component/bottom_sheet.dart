import 'package:flutter/material.dart';
import 'package:netshift/model/dns_model.dart';

class DNSBottomSheet extends StatelessWidget {
  final DnsModel? dnsToEdit;
  final void Function(DnsModel) onSave;

  const DNSBottomSheet({
    super.key,
    this.dnsToEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: dnsToEdit?.name ?? '');
    final TextEditingController primaryDNSController =
        TextEditingController(text: dnsToEdit?.primary ?? '');
    final TextEditingController secondaryDNSController =
        TextEditingController(text: dnsToEdit?.secondary ?? '');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'DNS Name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: primaryDNSController,
            decoration: const InputDecoration(
              labelText: 'Primary DNS',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: secondaryDNSController,
            decoration: const InputDecoration(
              labelText: 'Secondary DNS',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final primary = primaryDNSController.text.trim();
              final secondary = secondaryDNSController.text.trim();

              if (name.isNotEmpty &&
                  primary.isNotEmpty &&
                  secondary.isNotEmpty) {
                final newDns = DnsModel(
                    name: name, primary: primary, secondary: secondary);
                onSave(newDns);
                Navigator.pop(context);
              }
            },
            child: Text(dnsToEdit != null ? 'Update DNS' : 'Add DNS'),
          ),
        ],
      ),
    );
  }
}
