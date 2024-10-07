import 'package:flutter/material.dart';
import 'package:netshift/model/dns_model.dart';

class DNSSelector extends StatelessWidget {
  final List<DnsModel> dnsOptions;
  final DnsModel? selectedDNS;
  final void Function(DnsModel?) onSelected;
  final void Function(DnsModel) onEdit;
  final void Function(DnsModel) onDelete;

  const DNSSelector({
    super.key,
    required this.dnsOptions,
    required this.selectedDNS,
    required this.onSelected,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Center(
                        child: Text(
                          'Select DNS',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dnsOptions.length,
                        itemBuilder: (context, index) {
                          final dns = dnsOptions[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              title: Text(dns.name),
                              subtitle:
                                  Text('${dns.primary} / ${dns.secondary}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      onEdit(dns);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete DNS'),
                                          content: const Text(
                                              'Are you sure you want to delete this DNS?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                onDelete(dns);
                                                Navigator.pop(
                                                    context); // for alert dialog
                                                Navigator.pop(
                                                    context); // for bottom sheet
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
                              onTap: () {
                                onSelected(dns);
                                Navigator.pop(
                                    context); // for after dns selection
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            borderRadius: BorderRadius.circular(8.0),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDNS?.name ?? 'Select a DNS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ));
  }
}
