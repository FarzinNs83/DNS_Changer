import 'package:flutter/material.dart';
import 'package:netshift/model/dns_model.dart';

class DNSDropdownButton extends StatelessWidget {
  final List<DnsModel> dnsOptions;
  final DnsModel? selectedDNS;
  final void Function(DnsModel?) onChanged;
  final void Function(DnsModel) onEdit;
  final void Function(DnsModel) onDelete;

  const DNSDropdownButton({
    super.key,
    required this.dnsOptions,
    required this.selectedDNS,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final validSelectedDNS =
        dnsOptions.contains(selectedDNS) ? selectedDNS : null;

    return DropdownButton<DnsModel>(
      elevation: 4,
      hint: const Text('Select a DNS'),
      value: validSelectedDNS,
      isExpanded: true,
      items: dnsOptions.map((DnsModel dns) {
        return DropdownMenuItem<DnsModel>(
          value: dns,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dns.name),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => onEdit(dns),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete DNS'),
                          content: const Text(
                              'Are you sure you want to delete this DNS?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onDelete(dns);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
